[Mesh]
 [./gmg]
  type = GeneratedMeshGenerator
  dim = 1
  nx = 10000
  xmin = -5
  xmax = 5
 [../]
 [./middle_nodes]
  type = BoundingBoxNodeSetGenerator
  input = 'gmg'
  new_boundary = middle_nodes
  bottom_left = '-0.001 0 0'
  top_right = '0.001 0 0'
 [../]
[]

[Variables]
  [./d]
  [../]
[]

[AuxVariables]
  [./load]
    family = SCALAR
  [../]
  [./E_el]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./d_ref]
  [../]
  [./bounds_dummy]
  [../]
  [./disp_x]
  [../]
[]

[UserObjects]
  [./pressure_uo]
    type = ADFPIMaterialPropertyUserObject
    mat_prop = 'p'
  [../]
[]

# [Bounds]
#   [./irreversibility]
#     type = VariableOldValueBoundsAux
#     variable = 'bounds_dummy'
#     bounded_variable = 'd'
#     bound_type = lower
#   [../]
#   [./upper]
#     type = ConstantBoundsAux
#     variable = 'bounds_dummy'
#     bounded_variable = 'd'
#     bound_type = upper
#     bound_value = 1
#   [../]
# []

[Kernels]
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
    driving_energy_var = 'E_el'
    lag = false
  [../]
  [./pff_pressure]
    type = ADPFFPressure
    variable = 'd'
    pressure_uo = 'pressure_uo'
    displacements = 'disp_x'
  [../]
[]

# [BCs]
#   [./damage]
#     type = DirichletBC
#     variable = 'd'
#     boundary = 'middle_nodes'
#     value = 1
#   [../]
# []

[ICs]
  [./d]
    type = BrittleDamageIC
    variable = d
    d0 = 1.0
    l = ${l}
    x1 = -0.01
    y1 = 0
    z1 = 0
    x2 = 0.01
    y2 = 0
    z2 = 0
  [../]
[]

[Materials]
  [./pressure]
    type = ADGenericFunctionMaterial
    prop_names = 'p'
    prop_values = '1e-2'
  [../]
  [./fracture_energy_barrier]
    type = GenericFunctionMaterial
    prop_names = 'energy_release_rate phase_field_regularization_length critical_fracture_energy'
    prop_values = '${Gc} ${l} ${psic}'
  [../]
  [./local_dissipation]
    type = QuadraticLocalDissipation
    d = 'd'
  [../]
  [./fracture_properties]
    type = FractureMaterial
    local_dissipation_norm = 2
  [../]
  [./degradation]
    type = QuadraticDegradation
    d = 'd'
    residual_degradation = ${k}
  [../]
  # [./elastic_energy]
  #   type = ElasticEnergyDensity
  # [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -snes_type'
  petsc_options_value = 'lu vinewtonrsls'
  dt = 1e-6

  nl_abs_tol = 1e-08
  nl_rel_tol = 1e-06
[]

[Outputs]
  print_linear_residuals = false
  [./console]
    type = Console
    hide = 'load'
    outlier_variable_norms = false
  [../]
[]
