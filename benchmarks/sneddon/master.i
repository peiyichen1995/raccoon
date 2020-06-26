E = 1
nu = 0
Gc = 1e-3
l = 0.1
psic = 0
k = 1e-6
dc = 1

[Problem]
  solve = false
[]

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

[MultiApps]
  [./mechanical]
    type = TransientMultiApp
    input_files = 'mechanical.i'
    app_type = raccoonApp
    execute_on = 'TIMESTEP_BEGIN'
    sub_cycling = true
    detect_steady_state = true
    steady_state_tol = 1e-6
    cli_args = 'E=${E};nu=${nu};Gc=${Gc};l=${l};psic=${psic};k=${k};dc=${dc}'
  [../]
[]

[Transfers]
  [./send_load]
    type = MultiAppScalarToAuxScalarTransfer
    multi_app = mechanical
    direction = to_multiapp
    source_variable = 'load'
    to_aux_scalar = 'load'
  [../]
  [./get_d_ref]
    type = MultiAppCopyTransfer
    multi_app = mechanical
    direction = from_multiapp
    source_variable = 'd'
    variable = 'd'
    execute_on = 'TIMESTEP_END'
  [../]
  [./send_d_ref]
    type = MultiAppCopyTransfer
    multi_app = mechanical
    direction = to_multiapp
    source_variable = 'd'
    variable = 'd_ref'
    execute_on = 'TIMESTEP_BEGIN'
  [../]
[]

[AuxVariables]
  [./load]
    family = SCALAR
  [../]
  [./d]
  [../]
[]

# [ICs]
#   [./d]
#     type = BrittleDamageIC
#     variable = d
#     d0 = 1.0
#     l = ${l}
#     x1 = 0
#     y1 = 0
#     z1 = 0
#     x2 = 0
#     y2 = 0
#     z2 = 0
#   [../]
# []

[AuxScalarKernels]
  [./load]
    type = FunctionScalarAux
    variable = 'load'
    function = '0'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  [../]
[]

[Executioner]
  type = Transient
  dt = 1e-4
  end_time = 2e-4
[]
