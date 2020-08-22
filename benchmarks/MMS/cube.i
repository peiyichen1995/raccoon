[Mesh]
  type = GeneratedMesh
  elem_type = TET10
  dim = 3
  nx = 16
  ny = 16
  nz = 16
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
    prop_names = 'mu1 mu2 mu3 mu4 beta3 beta4'
    prop_values = '4 3 10 19 4 1'
  []
  [orientation1]
    type = GenericConstantRankTwoTensor
    tensor_name = M1
    tensor_values = '0.5 -0.5 0 -0.5 0.5 0 0 0 0'
  []
  [orientation2]
    type = GenericConstantRankTwoTensor
    tensor_name = M2
    tensor_values = '0 0 0 0 1 0 0 0 0'
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
    function = '-(exp(z)*(4860000000000*exp(2*z) - 421200000000*exp(3*z) + 202500000*exp(4*z) - 18360000*exp(5*z) + 2700*exp(6*z) - 243*exp(7*z) - 1944000000000000*exp(z) - 3200*exp(z)*(exp(2*z) + 30000)^(5/2) + 120000*(exp(2*z) + 30000)^(5/2) + 36450000000000000))/(1500000*(exp(2*z) + 30000)^(5/2))'
  []
  [ybody]
    type = BodyForce
    variable = 'disp_y'
    function = '-(exp(2*z)*(421200000000*exp(2*z) + 18360000*exp(4*z) + 243*exp(6*z) - 6400*(exp(2*z) + 30000)^(5/2) + 1944000000000000))/(3000000*(exp(2*z) + 30000)^(5/2))'
  []
  [zbody]
    type = BodyForce
    variable = 'disp_z'
    function = '-(exp(z)*(2126250000000000*exp(2*z) - 1417500000000*exp(3*z) + 283500000000*exp(4*z) - 54000000*exp(5*z) + 11340000*exp(6*z) - 675*exp(7*z) + 144*exp(8*z) - 12150000000000000*exp(z) - 20000*exp(z)*(exp(2*z) + 30000)^(5/2) + 2700*exp(2*z)*(exp(2*z) + 30000)^(5/2) + 3000000*(exp(2*z) + 30000)^(5/2) + 911250000000000000))/(37500000*(exp(2*z) + 30000)^(5/2))'
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
    function = '0.01*exp(z)'
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
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
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
    function_x = '0.01*exp(z)'
    function_y = 0
    function_z = 0
    var_x = disp_x
    var_y = disp_y
    var_z = disp_z
  []
[]
