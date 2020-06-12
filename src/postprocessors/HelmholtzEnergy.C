//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "HelmholtzEnergy.h"

registerMooseObject("raccoonApp", HelmholtzEnergy);

InputParameters
HelmholtzEnergy::validParams()
{
  InputParameters params = ElementIntegralPostprocessor::validParams();
  params.addClassDescription("computes the Helmholtz free-energy of the system"
                                " - includes only the elastic energy, the fracture energy and"
                                " a contribution from the pressure loads");
  params.addRequiredCoupledVar("d", "damage variable");
  params.addParam<MaterialPropertyName>("pressure_mat", "pressure inside the crack");
  params.addParam<MaterialPropertyName>("elastic_energy_name", "E_el", "name of the elastic energy density material");
  params.addParam<PostprocessorName>("fracture_energy_name","name of the fracture energy postprocessor");
  return params;
}

HelmholtzEnergy::HelmholtzEnergy(const InputParameters & parameters)
  : ElementIntegralPostprocessor(parameters),
    _E_el(getADMaterialPropertyByName<Real>(getParam<MaterialPropertyName>("elastic_energy_name"))),
    _d(adCoupledValue("d")),
    _strain(getADMaterialPropertyByName<RankTwoTensor>("mechanical_strain")),
    _p(getADMaterialProperty<Real>("pressure_mat")),
    _fracture_energy(getPostprocessorValueByName(getParam<PostprocessorName>("fracture_energy_name")))
{
}

Real
HelmholtzEnergy::computeQpIntegral()
{
  ADReal elasticTerm = _E_el[_qp];
  ADReal mixedTerm = _p[_qp] * (1 - _d[_qp]) * _strain[_qp].trace();
  return elasticTerm.value() + mixedTerm.value();
}

Real
HelmholtzEnergy::getValue()
{
  gatherSum(_integral_value);
  return _integral_value + _fracture_energy;
}
