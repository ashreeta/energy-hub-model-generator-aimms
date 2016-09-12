%% GENERATE VARIABLES FOR AMS FILE

%% ENERGY CONVERSION TECHNOLOGY VARIABLES

header_variables_declaration_section = '\n\tDeclarationSection Variables {';

%variable denoting input energy streams of energy conversion devices
variable_input_streams = '';
if create_variable_input_streams == 1
	variable_input_streams = '\n\t\tVariable Input_energy {\n\t\t\tIndexDomain: (t,conv);\n\t\t\tRange: nonnegative;\n\t\t}';
end

%variable denoting exported energy
variable_exported_energy = '';
if create_variable_exported_energy == 1
    variable_exported_energy = '\n\t\tVariable Exported_energy {\n\t\t\tIndexDomain: (t,x) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
end

%binary variable denoting the installation of a technology
variable_technology_installation = '';
if create_variable_technology_installation == 1
    variable_technology_installation = '\n\t\tVariable Installation {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tRange: binary;\n\t\t}';
end

%binary variable denoting the operation or not of a dispatchable technology
variable_technology_operation = '';
if create_variable_technology_operation == 1
    dispatchable_techs_including_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    variable_technology_operation = strcat('\n\t\tVariable Operation {\n\t\t\tIndexDomain: (t,conv) | (conv = ',index_domain_string,');\n\t\t\tRange: binary;\n\t\t}');
end

%variable denoting the generation capacity of a technology
variable_technology_capacity = '';
if create_variable_technology_capacity == 1
    variable_technology_capacity = '\n\t\tVariable Capacity {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t}';
end

%variable denoting the electricity output energy of a technology
variable_electricity_output = '';
if create_variable_electricity_output == 1
    variable_electricity_output = '\n\t\tVariable Output_energy_electricity  {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Elec'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Elec'',conv);\n\t\t}';
end

%variable denoting the heat output energy of a technology
variable_heat_output = '';
if create_variable_heat_output == 1
    variable_heat_output = '\n\t\tVariable Output_energy_heat {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Heat'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Heat'',conv);\n\t\t}';
end

%variable denoting the cooling output energy of a technology
variable_cool_output = '';
if create_variable_cool_output == 1
    variable_cool_output = '\n\t\tVariable Output_energy_cool {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Cool'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Cool'',conv);\n\t\t}';
end

footer_variables_declaration_section = '\n\t}';

%% ENERGY STORAGE TECHNOLOGY VARIABLES

header_storage_declaration_section = '\n\tDeclarationSection Storage {';

if simplified_storage_representation == 0

    %variable denoting the storage charging rate
    variable_storage_charge_rate = '';
    if create_variable_storage_charge_rate == 1
        variable_storage_charge_rate = '\n\t\tVariable Storage_input_energy {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %variable denoting the storage discharging rate
    variable_storage_discharge_rate = '';
    if create_variable_storage_discharge_rate == 1
        variable_storage_discharge_rate = '\n\t\tVariable Storage_output_energy {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %variable denoting the state of charge of a storage
    variable_storage_soc = '';
    if create_variable_storage_soc == 1
        variable_storage_soc = '\n\t\tVariable Storage_SOC {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %variable denoting the capacity of a storage
    variable_storage_capacity = '';
    if create_variable_storage_capacity == 1
        variable_storage_capacity = '\n\t\tVariable Storage_capacity {\n\t\t\tIndexDomain: (x,stor) | Smatrix(x,stor) > 0;\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %binary variable denoting the intallation of a storage
    variable_storage_installation = '';
    if create_variable_storage_installation == 1
        variable_storage_installation = '\n\t\tVariable Installation_storage {\n\t\t\tIndexDomain: (x,stor) | Smatrix(x,stor) > 0;\n\t\t\tRange: binary;\n\t\t}';
    end

else
    
    %variable denoting the storage charging rate
    variable_storage_charge_rate = '';
    if create_variable_storage_charge_rate == 1
        variable_storage_charge_rate = '\n\t\tVariable Storage_input_energy {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %variable denoting the storage discharging rate
    variable_storage_discharge_rate = '';
    if create_variable_storage_discharge_rate == 1
        variable_storage_discharge_rate = '\n\t\tVariable Storage_output_energy {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %variable denoting the state of charge of a storage
    variable_storage_soc = '';
    if create_variable_storage_soc == 1
        variable_storage_soc = '\n\t\tVariable Storage_SOC {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %variable denoting the capacity of a storage
    variable_storage_capacity = '';
    if create_variable_storage_capacity == 1
        variable_storage_capacity = '\n\t\tVariable Storage_capacity {\n\t\t\tIndexDomain: x;\n\t\t\tRange: nonnegative;\n\t\t}';
    end

    %binary variable denoting the intallation of a storage
    variable_storage_installation = '';
    if create_variable_storage_installation == 1
        variable_storage_installation = '\n\t\tVariable Installation_storage {\n\t\t\tIndexDomain: x;\n\t\t\tRange: binary;\n\t\t}';
    end
    
end

footer_storage_declaration_section = '\n\t}';

%compile variables to string
variables_section = strcat(header_variables_declaration_section,variable_input_streams,variable_exported_energy,variable_technology_installation,variable_technology_operation,...
    variable_technology_capacity,variable_electricity_output,variable_heat_output,variable_cool_output,footer_variables_declaration_section,...
    header_storage_declaration_section,variable_storage_charge_rate,variable_storage_discharge_rate,variable_storage_soc,variable_storage_capacity,variable_storage_installation,footer_storage_declaration_section);
