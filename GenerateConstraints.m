%% GENERATE CONSTRAINTS FOR AMS FILE

%% GENERATE CONVERSION TECHNOLOGY CONSTRAINTS

header_constraints_declaration_section = '\n\tDeclarationSection Energy_conversion_constraints {';

%energy balance constraint
constraint_energy_balance = '';
if apply_constraint_energy_balance == 1
    if simplified_storage_representation == 0
        constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + sum(stor, (Storage_output_energy(t,stor) - Storage_input_energy(t,stor)) * Smatrix(x,stor)) = Loads(t,x) + Exported_energy(t,x);\n\t\t}';
    else
        constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + Storage_output_energy(t,x) - Storage_input_energy(t,x) = Loads(t,x) + Exported_energy(t,x);\n\t\t}';
    end
end

%capacity violation constraint
constraint_capacity = '';
if apply_constraint_capacity == 1
    index_domain_string = '';
    for t=1:length(dispatchable_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_technologies(t)),'''');
        if t < length(dispatchable_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_capacity = strcat('\n\t\tConstraint Capacity_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Capacity(x,conv);\n\t\t}');
end

%max allowable capacity constraint
constraint_max_capacity = '';
non_solar_energy_conversion_technologies_excluding_chp_and_grid = technologies.conversion_techs_names(intersect(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),...
    find(~strcmp(technologies.conversion_techs_outputs,'CHP'))),find(~strcmp(technologies.conversion_techs_names,'Grid'))));
if apply_constraint_max_capacity == 1
    max_capacities_index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies_excluding_chp_and_grid)
        max_capacities_index_domain_string = strcat(max_capacities_index_domain_string,'''',char(non_solar_energy_conversion_technologies_excluding_chp_and_grid(t)),'''');
        if t < length(non_solar_energy_conversion_technologies_excluding_chp_and_grid)
             max_capacities_index_domain_string = strcat(max_capacities_index_domain_string,' OR conv = '); 
        end
    end
    constraint_max_capacity = strcat('\n\t\tConstraint Maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',max_capacities_index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv) <= Max_allowable_capacity(conv);\n\t\t}');
end

%minimum allowable part-load constraint
constraint_min_part_load1 = '';
if apply_constraint_min_part_load1 == 1
    dispatchable_techs_including_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_min_part_load1 = strcat('\n\t\tConstraint Dispatch_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Big_M * Operation(t,conv);\n\t\t}');
end

%another minimum allowable part-load constraint
constraint_min_part_load2 = '';
if apply_constraint_min_part_load2 == 1
    dispatchable_techs_including_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_min_part_load2 = strcat('\n\t\tConstraint Part_load_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv)) >= Minimum_part_load(x,conv) * Capacity(x,conv);\n\t\t}');
end

%solar availability constraint
constraint_solar_availability = '';
if apply_constraint_solar_availability == 1
    index_domain_string = '';
    for t=1:length(solar_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(solar_technologies(t)),'''');
        if t < length(solar_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
	constraint_solar_availability = strcat('\n\t\tConstraint Solar_input_constraint {\n\t\t\tIndexDomain: (t,conv,x) | Cmatrix(x, conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) = Solar_radiation(t) * Capacity(x,conv) / 1000;\n\t\t}');
end

%roof area constraint
constraint_roof_area = '';
solar_technologies_with_electrical_output = technologies.conversion_techs_names(intersect(find(strcmp(technologies.conversion_techs_inputs,'Solar')),find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'}))));
solar_technologies_with_heat_output = technologies.conversion_techs_names(intersect(find(ismember(technologies.conversion_techs_inputs,'Solar')),find(ismember(technologies.conversion_techs_outputs,{'Heat','CHP'}))));
if apply_constraint_roof_area == 1
    constraint_definition_string = '';
    for t = 1:length(solar_technologies_with_electrical_output)
        if t > 1
            constraint_definition_string = strcat(constraint_definition_string,'+');
        end
        constraint_definition_string = strcat(constraint_definition_string,'Capacity(''Elec'',''',char(solar_technologies_with_electrical_output(t)),''')');        
    end
    for t = 1:length(solar_technologies_with_heat_output)
        constraint_definition_string = strcat(constraint_definition_string,'+');
        constraint_definition_string = strcat(constraint_definition_string,'Capacity(''Heat'',''',char(solar_technologies_with_heat_output(t)),''')');
    end
    constraint_roof_area = strcat('\n\t\tConstraint Roof_area_constraint {\n\t\t\tDefinition: ',constraint_definition_string,' <= Building_roof_area;\n\t\t}');
end

%fixed cost constraint
constraint_fixed_cost = '';
if apply_constraint_fixed_cost == 1
    constraint_fixed_cost = '\n\t\tConstraint Installation_constraint {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: Capacity(x,conv) <= Big_M * Installation(x,conv);\n\t\t}';
end

%operation constraint
constraint_operation = '';
if apply_constraint_operation == 1
    dispatchable_techs_including_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_operation = strcat('\n\t\tConstraint Operation_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Operation(t,conv) <= Installation(x,conv);\n\t\t}');
end

constraint_electricity_export = '';
if apply_constraint_electricity_export == 1
    constraint_electricity_export = '\n\t\tConstraint Electricity_export {\n\t\t\tIndexDomain: (t,x,conv) | x=''Elec'' AND conv=''Grid'';\n\t\t\tDefinition: Exported_energy(t,x) <= Big_M * (1 - Operation(t,conv));\n\t\t}';
end

%heat-to-power ratio constraint
constraint_htp_ratio = '';
if apply_constraint_htp_ratio == 1
    index_domain_string = '';
    for t=1:length(chp_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_technologies(t)),'''');
        if t < length(chp_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_htp_ratio = strcat('\n\t\tConstraint CHP_HTP_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Heat'',conv) = Cmatrix(''Heat'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv);\n\t\t}');
end

%chp constraint
constraint_chp1 = '';
if apply_constraint_chp1 == 1
    index_domain_string = '';
    for t=1:length(chp_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_technologies(t)),'''');
        if t < length(chp_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_chp1 = strcat('\n\t\tConstraint CHP_HTP_constraint2 {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv) = Installation(''Heat'',conv);\n\t\t}');
end

%chp electrical capacity constraint
constraint_chp2 = '';
if apply_constraint_chp2 == 1
    index_domain_string = '';
    for t=1:length(chp_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_technologies(t)),'''');
        if t < length(chp_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_chp2 = strcat('\n\t\tConstraint CHP_installation_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Elec'',conv) = Max_allowable_capacity(conv) * Installation(''Elec'',conv);\n\t\t}');
end

footer_constraints_declaration_section = '\n\t}';

%compile conversion constraints to string
conversion_constraints_section = strcat(header_constraints_declaration_section,constraint_energy_balance,constraint_capacity,constraint_max_capacity,constraint_min_part_load1,constraint_min_part_load2,...
    constraint_solar_availability,constraint_roof_area,constraint_fixed_cost,constraint_operation,constraint_electricity_export,constraint_htp_ratio,constraint_chp1,constraint_chp2,footer_constraints_declaration_section);

%% GENERATE STORAGE TECHNOLOGY CONSTRAINTS

header_storage_constraints_declaration_section = '\n\tDeclarationSection Storage_constraints {';

if simplified_storage_representation == 0

    %energy balance constraints for storages
    constraint_energy_balance_storage = '';
    if apply_constraint_energy_balance_storage == 1
        constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,stor) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor) = (1 - Storage_standing_losses(stor)) * Storage_SOC(t-1,stor) + Storage_charging_efficiency(stor) *  Storage_input_energy(t,stor) - (1 / Storage_discharging_efficiency(stor)) * Storage_output_energy(t,stor);\n\t\t}';
    end

    %max allowable charging rate constraint
    constraint_max_charging_rate_storage = '';
    if apply_constraint_max_charging_rate_storage == 1
        constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_input_energy(t,stor) <= Storage_max_charge_rate(stor) * Storage_capacity(stor);\n\t\t}';
    end

    %max allowable discharging rate constraint
    constraint_max_discharging_rate_storage = '';
    if apply_constraint_max_discharging_rate_storage == 1
        constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_output_energy(t,stor) <= Storage_max_discharge_rate(stor) * Storage_capacity(stor);\n\t\t}';
    end

    %storage capacity constraint
    constraint_capacity_storage = '';
    if apply_constraint_capacity_storage == 1
        constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_SOC(t,stor) <= Storage_capacity(stor);\n\t\t}';
    end

    %minimum state of charge constraint
    constraint_min_soc_storage = '';
    if apply_constraint_min_soc_storage == 1
        constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_SOC(t,stor) >= Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}';
    end

    %fixed cost constraint for storage
    constraint_fixed_cost_storage = '';
    if apply_constraint_fixed_cost_storage == 1
        constraint_fixed_cost_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) <= Big_M * Installation_storage(stor);\n\t\t}';
    end

    %max capacity constraint for storage
    constraint_max_capacity_storage = '';
    if apply_constraint_max_capacity_storage == 1
        constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) <= Storage_maximum_capacity(stor);\n\t\t}';
    end
    
else
    
    %energy balance constraints for storages
    constraint_energy_balance_storage = '';
    if apply_constraint_energy_balance_storage == 1
        constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,x) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,x) = (1 - Storage_standing_losses(x)) * Storage_SOC(t-1,x) + Storage_charging_efficiency(x) *  Storage_input_energy(t,x) - (1 / Storage_discharging_efficiency(x)) * Storage_output_energy(t,x);\n\t\t}';
    end

    %max allowable charging rate constraint
    constraint_max_charging_rate_storage = '';
    if apply_constraint_max_charging_rate_storage == 1
        constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_input_energy(t,x) <= Storage_max_charge_rate(x) * Storage_capacity(x);\n\t\t}';
    end

    %max allowable discharging rate constraint
    constraint_max_discharging_rate_storage = '';
    if apply_constraint_max_discharging_rate_storage == 1
        constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_output_energy(t,x) <= Storage_max_discharge_rate(x) * Storage_capacity(x);\n\t\t}';
    end

    %storage capacity constraint
    constraint_capacity_storage = '';
    if apply_constraint_capacity_storage == 1
        constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_SOC(t,x) <= Storage_capacity(x);\n\t\t}';
    end

    %minimum state of charge constraint
    constraint_min_soc_storage = '';
    if apply_constraint_min_soc_storage == 1
        constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_SOC(t,x) >= Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
    end

    %fixed cost constraint for storage
    constraint_fixed_cost_storage = '';
    if apply_constraint_fixed_cost_storage == 1
        constraint_fixed_cost_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) <= Big_M * Installation_storage(x);\n\t\t}';
    end

    %max capacity constraint for storage
    constraint_max_capacity_storage = '';
    if apply_constraint_max_capacity_storage == 1
        constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) <= Storage_maximum_capacity(x);\n\t\t}';
    end
    
end

%% GENERATE STORAGE INITIALIZATION CONSTRAINTS

if simplified_storage_representation == 0

    % ELECTRICAL STORAGE INITIALIZATION CONSTRAINTS

    %helper code for electrical storage initialization
    index_domain_string = '';
    for t=1:length(electricity_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(electricity_storage_technologies(t)),'''');
        if t < length(electricity_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize electrical storage to min soc
    constraint_electrical_storage_initialization_to_min_soc = '';
    if apply_constraint_electrical_storage_initialization_to_min_soc == 1
        constraint_electrical_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
    end

    %electrical storage must have same starting and ending charges
    constraint_electrical_storage_initialization_cyclical = '';
    if apply_constraint_electrical_storage_initialization_cyclical == 1
        constraint_electrical_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
    end

    %constraint disallowing discharging from electrical storage in the first hour of the year
    constraint_electrical_storage_1st_hour = '';
    if apply_constraint_electrical_storage_1st_hour == 1
        constraint_electrical_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
    end

    % HEAT STORAGE INITIALIZATION CONSTRAINTS

    %helper code for heat storage initialization
    index_domain_string = '';
    for t=1:length(heat_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(heat_storage_technologies(t)),'''');
        if t < length(heat_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize heat storage to min soc
    constraint_heat_storage_initialization_to_min_soc = '';
    if apply_constraint_heat_storage_initialization_to_min_soc == 1
        constraint_heat_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_heat1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
    end

    %heat storage must have same starting and ending charges
    constraint_heat_storage_initialization_cyclical = '';
    if apply_constraint_heat_storage_initialization_cyclical == 1
        constraint_heat_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_heat2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
    end

    %constraint disallowing discharging from heat storage in the first hour of the year
    constraint_heat_storage_1st_hour = '';
    if apply_constraint_heat_storage_1st_hour == 1
        constraint_heat_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_heat3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
    end

    % COOL STORAGE INITIALIZATION CONSTRAINTS

    %helper code for cool storage initialization
    index_domain_string = '';
    for t=1:length(cool_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(cool_storage_technologies(t)),'''');
        if t < length(cool_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize cool storage to min soc
    constraint_cool_storage_initialization_to_min_soc = '';
    if apply_constraint_cool_storage_initialization_to_min_soc == 1
        constraint_cool_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_cool1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
    end

    %cool storage must have same starting and ending charges
    constraint_cool_storage_initialization_cyclical = '';
    if apply_constraint_cool_storage_initialization_cyclical == 1
        constraint_cool_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_cool2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
    end

    %constraint disallowing discharging from cool storage in the first hour of the year
    constraint_cool_storage_1st_hour = '';
    if apply_constraint_cool_storage_1st_hour == 1
        constraint_cool_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_cool3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
    end

else
    
    % ELECTRICAL STORAGE INITIALIZATION CONSTRAINTS

    %initialize electrical storage to min soc
    constraint_electrical_storage_initialization_to_min_soc = '';
    if apply_constraint_electrical_storage_initialization_to_min_soc == 1
        constraint_electrical_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_electricity1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
    end

    %electrical storage must have same starting and ending charges
    constraint_electrical_storage_initialization_cyclical = '';
    if apply_constraint_electrical_storage_initialization_cyclical == 1
        constraint_electrical_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constraint_electricity2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
    end

    %constraint disallowing discharging from electrical storage in the first hour of the year
    constraint_electrical_storage_1st_hour = '';
    if apply_constraint_electrical_storage_1st_hour == 1
        constraint_electrical_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_electricity3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
    end

    % HEAT STORAGE INITIALIZATION CONSTRAINTS

    %initialize heat storage to min soc
    constraint_heat_storage_initialization_to_min_soc = '';
    if apply_constraint_heat_storage_initialization_to_min_soc == 1
        constraint_heat_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_heat1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time (x = ''Heat'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
    end

    %heat storage must have same starting and ending charges
    constraint_heat_storage_initialization_cyclical = '';
    if apply_constraint_heat_storage_initialization_cyclical == 1
        constraint_heat_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_heat2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Heat'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
    end

    %constraint disallowing discharging from heat storage in the first hour of the year
    constraint_heat_storage_1st_hour = '';
    if apply_constraint_heat_storage_1st_hour == 1
        constraint_heat_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_heat3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Heat'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
    end

    % COOL STORAGE INITIALIZATION CONSTRAINTS

    %initialize cool storage to min soc
    constraint_cool_storage_initialization_to_min_soc = '';
    if apply_constraint_cool_storage_initialization_to_min_soc == 1
        constraint_cool_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_cool1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time (x = ''Cool'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
    end

    %cool storage must have same starting and ending charges
    constraint_cool_storage_initialization_cyclical = '';
    if apply_constraint_cool_storage_initialization_cyclical == 1
        constraint_cool_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_cool2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Cool'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
    end

    %constraint disallowing discharging from cool storage in the first hour of the year
    constraint_cool_storage_1st_hour = '';
    if apply_constraint_cool_storage_1st_hour == 1
        constraint_cool_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_cool3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Cool'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
    end
    
end

footer_storage_constraints_declaration_section = '\n\t}';

%compile storage constraints to string
storage_constraints_section = strcat(header_storage_constraints_declaration_section,constraint_energy_balance_storage,constraint_electrical_storage_initialization_to_min_soc,constraint_electrical_storage_initialization_cyclical,...
    constraint_electrical_storage_1st_hour,constraint_heat_storage_initialization_to_min_soc,constraint_heat_storage_initialization_cyclical,constraint_heat_storage_1st_hour,...
    constraint_cool_storage_initialization_to_min_soc,constraint_cool_storage_initialization_cyclical,constraint_cool_storage_1st_hour,...
    constraint_max_charging_rate_storage,constraint_max_discharging_rate_storage,constraint_capacity_storage,constraint_min_soc_storage,constraint_fixed_cost_storage,constraint_max_capacity_storage,footer_storage_constraints_declaration_section);

%% GENERATE CARBON CONSTRAINTS

carbon_constraints_section = '';
if apply_constraint_max_carbon == 1
    header_carbon_constraints_declaration_section = '\n\tDeclarationSection Carbon_constraints {';

    %max allowable carbon constraint
    constraint_max_carbon = '\n\t\tConstraint Maximum_carbon_emissions_constraint {\n\t\t\tIndexDomain: Total_carbon <= Carbon_emissions_limit;\n\t\t\tDefinition: ;\n\t\t}';

    footer_carbon_constraints_declaration_section = '\n\t}';

    %compile carbon constraints to string
    carbon_constraints_section = strcat(header_carbon_constraints_declaration_section,constraint_max_carbon,footer_carbon_constraints_declaration_section);
end