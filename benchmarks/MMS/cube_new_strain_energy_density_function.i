N = 32
[Mesh]
  type = GeneratedMesh
  elem_type = TET10
  dim = 3
  nx = ${N}
  ny = ${N}
  nz = ${N}
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
[Materials]
  [props]
    type = GenericConstantMaterial
    prop_names = 'mu1 mu2 mu3 mu4 beta3 beta4 rho'
    prop_values = '4 3 10 19 4 1e-3 0.1'
  []
  [orientation1]
    type = GenericConstantRankTwoTensor
    tensor_name = M1
    #   tensor_values = '0.500000000000000                   0  -0.500000000000000
    #                  0                   0                   0
    # -0.500000000000000                   0   0.500000000000000'
    tensor_values = '0.3 0 0 0 0.3 0 0 0 0.4'
  []
  [orientation2]
    type = GenericConstantRankTwoTensor
    tensor_name = M2
    #  tensor_values = '0.500000000000000                   0   0.500000000000000
    #                 0                   0                   0
    # 0.500000000000000                   0   0.500000000000000'
    tensor_values = '0.3 0 0 0 0.3 0 0 0 0.4'
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
  [xbody]
    type = BodyForce
    variable = 'disp_x'
    function = '(2*exp(z))/25 + (9*exp(z)*(exp(2*z) + 30000)^(1/2))/10000 + '
               '(13053*exp(3*z)*exp((229*exp(4*z))/25000000000000))/31250000 + '
               '(996379*exp(7*z)*exp((229*exp(4*z))/25000000000000))/195312500000000000000 + '
               '(9*exp(3*z))/(10000*(exp(2*z) + 30000)^(1/2))'
  []
  # [ybody]
  #   type = BodyForce
  #   variable = 'disp_y'
  #   function = '-(19*exp(((y/100 + 1)^2/3 + x^2/30000 - 1/3)^2)*(y + 100)*(x^4 + 2*x^2*y^2 + 400*x^2*y + y^4 + 400*y^3 + 40000*y^2 + 450000000))/2531250000000'
  # []
  [zbody]
    type = BodyForce
    variable = 'disp_z'
    function = '(exp(2*z)*((9*(exp(2*z) + 30000)^(1/2))/100 + 4))/7500 - '
               '(4351*exp(2*z)*exp((229*exp(4*z))/25000000000000))/156250 - '
               '(996379*exp(6*z)*exp((229*exp(4*z))/25000000000000))/1953125000000000000 + '
               '(3*exp(4*z))/(500000*(exp(2*z) + 30000)^(1/2))'
  []
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
  [xfix]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = 'top bottom left right front back'
    function = '-0.01*exp(z)'
    preset = false
  []
  [yfix]
    type = FunctionDirichletBC
    variable = 'disp_y'
    boundary = 'top bottom left right front back'
    function = 0
    preset = false
  []
  [zfix]
    type = FunctionDirichletBC
    variable = 'disp_z'
    boundary = 'top bottom left right front back'
    function = 0
    preset = false
  []
[]
[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist                 '
  automatic_scaling = true
  line_search = none
  nl_abs_tol = 1e-12
[]
[Outputs]
  [exodus]
    type = Exodus
    file_base = 'displacements'
  []
[]
[Postprocessors]
  [err]
    type = ElementVectorL2Error
    # function_x = '0.01*exp(z)'
    function_x = '-0.01*exp(z)'
    function_y = 0
    function_z = 0
    var_x = disp_x
    var_y = disp_y
    var_z = disp_z
  []
[]
