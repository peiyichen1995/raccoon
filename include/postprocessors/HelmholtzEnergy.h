//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ElementIntegralPostprocessor.h"

class HelmholtzEnergy : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  HelmholtzEnergy(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;
  virtual Real getValue() override;
  const ADMaterialProperty<Real> & _E_el;
  const ADVariableValue & _d;
  const ADMaterialProperty<RankTwoTensor> & _strain;
  const ADMaterialProperty<Real> & _p;
  const PostprocessorValue & _fracture_energy;
};
