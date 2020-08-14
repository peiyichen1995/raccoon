E = 3.0e4
nu = 0.2
Gc = 1.0e-4
l = 0.02
psic = 1.5e-4
k = 0
dc = 2

[Problem]
  type = FixedPointProblem
[]

[Mesh]
   construct_side_list_from_node_list = true
   parallel_type = distributed
  [./mesh]
   type = FileMeshGenerator
   file = 'trapz/wedgeRegular.msh'
  [../]
  [./all_nodes]
   type = BoundingBoxNodeSetGenerator
   input = mesh
   new_boundary = all_nodes
   bottom_left = '-0.01 -4.01 -0.01'
   top_right = '4.01 4.81 0.11'
  [../]
  # [./bottomLeft]
  #  type = BoundingBoxNodeSetGenerator
  #  input = all_nodes
  #  new_boundary = bottomLeft
  #  bottom_left = '-0.01 -0.01 -0.01'
  #  top_right = '0.01 0.80 0.11'
  # [../]
  # [./topLeft]
  #  type = BoundingBoxNodeSetGenerator
  #  input = bottomLeft
  #  new_boundary = topLeft
  #  bottom_left = '-0.01 0.80 -0.01'
  #  top_right = '0.01 1.61 0.11'
  # [../]
  # [./right]
  #  type = BoundingBoxNodeSetGenerator
  #  input = topLeft
  #  new_boundary = right
  #  bottom_left = '3.99 -4.01 -0.01'
  #  top_right = '4.01 4.81 0.11'
  # [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./d]
  [../]
[]

[AuxVariables]
  [./bounds_dummy]
  [../]
[]

[UserObjects]
  [./E_driving]
    type = ADFPIMaterialPropertyUserObject
    mat_prop = 'E_el_active'
  [../]
[]

[Bounds]
  [./irreversibility]
    type = VariableOldValueBoundsAux
    variable = 'bounds_dummy'
    bounded_variable = 'd'
    bound_type = lower
  [../]
  [./upper]
    type = ConstantBoundsAux
    variable = 'bounds_dummy'
    bounded_variable = 'd'
    bound_type = upper
    bound_value = 1
  [../]
[]

[Kernels]
  [./solid_x]
    type = ADStressDivergenceTensors
    variable = 'disp_x'
    component = 0
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./solid_y]
    type = ADStressDivergenceTensors
    variable = 'disp_y'
    component = 1
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./solid_z]
    type = ADStressDivergenceTensors
    variable = 'disp_z'
    component = 2
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./pff_diff]
    type = ADPFFDiffusion
    variable = 'd'
  [../]
  [./pff_barrier]
    type = ADPFFBarrier
    variable = 'd'
  [../]
  [./pff_react]
    type = ADPFFReaction
    variable = 'd'
    driving_energy_uo = 'E_driving'
    lag = false
  [../]
[]

[BCs]
  [./upwardLoad]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = 'topLeft'
    function = '0.05*t'
  [../]
  [./downwardLoad]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = 'bottomLeft'
    function = '-0.05*t'
  [../]
  [./fixedRightX]
    type = DirichletBC
    variable = 'disp_x'
    boundary = 'right'
    value = 0
  [../]
  [./fixedRightY]
    type = DirichletBC
    variable = 'disp_y'
    boundary = 'right'
    value = 0
  [../]
  [./fixedZ]
    type = DirichletBC
    variable = 'disp_z'
    boundary = 'all_nodes'
    value = 0
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = ${E}
    poissons_ratio = ${nu}
  [../]
  [./strain]
    type = ADComputeSmallStrain
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./stress]
    type = SmallStrainDegradedElasticPK2Stress_NoSplit
    d = 'd'
    d_crit = ${dc}
    degradation_mat = 'g'
  [../]
  [./bulk]
    type = GenericConstantMaterial
    prop_names = 'phase_field_regularization_length energy_release_rate critical_fracture_energy'
    prop_values = '${l} ${Gc} ${psic}'
  [../]
  [./local_dissipation]
    type = LinearLocalDissipation
    d = 'd'
  [../]
  [./fracture_properties]
    type = FractureMaterial
    local_dissipation_norm = 8/3
  [../]
  [./degradation]
    type = LorentzDegradation
    d = 'd'
    residual_degradation = ${k}
  [../]
  [./elastic_energy]
    type = ElasticEnergyDensity
  [../]
[]

[Executioner]
  type = FixedPointTransient
  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason'
  petsc_options_iname = '-pc_type pc_type_mat_solver_package -sub_pc_type -ksp_max_it -ksp_gmres_restart -sub_pc_factor_levels -snes_type'
  petsc_options_value = 'lu       superlu_dist                ilu          200         200                0                     vinewtonrsls'
  dt = 1
  end_time = 100

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-06
  line_search = none

  automatic_scaling = true
  compute_scaling_once = false

  fp_max_its = 10
  fp_tol = 1e-06
  accept_on_max_fp_iteration = true
[]

[Postprocessors]
  # [./helmholtz_energy]
  #   type = HelmholtzEnergy
  #   d = d
  #   pressure_mat = 'p'
  #   fracture_energy_name = 'fracture_energy'
  # [../]
  [./fracture_energy]
    type = FractureEnergy
    d = d
  [../]
[]

[Outputs]
  print_linear_residuals = true
  [./exodus]
    type = Exodus
    file_base = 'trapezoid'
  [../]
  [./console]
    type = Console
    outlier_variable_norms = false
  [../]
[]
