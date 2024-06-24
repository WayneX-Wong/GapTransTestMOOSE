[Mesh]
    [FMG]
      type = FileMeshGenerator
      file = Gap_transfer.e
    []
    # [Diag]
    #   type = MeshDiagnosticsGenerator
    #   input = FMG
    #   examine_element_volumes = ERROR
    #   examine_non_conformality = ERROR
    #   check_local_jacobian = ERROR
    # []
[]

[Variables]
    [./T]
      initial_condition = 800
    [../]
[]
  
[Kernels]
    [./diff_m]
      type = HeatConduction
      variable = T
    [../]
    [./source_m]
      type = BodyForce
      variable = T
      value = 2.145313
    [../]
    [./time]
      type = HeatConductionTimeDerivative
      variable = T
    []
[]

[BCs]
    [./fix_temp]
      type = DirichletBC
      boundary = 'outer_heat_source'
      variable = T
      value = 800
      preset = false
    [../]
    [./adiabatic]
      type = NeumannBC
      boundary = 'bottom top inner_heat_source outer_structure'
      variable = T
    [../]
[]

[ThermalContact]
    [GapTrans]
      type = GapHeatTransfer
      variable = T
      primary = 'top_heat_source'
      secondary = 'bottom_structure'
      emissivity_primary = 0.6
      emissivity_secondary = 0.35
      gap_conductivity = 0.15
      quadrature = false
    []
[]

[Materials]
    [./k]
      type = ParsedMaterial
      property_name = thermal_conductivity
      coupled_variables = T
      expression = '(12.17 + 0.038 * (T - 273.15)) / 100'
      block = 'heat_source structure'
    [../]
    [./cp]
      type = ParsedMaterial
      property_name = specific_heat
      coupled_variables = T
      expression = '0.158'
      block = 'heat_source structure'
    []
    [./rou]
      type = ParsedMaterial
      property_name = density
      coupled_variables = T
      expression = '18.2'
      block = 'heat_source structure'
    []
[]
  
[Postprocessors]
    [./ave_temp_heat_source]
        type = ElementAverageValue
        variable = T
        block = 'heat_source'
    []
    [./ave_temp_structure]
        type = ElementAverageValue
        variable = T
        block = 'structure'
    []
[]
  
[Executioner]
    type = Transient
    automatic_scaling = true

    end_time = 10
    dt = 1e-3
[]

[Outputs]
    exodus = true
    csv = true
    print_linear_residuals = false
[]