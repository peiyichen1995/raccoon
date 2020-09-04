//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "NeoHookeanElasticPK1Stress.h"
#include "Assembly.h"

registerADMooseObject("raccoonApp", NeoHookeanElasticPK1Stress);

InputParameters
NeoHookeanElasticPK1Stress::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Compute stress using the Neo-Hookean hyperelastic model");
  params.addParam<std::string>("base_name",
                               "Optional parameter that allows the user to define "
                               "multiple mechanics material systems on the same "
                               "block, i.e. for multiple phases");
  params.addParam<MaterialPropertyName>("mu1", "mu1", "mu1 in the Neo-Hookean model");
  params.addParam<MaterialPropertyName>("mu2", "mu2", "mu2 in the Neo-Hookean model");
  params.addParam<MaterialPropertyName>("mu3", "mu3", "mu3 in the Neo-Hookean model");
  params.addParam<MaterialPropertyName>("mu4", "mu4", "mu4 for the tissue term");
  params.addParam<MaterialPropertyName>("beta3", "beta3", "beta3 in the Neo-Hookean model");
  params.addParam<MaterialPropertyName>("beta4", "beta4", "beta4 for the tissue term");
  params.addParam<MaterialPropertyName>("M1", "M1", "first orientation tensor in the tissue term");
  params.addParam<MaterialPropertyName>("M2", "M2", "second orientation tensor in the tissue term");
  return params;
}

NeoHookeanElasticPK1Stress::NeoHookeanElasticPK1Stress(const InputParameters & parameters)
  : Material(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _F(getADMaterialPropertyByName<RankTwoTensor>(_base_name + "deformation_gradient")),
    _C(getADMaterialPropertyByName<RankTwoTensor>(_base_name + "mechanical_strain")),
    _mu1(getMaterialProperty<Real>("mu1")),
    _mu2(getMaterialProperty<Real>("mu2")),
    _mu3(getMaterialProperty<Real>("mu3")),
    _mu4(getMaterialProperty<Real>("mu4")),
    _beta3(getMaterialProperty<Real>("beta3")),
    _beta4(getMaterialProperty<Real>("beta4")),
    _M1(getMaterialProperty<RankTwoTensor>("M1")),
    _M2(getMaterialProperty<RankTwoTensor>("M2")),
    _stress(declareADProperty<RankTwoTensor>(_base_name + "stress")),
    _cauchy_stress(declareADProperty<RankTwoTensor>(_base_name + "cauchy_stress")),
    _current_elem_volume(_assembly.elemVolume())
{
}

void
NeoHookeanElasticPK1Stress::computeProperties()
{
  ADReal Theta = 0;
  ADReal pressure = 0;

  // Theta
  for (_qp = 0; _qp < _qrule->n_points(); ++_qp)
    Theta += _F[_qp].det() * _JxW[_qp] * _coord[_qp];
  Theta /= _current_elem_volume;

  // pressure
  for (_qp = 0; _qp < _qrule->n_points(); ++_qp)
    pressure += _mu3[_qp] * _beta3[_qp] *
                (std::pow(Theta, _beta3[_qp] - 1) - std::pow(Theta, -_beta3[_qp] - 1)) * _JxW[_qp] *
                _coord[_qp];
  pressure /= _current_elem_volume;

  // stress
  for (_qp = 0; _qp < _qrule->n_points(); ++_qp)
    computeQpStress(pressure);
}

void
NeoHookeanElasticPK1Stress::computeQpStress(ADReal pressure)
{
  ADRankTwoTensor I2(ADRankTwoTensor::initIdentity);
  ADReal J = _F[_qp].det();
  ADRankTwoTensor C_bar = std::pow(J, -2 / 3) * _C[_qp];
  ADRankTwoTensor C_bar_inv = C_bar.inverse();
  ADRankTwoTensor C_bar_cof = C_bar.det() * C_bar_inv;
  ADRankTwoTensor S_bar =
      2 * _mu1[_qp] * I2 + 3 * _mu2[_qp] * std::sqrt(C_bar_cof.trace()) *
                               (C_bar_cof * C_bar_inv.trace() - C_bar_cof * C_bar_inv);

  ADRankFourTensor P_deviator =
      std::pow(J, -2 / 3) * ((I2.mixedProductIkJl(I2) + I2.mixedProductIlJk(I2)) / 2 -
                             _C[_qp].inverse().outerProduct(_C[_qp]) / 3);

  /// isochoric stress
  ADRankTwoTensor S_isc = P_deviator * S_bar;

  /// volumetric stress
  ADRankTwoTensor S_vol = pressure * J * _C[_qp].inverse();

  /// tissue stress
  ADReal e1 = _C[_qp].doubleContraction(_M1[_qp]) - 1;
  ADReal e2 = _C[_qp].doubleContraction(_M2[_qp]) - 1;
  ADReal e1pos = e1 > 0 ? e1 : 0;
  ADReal e2pos = e2 > 0 ? e2 : 0;


  ADRankTwoTensor S_ti_1 = 4 * _mu4[_qp] * e1pos * std::exp(_beta4[_qp] * e1pos * e1pos) * _M1[_qp];
  ADRankTwoTensor S_ti_2 = 4 * _mu4[_qp] * e2pos * std::exp(_beta4[_qp] * e2pos * e2pos) * _M2[_qp];

  _stress[_qp] = _F[_qp] * (S_isc + S_vol + S_ti_1 + S_ti_2);

  _cauchy_stress[_qp] = _stress[_qp] * _F[_qp].transpose() / J;
}
