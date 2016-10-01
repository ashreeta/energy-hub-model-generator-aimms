%% GENERATE CONVERSION TECHNOLOGY CONSTRAINTS

%% ENERGY BALANCE CONSTRAINT

%energy balance constraint
constraint_energy_balance = '';
if apply_constraint_energy_balance == 1
    if simplified_storage_representation == 0
        constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + sum(stor, (Storage_output_energy(t,stor) - Storage_input_energy(t,stor)) * Smatrix(x,stor)) = Loads(t,x) + Exported_energy(t,x);\n\t\t}';
    else
        constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + Storage_output_energy(t,x) - Storage_input_energy(t,x) = Loads(t,x) + Exported_energy(t,x);\n\t\t}';
    end
end

%% CAPACITY AND OPERATION CONSTRAINTS

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
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies_excluding_chp_and_grid)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies_excluding_chp_and_grid(t)),'''');
        if t < length(non_solar_energy_conversion_technologies_excluding_chp_and_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_max_capacity = strcat('\n\t\tConstraint Maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv) <= Max_allowable_capacity(conv);\n\t\t}');
end

%dispatch constraint
constraint_dispatch = '';
if apply_constraint_dispatch == 1
    dispatchable_techs_including_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_dispatch = strcat('\n\t\tConstraint Dispatch_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Big_M * Operation(t,conv);\n\t\t}');
end

%minimum part load constraint
constraint_min_part_load = '';
if apply_constraint_min_part_load == 1
    dispatchable_techs_including_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    constraint_min_part_load = strcat('\n\t\tConstraint Part_load_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv)) >= Minimum_part_load(x,conv) * Capacity(x,conv);\n\t\t}');
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
    definition_string = '';
    for t = 1:length(solar_technologies_with_electrical_output)
        if t > 1
            definition_string = strcat(definition_string,'+');
        end
        definition_string = strcat(definition_string,'Capacity(''Elec'',''',char(solar_technologies_with_electrical_output(t)),''')');        
    end
    for t = 1:length(solar_technologies_with_heat_output)
        definition_string = strcat(definition_string,'+');
        definition_string = strcat(definition_string,'Capacity(''Heat'',''',char(solar_technologies_with_heat_output(t)),''')');
    end
    constraint_roof_area = strcat('\n\t\tConstraint Roof_area_constraint {\n\t\t\tDefinition: ',definition_string,' <= Building_roof_area;\n\t\t}');
end

%installation constraint
constraint_installation = '';
if apply_constraint_installation == 1
    constraint_installation = '\n\t\tConstraint Installation_constraint {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: Capacity(x,conv) <= Big_M * Installation(x,conv);\n\t\t}';
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

%% CHP CONSTRAINTS

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
    constraint_chp2 = strcat('\n\t\tConstraint CHP_installation_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Elec'',conv) <= Max_allowable_capacity(conv) * Installation(''Elec'',conv);\n\t\t}');
end

%% COMPILE CONSTRAINTS

constraints_section = strcat(constraints_section,constraint_energy_balance,constraint_capacity,constraint_max_capacity,constraint_dispatch,constraint_min_part_load,...
    constraint_solar_availability,constraint_roof_area,constraint_installation,constraint_operation,constraint_electricity_export,constraint_htp_ratio,constraint_chp1,constraint_chp2);