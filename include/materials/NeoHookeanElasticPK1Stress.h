//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Material.h"

class NeoHookeanElasticPK1Stress : public Material
{
public:
  static InputParameters validParams();

  NeoHookeanElasticPK1Stress(const InputParameters & parameters);

  virtual void computeProperties() override;

protected:
  virtual void computeQpStress(ADReal pressure);

  /// base name of the stress
  const std::string _base_name;

  /// deformation gradient
  const ADMaterialProperty<RankTwoTensor> & _F;

  /// right Cauchy-Green strain
  const ADMaterialProperty<RankTwoTensor> & _C;

  /// material properties
  const MaterialProperty<Real> & _mu1;
  const MaterialProperty<Real> & _mu2;
  const MaterialProperty<Real> & _mu3;
  const MaterialProperty<Real> & _mu4;
  const MaterialProperty<Real> & _beta3;
  const MaterialProperty<Real> & _beta4;
  const MaterialProperty<RankTwoTensor> & _M1;
  const MaterialProperty<RankTwoTensor> & _M2;

  /// stress
  ADMaterialProperty<RankTwoTensor> & _stress;
  ADMaterialProperty<RankTwoTensor> & _cauchy_stress;

  /// strain energy density
  ADMaterialProperty<Real> & _strain_energy_density;

  const Real & _current_elem_volume;
};
