E = 2.1e5
nu = 0.3
Gc = 2.7
l = 0.2
psic = 1.5
k = 0
dc = 2

[Problem]
  type = FixedPointProblem
[]

[Mesh]
   type = GeneratedMesh
   dim = 3
   xmin = -1
   xmax = 1
   ymin = -1
   ymax = 1
   zmin = -1
   zmax = 1
   nx = 1
   ny = 1
   nz = 1
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
  [./loadRight]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = 'right'
    function = '0.00002*t'
  [../]
  [./fixedYRight]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = 'right'
    function = '0'
  [../]
  [./fixedZRight]
    type = FunctionDirichletBC
    variable = 'disp_z'
    boundary = 'right'
    function = '0'
  [../]
  [./fixedLeft]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = 'left'
    function = '-1e-7*t'
  [../]
  [./fixedYLeft]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = 'left'
    function = '0'
  [../]
  [./fixedZLeft]
    type = FunctionDirichletBC
    variable = 'disp_z'
    boundary = 'left'
    function = '0'
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
    type = SmallStrainDegradedElasticPK2Stress_StrainVolDev
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
  petsc_options_iname = '-pc_type -sub_pc_type -ksp_max_it -ksp_gmres_restart -sub_pc_factor_levels -snes_type'
  petsc_options_value = 'lu      ilu          200         200                0                     vinewtonrsls'
  dt = 1
  end_time = 885

  nl_abs_tol = 1e-06
  nl_rel_tol = 1e-06

  automatic_scaling = true
  compute_scaling_once = false

  fp_max_its = 0
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
  print_linear_residuals = false
  [./exodus]
    type = Exodus
    file_base = 'LorentzTest1D'
  [../]
  [./console]
    type = Console
    outlier_variable_norms = false
  [../]
[]
