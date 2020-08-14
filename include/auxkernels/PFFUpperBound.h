//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "BoundsAuxBase.h"
#include "FEProblem.h"
#include "FPIMaterialPropertyUserObject.h"

/**
 * Provides a bound of a variable using a coupled variable.
 */
class PFFUpperBound : public BoundsAuxBase
{
public:
  static InputParameters validParams();

  PFFUpperBound(const InputParameters & parameters);

protected:
  virtual Real getBound() override;

  FEProblemBase & _fe_problem;

  const ADMaterialPropertyUserObject & _D_uo;

  const ADMaterialProperty<Real> & _b;
};
