//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "PFFUpperBound.h"
#include "SwapBackSentinel.h"

registerMooseObject("raccoonApp", PFFUpperBound);

InputParameters
PFFUpperBound::validParams()
{
  InputParameters params = BoundsAuxBase::validParams();
  params.addClassDescription("Provides the upper or lower bound using a coupled variable");
  params.suppressParameter<MooseEnum>("bound_type");
  params.addRequiredParam<UserObjectName>("driving_energy_uo",
                                          "userobject that has driving energy values at qps");
  params.addParam<MaterialPropertyName>(
      "critical_fracture_energy_name", "critical_fracture_energy", "critical fracture energy");
  return params;
}

PFFUpperBound::PFFUpperBound(const InputParameters & parameters)
  : BoundsAuxBase(parameters),
    _fe_problem(*parameters.get<FEProblemBase *>("_fe_problem_base")),
    _D_uo(getUserObject<ADMaterialPropertyUserObject>("driving_energy_uo")),
    _b(getADMaterialProperty<Real>("critical_fracture_energy_name"))
{
}

Real
PFFUpperBound::getBound()
{
  // activate dependent material properties
  std::set<unsigned int> needed_mat_props;
  const std::set<unsigned int> & mp_deps = getMatPropDependencies();
  needed_mat_props.insert(mp_deps.begin(), mp_deps.end());
  _fe_problem.setActiveMaterialProperties(needed_mat_props, _tid);

  // get node-to-conneted-elem map
  const std::map<dof_id_type, std::vector<dof_id_type>> & node_to_elem_map = _mesh.nodeToElemMap();
  auto node_to_elem_pair = node_to_elem_map.find(_current_node->id());
  mooseAssert(node_to_elem_pair != node_to_elem_map.end(), "Missing entry in node to elem map");
  std::vector<dof_id_type> elem_ids = node_to_elem_pair->second;

  // check if we should freeze the damage variable
  for (auto elem_id : elem_ids)
  {
    const Elem * elem = _mesh.elemPtr(elem_id);

    if (!elem->is_semilocal(_mesh.processor_id()))
      mooseError("skipped non local elem!");

    _fe_problem.prepare(elem, _tid);
    _fe_problem.reinitElem(elem, _tid);

    // Set up Sentinel class so that, even if reinitMaterials() throws, we
    // still remember to swap back during stack unwinding.
    SwapBackSentinel sentinel(_fe_problem, &FEProblem::swapBackMaterials, _tid);
    _fe_problem.reinitMaterials(elem->subdomain_id(), _tid);

    for (_qp = 0; _qp < _q_point.size(); _qp++)
      if (_D_uo.getRawData(elem, _qp) < _b[_qp])
        return _var.getNodalValueOld(*_current_node);
  }

  _fe_problem.clearActiveMaterialProperties(_tid);

  return 1.0;
}
