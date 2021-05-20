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
  [stress_xx]
    family = MONOMIAL
  []
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
    prop_names = 'mu1 mu2 mu3 mu4 beta3 beta4 rho'
    prop_values = '${mu1}
    ${mu2}
    9.7
    ${mu4}
    3.6
    ${beta4}
    ${rho}'
    # prop_values = '0 0 9.7 4.41336 3.6 11.257 0.260609'
  []
  [orientation]
    type = TissueOrientation
    phi1 = 'phi1'
    phi2 = 'phi2'
    angle = ${alpha}
    # alpha = 0.3665
    # alpha = 0.8076
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
[AuxKernels]
  [stress_xx]
    type = ADRankTwoAux
    variable = 'stress_xx'
    rank_two_tensor = cauchy_stress
    index_i = 0
    index_j = 0
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
    boundary = '7'
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

  line_search = 'none'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-6

  automatic_scaling = true

  dt = 1
  end_time = 20
[]

[Outputs]
  [exodus]
    type = Exodus
    file_base = 'displacements'
  []
  [csv]
    type = CSV
    file_base = './output/complex_1'
  []
[]

[Postprocessors]
  [stress_xx]
    type = PointValue
    variable = 'stress_xx'
    point = '0.15685 3.42683 0.646004'
  []
[]
