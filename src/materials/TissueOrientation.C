//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "TissueOrientation.h"

registerADMooseObject("raccoonApp", TissueOrientation);

InputParameters
TissueOrientation::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("computes the tissue orientation.");
  params.addRequiredCoupledVar("phi1", "solution of the first diffusion problem, inner to outer");
  params.addRequiredCoupledVar("phi2", "solution of the first diffusion problem, inlet to outlet");
  params.addParam<MaterialPropertyName>("alpha", "alpha", "angle between two tissues");
  params.addParam<MaterialPropertyName>("M1", "M1", "name of the first tissue orientation");
  params.addParam<MaterialPropertyName>("M2", "M2", "name of the first tissue orientation");

  return params;
}

TissueOrientation::TissueOrientation(const InputParameters & parameters)
  : Material(parameters),
    _grad_phi1(coupledGradient("phi1")),
    _grad_phi2(coupledGradient("phi2")),
    _alpha(getMaterialProperty<Real>("alpha")),
    _M1(declareProperty<RankTwoTensor>(getParam<MaterialPropertyName>("M1"))),
    _M2(declareProperty<RankTwoTensor>(getParam<MaterialPropertyName>("M2")))
{
}

void
TissueOrientation::computeQpProperties()
{
  RealVectorValue e1 = _grad_phi1[_qp] / _grad_phi1[_qp].norm();
  RealVectorValue e3 = _grad_phi2[_qp] / _grad_phi2[_qp].norm();
  RealVectorValue e2 = e1.cross(e3);

  RealVectorValue a1 = std::cos(_alpha[_qp]) * e1 + std::sin(_alpha[_qp]) * e2;
  RealVectorValue a2 = std::cos(_alpha[_qp]) * e1 - std::sin(_alpha[_qp]) * e2;

  _M1[_qp].vectorOuterProduct(a1, a1);
  _M2[_qp].vectorOuterProduct(a2, a2);
}
