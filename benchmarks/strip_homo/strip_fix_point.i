eps = 1e-3
[Mesh]
  second_order = true
  displacements = 'disp_x disp_y disp_z'
  [gen]
    type = GeneratedMeshGenerator
    elem_type = TET10
    dim = 3
    xmin = 0
    ymin = 0
    zmin = 0
    xmax = 7.21
    ymax = 2.81
    zmax = 0.32
    nx = 60
    ny = 10
    nz = 1
  []
  [L1]
    type = BoundingBoxNodeSetGenerator
    input = gen
    new_boundary = 'L1'
    top_right = '${fparse 0-eps} ${fparse 0-eps} ${fparse 0-eps}'
    bottom_left = '${fparse 0+eps} ${fparse 0+eps} ${fparse 0+eps}'
  []
  [L2]
    type = BoundingBoxNodeSetGenerator
    input = L1
    new_boundary = 'L2'
    top_right = '${fparse 0-eps} ${fparse 2.81-eps} ${fparse 0-eps}'
    bottom_left = '${fparse 0+eps} ${fparse 2.81+eps} ${fparse 0+eps}'
  []
  [L3]
    type = BoundingBoxNodeSetGenerator
    input = L2
    new_boundary = 'L3'
    top_right = '${fparse 0-eps} ${fparse 2.81-eps} ${fparse 0.32-eps}'
    bottom_left = '${fparse 0+eps} ${fparse 2.81+eps} ${fparse 0.32+eps}'
  []
  [L4]
    type = BoundingBoxNodeSetGenerator
    input = L3
    new_boundary = 'L4'
    top_right = '${fparse 0-eps} ${fparse 0-eps} ${fparse 0.32-eps}'
    bottom_left = '${fparse 0+eps} ${fparse 0+eps} ${fparse 0.32+eps}'
  []
  [L5]
    type = BoundingBoxNodeSetGenerator
    input = L4
    new_boundary = 'L5'
    top_right = '${fparse 7.21-eps} ${fparse 0-eps} ${fparse 0-eps}'
    bottom_left = '${fparse 7.21+eps} ${fparse 0+eps} ${fparse 0+eps}'
  []
  [L6]
    type = BoundingBoxNodeSetGenerator
    input = L5
    new_boundary = 'L6'
    top_right = '${fparse 7.21-eps} ${fparse 2.81-eps} ${fparse 0-eps}'
    bottom_left = '${fparse 7.21+eps} ${fparse 2.81+eps} ${fparse 0+eps}'
  []
  [L7]
    type = BoundingBoxNodeSetGenerator
    input = L6
    new_boundary = 'L7'
    top_right = '${fparse 7.21-eps} ${fparse 2.81-eps} ${fparse 0.32-eps}'
    bottom_left = '${fparse 7.21+eps} ${fparse 2.81+eps} ${fparse 0.32+eps}'
  []
  [L8]
    type = BoundingBoxNodeSetGenerator
    input = L7
    new_boundary = 'L8'
    top_right = '${fparse 7.21-eps} ${fparse 0-eps} ${fparse 0.32-eps}'
    bottom_left = '${fparse 7.21+eps} ${fparse 0+eps} ${fparse 0.32+eps}'
  []
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
  [f]
    order = SECOND
  []
  [F11]
    family = MONOMIAL
  []
  [F12]
    family = MONOMIAL
  []
  [F13]
    family = MONOMIAL
  []
  [F21]
    family = MONOMIAL
  []
  [F22]
    family = MONOMIAL
  []
  [F23]
    family = MONOMIAL
  []
  [F31]
    family = MONOMIAL
  []
  [F32]
    family = MONOMIAL
  []
  [F33]
    family = MONOMIAL
  []
  [strain_energy_density]
    family = MONOMIAL
  []
[]
[Materials]
  [props]
    type = GenericConstantMaterial
    prop_names = 'mu1 mu2 mu3 mu4 beta3 beta4'
    # prop_values = '${g1} ${g2} ${g3} 22.8165 ${beta3} 364.1307'
    # prop_values = '4.1543 1.5 9.7227 19.285 3.6537 500.02'
    # prop_values = '7.6389 3.9445 9.7000 2.6671 3.6000 16.4347'
    # prop_values = '4.405990 1.156614 10.546827 16.232309 3.473211 378.691948'
    prop_values = '2.2706 3.6132 9.7000 2.8213 3.6000 4.8334'
  []
  [orientation1]
    type = GenericConstantRankTwoTensor
    tensor_name = M1
    tensor_values = '0.9570 -0.2028 0 -0.2028 0.0430 0 0 0 0'
    # tensor_values = '0.3 0 0 0 0.3 0 0 0 0.4'
  []
  [orientation2]
    type = GenericConstantRankTwoTensor
    tensor_name = M2
    tensor_values = '0.9570 0.2028 0  0.2028 0.0430 0 0 0 0'
    # tensor_values = '0.3 0 0 0 0.3 0 0 0 0.4'
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
    save_in = f
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
  [F11]
    type = ADRankTwoAux
    variable = 'F11'
    rank_two_tensor = deformation_gradient
    index_i = 0
    index_j = 0
  []
  [F12]
    type = ADRankTwoAux
    variable = 'F12'
    rank_two_tensor = deformation_gradient
    index_i = 0
    index_j = 1
  []
  [F13]
    type = ADRankTwoAux
    variable = 'F13'
    rank_two_tensor = deformation_gradient
    index_i = 0
    index_j = 2
  []
  [F21]
    type = ADRankTwoAux
    variable = 'F21'
    rank_two_tensor = deformation_gradient
    index_i = 1
    index_j = 0
  []
  [F22]
    type = ADRankTwoAux
    variable = 'F22'
    rank_two_tensor = deformation_gradient
    index_i = 1
    index_j = 1
  []
  [F23]
    type = ADRankTwoAux
    variable = 'F23'
    rank_two_tensor = deformation_gradient
    index_i = 1
    index_j = 2
  []
  [F31]
    type = ADRankTwoAux
    variable = 'F31'
    rank_two_tensor = deformation_gradient
    index_i = 2
    index_j = 0
  []
  [F32]
    type = ADRankTwoAux
    variable = 'F32'
    rank_two_tensor = deformation_gradient
    index_i = 2
    index_j = 1
  []
  [F33]
    type = ADRankTwoAux
    variable = 'F33'
    rank_two_tensor = deformation_gradient
    index_i = 2
    index_j = 2
  []
  [strain_energy_density]
    type = ADMaterialRealAux
    variable = 'strain_energy_density'
    property = strain_energy_density
  []
[]
[BCs]
  [xfix]
    type = DirichletBC
    variable = 'disp_x'
    boundary = 'L5'
    value = 0
    preset = false
  []
  [yfix]
    type = DirichletBC
    variable = 'disp_y'
    boundary = 'L5'
    value = 0
    preset = false
  []
  [zfix]
    type = DirichletBC
    variable = 'disp_z'
    boundary = 'L1 L2 L5 L6'
    value = 0
    preset = false
  []
  [xrightfix]
    type = FunctionDirichletBC
    variable = 'disp_x'
    boundary = 'L1 L2 L3 L4'
    function = '-0.1*t*0.721'
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
  end_time = 28
[]
[Outputs]
  [csv]
    type = CSV
    file_base = './iden_s_e/paper2/stress_xx_sample_${sample}'
  []
  exodus = true
[]
[Postprocessors]
  [stress_xx]
    type = PointValue
    variable = 'stress_xx'
    point = '5 1.5 0.25'
  []
  [F]
    type = NodalSum
    variable = f
    boundary = 'right'
  []
  [A]
    type = AreaPostprocessor
    boundary = 'right'
    use_displaced_mesh = true
  []
[]
[VectorPostprocessors]
  [Data]
    type = ElementValueSampler
    variable = 'F11 F12 F13 F21 F22 F23 F31 F32 F33 strain_energy_density'
    sort_by = id
  []
[]