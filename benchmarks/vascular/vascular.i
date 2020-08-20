[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'gold/laplace.e'
    use_for_exodus_restart = true
  []
  [pin]
    type = ExtraNodesetGenerator
    input = fmg
    new_boundary = 'pin'
    nodes = '267652'
  []
  second_order = true
[]

[Variables]
  [disp_x]
    order = SECOND
  []
  [disp_y]
    order = SECOND
  []
  [disp_z]
    order = SECOND
  []
[]

[AuxVariables]
  [phi1]
    order = SECOND
    initial_from_file_var = 'phi1'
  []
  [phi2]
    order = SECOND
    initial_from_file_var = 'phi2'
  []
[]

[Materials]
  [props]
    type = GenericConstantMaterial
    prop_names = 'mu1 mu2 mu3 mu4 beta3 beta4'
    prop_values = '4.1543 2.5084 9.7227 19.285 3.6537 500.02'
  []
  [orientation]
    type = TissueOrientation
    phi1 = 'phi1'
    phi2 = 'phi2'
    alpha = 0.8076
  []
  [strain]
    type = RCGStrain
    displacements = 'disp_x disp_y disp_z'
  []
  [stress]
    type = NeoHookeanElasticPK1Stress
  []
[]

[Kernels]
  [solid_x]
    type = ADStressDivergenceTensors
    variable = 'disp_x'
    component = 0
    displacements = 'disp_x disp_y disp_z'
  []
  [solid_y]
    type = ADStressDivergenceTensors
    variable = 'disp_y'
    component = 1
    displacements = 'disp_x disp_y disp_z'
  []
  [solid_z]
    type = ADStressDivergenceTensors
    variable = 'disp_z'
    component = 2
    displacements = 'disp_x disp_y disp_z'
  []
[]

[BCs]
  [Pressure]
    [inner]
      boundary = 1
      function = 't'
      displacements = 'disp_x disp_y disp_z'
    []
  []
  [xfix]
    type = DirichletBC
    variable = 'disp_x'
    value = 0
    boundary = '1'
  []
  [yfix]
    type = DirichletBC
    variable = 'disp_y'
    value = 0
    boundary = 'pin'
  []
  [zfix]
    type = DirichletBC
    variable = 'disp_z'
    value = 0
    boundary = 'pin'
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'

  dt = 1
  end_time = 20
[]

[Outputs]
  [exodus]
    type = Exodus
    file_base = 'displacements'
  []
[]
