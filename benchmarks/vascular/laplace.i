[Mesh]
  type = FileMesh
  file = 'gold/media_flatboundaries.msh'
  second_order = true
[]

[Variables]
  [phi1]
    order = SECOND
  []
  [phi2]
    order = SECOND
  []
[]

[Kernels]
  [diff1]
    type = Diffusion
    variable = 'phi1'
  []
  [diff2]
    type = Diffusion
    variable = 'phi2'
  []
[]

[BCs]
  [inlet]
    type = DirichletBC
    variable = 'phi1'
    boundary = 7
    value = 0
  []
  [outlet]
    type = DirichletBC
    variable = 'phi1'
    boundary = 8
    value = 1
  []
  [inner]
    type = DirichletBC
    variable = 'phi2'
    boundary = 1
    value = 0
  []
  [outer]
    type = DirichletBC
    variable = 'phi2'
    boundary = 5
    value = 1
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -sub_pc_type -ksp_max_it -ksp_gmres_restart -sub_pc_factor_levels'
  petsc_options_value = 'asm      ilu          200         200                0                    '
[]

[Outputs]
  [exodus]
    type = Exodus
    file_base = 'laplace'
  []
[]
