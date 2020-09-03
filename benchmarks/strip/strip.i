# [Mesh]
#   type = GeneratedMesh
#   elem_type = TET10
#   dim = 3
#   xmin = 0
#   xmax = 10
#   ymin = 0
#   ymax = 3
#   zmin = 0
#   zmax = 0.5
#   nx = 4
#   ny = 2
#   nz = 1
#   second_order = true
# []

[Mesh]
  type = FileMesh
  file = 'fields.e'
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
  [mu1]
    initial_from_file_var = 'mu1'
  []
  [mu2]
    initial_from_file_var = 'mu2'
  []
  [mu3]
    initial_from_file_var = 'mu3'
  []
  [mu4]
    initial_from_file_var = 'mu4'
  []
  [beta3]
    initial_from_file_var = 'beta3'
  []
  [beta4]
    initial_from_file_var = 'beta4'
  []
[]

[Materials]
  # [props]
  #   type = GenericConstantMaterial
  #   prop_names = 'mu1 mu2 mu3 mu4 beta3 beta4'
  #   prop_values = '2 1 5 10 2 150'
  # []
  [mu1]
    type = ParsedMaterial
    f_name = 'mu1'
    args = 'mu1'
    function = 'mu1'
  []
  [mu2]
    type = ParsedMaterial
    f_name = 'mu2'
    args = 'mu2'
    function = 'mu2'
  []
  [mu3]
    type = ParsedMaterial
    f_name = 'mu3'
    args = 'mu3'
    function = 'mu3'
  []
  [mu4]
    type = ParsedMaterial
    f_name = 'mu4'
    args = 'mu4'
    function = 'mu4'
  []
  [beta3]
    type = ParsedMaterial
    f_name = 'beta3'
    args = 'beta3'
    function = 'beta3'
  []
  [beta4]
    type = ParsedMaterial
    f_name = 'beta4'
    args = 'beta4'
    function = 'beta4'
  []
  [orientation1]
    type = GenericConstantRankTwoTensor
    tensor_name = M1
    tensor_values = '0.4778    0.4995         0
    0.4995    0.5222         0
         0         0         0'
  []
  [orientation2]
    type = GenericConstantRankTwoTensor
    tensor_name = M2
    tensor_values = '0.4778   -0.4995         0
   -0.4995    0.5222         0
         0         0         0'
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
  [xfix]
    type = DirichletBC
    variable = 'disp_x'
    boundary = 'left'
    value = 0
    preset = false
  []
  [yfix]
    type = DirichletBC
    variable = 'disp_y'
    boundary = 'left'
    value = 0
    preset = false
  []
  [zfix]
    type = DirichletBC
    variable = 'disp_z'
    boundary = 'left'
    value = 0
    preset = false
  []
  [xrightfix]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = 'right'
    function = '0.1*t'
    preset = false
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
  end_time = 30
[]

[Outputs]
  [exodus]
    type = Exodus
    file_base = 'displacements'
  []
  [csv]
      type = CSV
    file_base = 'stress_xx'
  []
[]

[Postprocessors]
  [stress_xx]
    type = PointValue
    variable = 'stress_xx'
    point = '5 1.5 0.25'
  []
[]
