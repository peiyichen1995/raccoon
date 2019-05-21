[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  type = FileMesh
  file = 'gold/mesh.msh'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./d]
  [../]
[]

[AuxVariables]
  [./dummy]
  [../]
[]

[Kernels]
  [./solid_x]
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./solid_y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
  [./inertia_x]
    type = InertialForce
    variable = disp_x
    use_displaced_mesh = false
  [../]
  [./inertia_y]
    type = InertialForce
    variable = disp_y
    use_displaced_mesh = false
  [../]
  [./damage]
    type = PFFractureADTest
    variable = d
  [../]
[]

[Bounds]
  [./d]
    type = BoundsAux
    bounded_variable = d
    variable = dummy
    upper = 1.0
    lower = 0.0
  [../]
[]

[BCs]
  [./impact]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 'impact'
    function = 'if( t<1e-6, 0.5*1.65e10*t*t, 1.65e4*t-0.5*1.65e-2)'
  [../]
[]

[Materials]
  [./density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = 8e-9
  [../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.9e5
    poissons_ratio = 0.3
  [../]
  [./strain]
    type = RCGStrain
  [../]
  [./stress]
    type = CNHDegradedPK1Stress
  [../]
  [./fracture]
    type = FractureMaterial
    d = d
    Gc = 22.2
    L = 0.3
    local_dissipation_norm = 0.6666666666666667
  [../]
  [./degradation]
    type = DegradationLorentz
    d = d
  [../]
  [./barrier]
    type = StationaryGenericFunctionMaterial
    prop_names = 'b'
    prop_values = '7.9'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -sub_pc_type -ksp_max_it -ksp_gmres_restart -sub_pc_factor_levels -snes_type'
  petsc_options_value = 'asm      ilu          200         200                0                     vinewtonrsls'

  end_time = 8.5e-5
  dt = 5e-8

  nl_rel_tol = 1e-06

  [./TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
  [../]
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
  interval = 2
[]