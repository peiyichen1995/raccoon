//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Material.h"

class TissueOrientation : public Material
{
public:
  static InputParameters validParams();

  TissueOrientation(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  const VariableGradient & _grad_phi1;
  const VariableGradient & _grad_phi2;
  const MaterialProperty<Real> & _alpha;
  MaterialProperty<RankTwoTensor> & _M1;
  MaterialProperty<RankTwoTensor> & _M2;
};
