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
    prop_values = '4 3 10 19 4 500'
  []
  [orientation1]
    type = GenericConstantRankTwoTensor
    tensor_name = M1
    tensor_values = '0.500000000000000                   0  -0.500000000000000
                   0                   0                   0
  -0.500000000000000                   0   0.500000000000000'
  []
  [orientation2]
    type = GenericConstantRankTwoTensor
    tensor_name = M2
    tensor_values = '0.500000000000000                   0   0.500000000000000
                   0                   0                   0
   0.500000000000000                   0   0.500000000000000'
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
    function = '(14435193*exp((x^2*(x + 100)^2)/50000))/31250 + (28899*x^2*exp((x^2*(x + 100)^2)/50000))/156250 + (36*x)/(3125*(x + 50)) - (288*x)/(125*(x + 50)^2) + (432*x)/(5*(x + 50)^3) + (4200000000000*x)/(x + 50)^9 - (630000000000000*x)/(x + 50)^10 + 72/(125*(x + 50)) - 288/(5*(x + 50)^2) + 1440/(x + 50)^3 - 525000000000/(x + 50)^8 + 210000000000000/(x + 50)^9 - 15750000000000000/(x + 50)^10 + (14363031*exp((x^2*(x + 100)^2)/50000)*(x + 50)^4)/781250000 - (9671*exp((x^2*(x + 100)^2)/50000)*(x + 50)^8)/4882812500000 - (19*exp((x^2*(x + 100)^2)/50000)*(x + 50)^12)/122070312500000000 - (72*x^2)/(3125*(x + 50)^2) + (216*x^2)/(125*(x + 50)^3) + (36*x^3)/(3125*(x + 50)^3) - (6300000000000*x^2)/(x + 50)^10 + (57798*x*exp((x^2*(x + 100)^2)/50000))/3125 + (19399*x^2*exp((x^2*(x + 100)^2)/50000)*(x + 50)^4)/1953125000 + (19*x^2*exp((x^2*(x + 100)^2)/50000)*(x + 50)^8)/12207031250000 - (16*2^(2/3)*5^(1/3))/(5*(x + 50)^(8/3)) + (1280*2^(2/3)*5^(1/3))/(x + 50)^(11/3) - (704000*2^(2/3)*5^(1/3))/(9*(x + 50)^(14/3)) + (19399*x*exp((x^2*(x + 100)^2)/50000)*(x + 50)^4)/19531250 + (19*x*exp((x^2*(x + 100)^2)/50000)*(x + 50)^8)/122070312500 - (139218750000*2^(1/2))/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(19/3)) - (527343750000000000*2^(1/2))/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(31/3)) - (704*2^(2/3)*5^(1/3)*x^2)/(15*(x + 50)^(14/3)) + (98560*2^(2/3)*5^(1/3)*x^2)/(27*(x + 50)^(17/3)) + (9856*2^(2/3)*5^(1/3)*x^3)/(405*(x + 50)^(17/3)) - (4134375000*2^(1/2)*x)/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(19/3)) - (28125000000000000*2^(1/2)*x)/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(31/3)) + (128*2^(2/3)*5^(1/3)*x)/(5*(x + 50)^(11/3)) - (14080*2^(2/3)*5^(1/3)*x)/(3*(x + 50)^(14/3)) + (9856000*2^(2/3)*5^(1/3)*x)/(81*(x + 50)^(17/3)) - (40500000*2^(1/2)*x^2)/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(19/3)) - (270000*2^(1/2)*x^3)/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(19/3)) - (527343750000000*2^(1/2)*x^2)/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(31/3)) - (3515625000000*2^(1/2)*x^3)/(((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(31/3)) - 6/3125'
  []
  [ybody]
    type = BodyForce
    variable = 'disp_y'
    function = '(10456237792968750000000000*2^(1/2)*x + 83427429199218750000000000*2^(1/2) + 588441467285156250000000*2^(1/2)*x^2 + 19555389404296875000000*2^(1/2)*x^3 + 424033813476562500000*2^(1/2)*x^4 + 6255944824218750000*2^(1/2)*x^5 + 63538330078125000*2^(1/2)*x^6 + 437827148437500*2^(1/2)*x^7 + 1922167968750*2^(1/2)*x^8 + 4271484375*2^(1/2)*x^9 - 227812500000000000*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 6075000000000000*x*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 425250000000000*x^2*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 17010000000000*x^3*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 425250000000*x^4*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 6804000000*x^5*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 68040000*x^6*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 388800*x^7*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) - 972*x^8*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(13/3) + 28125000000000*2^(2/3)*5^(1/3)*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(14/3) + 25000000000*2^(2/3)*5^(1/3)*x^2*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(14/3) - 2500000*2^(2/3)*5^(1/3)*x^4*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(14/3) - 10000*2^(2/3)*5^(1/3)*x^5*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(14/3) + 1562500000000*2^(2/3)*5^(1/3)*x*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(14/3))/(6328125*((x^2 + 100*x + 3750)/(x + 50)^(4/3))^(5/2)*(x + 50)^(34/3))'
  []
  # [zbody]
  #   type = BodyForce
  #   variable = 'disp_z'
  #   function = 0
  # []
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
    function = '0.01*x*x'
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
    # function_x = '0.01*exp(z)'
    function_x = '0.01*x*x'
    function_y = 0
    function_z = 0
    var_x = disp_x
    var_y = disp_y
    var_z = disp_z
  []
[]
