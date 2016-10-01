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
constraints_section = strcat(constraints_section,constraint_electrical_storage_initialization_to_min_soc,constraint_electrical_storage_initialization_cyclical,...
    constraint_electrical_storage_1st_hour,constraint_heat_storage_initialization_to_min_soc,constraint_heat_storage_initialization_cyclical,constraint_heat_storage_1st_hour,...
    constraint_cool_storage_initialization_to_min_soc,constraint_cool_storage_initialization_cyclical,constraint_cool_storage_1st_hour);