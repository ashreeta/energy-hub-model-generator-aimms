%% GENERATE COST PARAMS FOR ENERGY CONVERSION TECHNOLOGIES

%operating costs
param_operating_costs = '';
if create_param_operating_costs == 1
    definition_string = '';
    technologies_excluding_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_names,'Grid')));
    operating_costs_excluding_grid = technologies.conversion_techs_operating_costs(find(~strcmp(technologies.conversion_techs_names,'Grid')));
    for t=1:length(technologies_excluding_grid)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(technologies_excluding_grid(t)),':',num2str(operating_costs_excluding_grid(t)));
    end
    param_operating_costs = strcat('\n\t\tParameter Operating_costs {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tDefinition: data {',definition_string,'};\n\t\t}');
end

%operating costs of grid
param_operating_costs_grid = '';
if create_param_operating_costs_grid == 1
    if length(grid_electricity_price) > 1
        param_operating_costs_grid = '\n\t\tParameter Operating_costs_grid {\n\t\t\tIndexDomain: t;\n\t\t}';
    else 
        param_operating_costs_grid = strcat('\n\t\tParameter Operating_costs_grid {\n\t\t\tDefinition: ',num2str(grid_electricity_price),';\n\t\t}');
    end
end

%OMV costs
param_OMV_costs = '';
if create_param_OMV_costs == 1
    definition_string = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(technologies.conversion_techs_OM_cost_variable(t)));
    end
    param_OMV_costs = strcat('\n\t\tParameter OMV_costs {\n\t\t\tIndexDomain: conv;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%linear capital costs
param_linear_capital_costs = '';
electricity_technology_linear_capital_costs = technologies.conversion_techs_capital_cost_variable(find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_technology_linear_capital_costs = technologies.conversion_techs_capital_cost_variable(find(strcmp(technologies.conversion_techs_outputs,'Heat'))); %don't include chp here
cooling_technology_linear_capital_costs = technologies.conversion_techs_capital_cost_variable(find(strcmp(technologies.conversion_techs_outputs,'Cool')));
dhw_technology_linear_capital_costs = technologies.conversion_techs_capital_cost_variable(find(strcmp(technologies.conversion_techs_outputs,'DHW')));
anergy_technology_linear_capital_costs = technologies.conversion_techs_capital_cost_variable(find(strcmp(technologies.conversion_techs_outputs,'Anergy')));
if create_param_linear_capital_costs == 1
    linear_capital_costs = '\n\t\tParameter Linear_capital_costs {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: {\n\t\t\tdata { ';
    definition_string = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_linear_capital_costs(t)));
    end
    for t=1:length(heat_generating_technologies_excluding_chp)
        definition_string = strcat(definition_string,',(Heat,',char(heat_generating_technologies_excluding_chp(t)),'):',num2str(heat_technology_linear_capital_costs(t)));
    end
    for t=1:length(cooling_technologies)
        definition_string = strcat(definition_string,',(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_linear_capital_costs(t)));
    end
    for t=1:length(dhw_generating_technologies)
        definition_string = strcat(definition_string,',(DHW,',char(dhw_generating_technologies(t)),'):',num2str(dhw_technology_linear_capital_costs(t)));
    end
    for t=1:length(anergy_generating_technologies)
        definition_string = strcat(definition_string,',(Anergy,',char(anergy_generating_technologies(t)),'):',num2str(anergy_technology_linear_capital_costs(t)));
    end
    param_linear_capital_costs = strcat(linear_capital_costs,definition_string,'}\n\t\t\t};\n\t\t}');
end

%fixed capital costs
param_fixed_capital_costs = '';
electricity_technology_fixed_capital_costs = technologies.conversion_techs_capital_cost_fixed(find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_technology_fixed_capital_costs = technologies.conversion_techs_capital_cost_fixed(find(strcmp(technologies.conversion_techs_outputs,'Heat'))); %don't include chp here
cooling_technology_fixed_capital_costs = technologies.conversion_techs_capital_cost_fixed(find(strcmp(technologies.conversion_techs_outputs,'Cool')));
dhw_technology_fixed_capital_costs = technologies.conversion_techs_capital_cost_fixed(find(strcmp(technologies.conversion_techs_outputs,'DHW')));
anergy_technology_fixed_capital_costs = technologies.conversion_techs_capital_cost_fixed(find(strcmp(technologies.conversion_techs_outputs,'Anergy')));
if create_param_fixed_capital_costs == 1
    fixed_capital_costs = '\n\t\tParameter Fixed_capital_costs {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: {\n\t\t\tdata { ';
    definition_string = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_fixed_capital_costs(t)));
    end
    for t=1:length(heat_generating_technologies_excluding_chp)
        definition_string = strcat(definition_string,',(Heat,',char(heat_generating_technologies_excluding_chp(t)),'):',num2str(heat_technology_fixed_capital_costs(t)));
    end
    for t=1:length(cooling_technologies)
        definition_string = strcat(definition_string,',(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_fixed_capital_costs(t)));
    end
    for t=1:length(dhw_generating_technologies)
        definition_string = strcat(definition_string,',(DHW,',char(dhw_generating_technologies(t)),'):',num2str(dhw_technology_fixed_capital_costs(t)));
    end
    for t=1:length(anergy_generating_technologies)
        definition_string = strcat(definition_string,',(Anergy,',char(anergy_generating_technologies(t)),'):',num2str(anergy_technology_fixed_capital_costs(t)));
    end
    param_fixed_capital_costs = strcat(fixed_capital_costs,definition_string,'}\n\t\t\t};\n\t\t}');
end

%energy feed-in price
param_electricity_feedin_price = '';
if create_param_electricity_feedin_price == 1
    definition_string = strcat('Elec:',num2str(grid_electricity_feedin_price));
    param_electricity_feedin_price = strcat('\n\t\tParameter Electricity_feedin_price {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%interest rate
param_int_rate = '';
if create_param_int_rate == 1
    param_int_rate = strcat('\n\t\tParameter Interest_rate {\n\t\t\tDefinition: ',num2str(interest_rate),';\n\t\t}');
end

%lifetimes
param_lifetimes = '';
if create_param_lifetimes == 1
    definition_string = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(technologies.conversion_techs_lifetime(t)));
    end
    param_lifetimes = strcat('\n\t\tParameter Lifetime {\n\t\t\tIndexDomain: conv | conv <> "Grid";\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%capital recovery factor
%note: used to annualize investment costs
param_technology_CRF = '';
if create_param_technology_CRF == 1
    param_technology_CRF = '\n\t\tParameter CRF_tech {\n\t\t\tIndexDomain: conv | conv <> "Grid";\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime(conv)))));\n\t\t}';
end

%% GENERATE TECHNICAL PARAMS FOR AMS FILE FOR ENERGY CONVERSION TECHNOLOGIES

%C matrix
param_C_matrix = '';
electricity_generating_technology_efficiencies = technologies.conversion_techs_efficiency(find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_generating_technology_efficiencies = technologies.conversion_techs_efficiency(find(ismember(technologies.conversion_techs_outputs,{'Heat','CHP'})));
cooling_technology_efficiencies = technologies.conversion_techs_efficiency(find(strcmp(technologies.conversion_techs_outputs,'Cool')));
dhw_generating_technology_efficiencies = technologies.conversion_techs_efficiency(find(strcmp(technologies.conversion_techs_outputs,'DHW')));
anergy_generating_technology_efficiencies = technologies.conversion_techs_efficiency(find(strcmp(technologies.conversion_techs_outputs,'Anergy')));
if create_param_C_matrix == 1
    C_matrix = '\n\t\tParameter Cmatrix {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: { data { ';
    definition_string = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_generating_technology_efficiencies(t)));
    end
    for t=1:length(heat_generating_technologies)
        definition_string = strcat(definition_string,',(Heat,',char(heat_generating_technologies(t)),'):',num2str(heat_generating_technology_efficiencies(t)));
    end
    for t=1:length(cooling_technologies)
        definition_string = strcat(definition_string,',(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_efficiencies(t)));
    end
    for t=1:length(dhw_generating_technologies)
        definition_string = strcat(definition_string,',(DHW,',char(dhw_generating_technologies(t)),'):',num2str(dhw_generating_technology_efficiencies(t)));
    end
    for t=1:length(anergy_generating_technologies)
        definition_string = strcat(definition_string,',(Anergy,',char(anergy_generating_technologies(t)),'):',num2str(anergy_generating_technology_efficiencies(t)));
    end
    for t=1:length(electricity_consuming_technologies)
        definition_string = strcat(definition_string,',(Elec,',char(electricity_consuming_technologies(t)),'):',num2str(-1.0));
    end
    for t=1:length(heat_consuming_technologies)
        definition_string = strcat(definition_string,',(Heat,',char(heat_consuming_technologies(t)),'):',num2str(-1.0));
    end
    for t=1:length(anergy_consuming_technologies)
        definition_string = strcat(definition_string,',(Anergy,',char(anergy_consuming_technologies(t)),'):',num2str(-1.0));
    end
    param_C_matrix = strcat(C_matrix,definition_string,'}\n\t\t\t}\n\t\t}');
end

%param capacity
%only used if we're not doing technology selection and sizing; otherwise this is set by the capacity variable
param_capacity = '';
if create_param_capacity == 1
    number_of_installed_conversion_techs = length(installed_technologies.conversion_techs_names);
    electricity_generating_technologies = installed_technologies.conversion_techs_names(find(ismember(installed_technologies.conversion_techs_outputs,{'Elec','CHP'})));
    heat_generating_technologies = installed_technologies.conversion_techs_names(find(ismember(installed_technologies.conversion_techs_outputs,{'Heat','CHP'})));
    cooling_technologies = installed_technologies.conversion_techs_names(find(strcmp(installed_technologies.conversion_techs_outputs,'Cool')));
    dhw_generating_technologies = installed_technologies.conversion_techs_names(find(strcmp(installed_technologies.conversion_techs_outputs,'DHW')));
    anergy_generating_technologies = installed_technologies.conversion_techs_names(find(strcmp(installed_technologies.conversion_techs_outputs,'Anergy')));
    
    electricity_technology_capacity = installed_technologies.conversion_techs_capacity(find(ismember(installed_technologies.conversion_techs_outputs,{'Elec','CHP'})));
    heat_technology_capacity = installed_technologies.conversion_techs_capacity(find(ismember(installed_technologies.conversion_techs_outputs,{'Heat','CHP'})));
    cooling_technology_capacity = installed_technologies.conversion_techs_capacity(find(strcmp(installed_technologies.conversion_techs_outputs,'Cool')));
    dhw_technology_capacity = installed_technologies.conversion_techs_capacity(find(strcmp(installed_technologies.conversion_techs_outputs,'DHW')));
    anergy_technology_capacity = installed_technologies.conversion_techs_capacity(find(strcmp(installed_technologies.conversion_techs_outputs,'Anergy')));

    electricity_technology_node = installed_technologies.conversion_techs_node(find(ismember(installed_technologies.conversion_techs_outputs,{'Elec','CHP'})));
    heat_technology_node = installed_technologies.conversion_techs_node(find(ismember(installed_technologies.conversion_techs_outputs,{'Heat','CHP'})));
    cooling_technology_node = installed_technologies.conversion_techs_node(find(strcmp(installed_technologies.conversion_techs_outputs,'Cool')));
    dhw_technology_node = installed_technologies.conversion_techs_node(find(strcmp(installed_technologies.conversion_techs_outputs,'DHW')));
    anergy_technology_node = installed_technologies.conversion_techs_node(find(strcmp(installed_technologies.conversion_techs_outputs,'Anergy')));
    
    definition_string = '';
    index_domain_string = '';
    if multiple_hubs == 0

        index_domain_string = '(x,conv)';
        i = 0;
        for t=1:length(electricity_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(heat_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Heat,',char(heat_generating_technologies(t)),'):',num2str(heat_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(cooling_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(dhw_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(DHW,',char(dhw_generating_technologies(t)),'):',num2str(dhw_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(anergy_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Anergy,',char(anergy_generating_technologies(t)),'):',num2str(anergy_technology_capacity(t)));
            i = 1 + 1;
        end

    else

        index_domain_string = '(x,conv,h)';
        i = 0;
        for t=1:length(electricity_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Elec,',char(electricity_generating_technologies(t)),',',num2str(electricity_technology_node(t)),'):',num2str(electricity_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(heat_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Heat,',char(heat_generating_technologies(t)),',',num2str(heat_technology_node(t)),'):',num2str(heat_technology_capacity(t)));

            i = 1 + 1;
        end
        for t=1:length(cooling_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Cool,',char(cooling_technologies(t)),',',num2str(cooling_technology_node(t)),'):',num2str(cooling_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(dhw_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(DHW,',char(dhw_generating_technologies(t)),',',num2str(dhw_technology_node(t)),'):',num2str(dhw_technology_capacity(t)));
            i = 1 + 1;
        end
        for t=1:length(anergy_generating_technologies)
            if i > 0
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Anergy,',char(anergy_generating_technologies(t)),',',num2str(anergy_technology_node(t)),'):',num2str(anergy_technology_capacity(t)));
            i = 1 + 1;
        end

    end
    
    param_capacity = strcat('\n\t\tParameter Capacity {\n\t\t\tIndexDomain: ',index_domain_string,';\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');

end

%param capacity grid
%only used if we're not doing grid sizing; otherwise this is set by the capacity variable
param_capacity_grid = '';
if create_param_capacity_grid == 1
    if multiple_hubs == 0
        definition_string = num2str(grid_connection_capacity);
        param_capacity_grid = strcat('\n\t\tParameter Capacity_grid {\n\t\t\tDefinition: ',definition_string,';\n\t\t}');
    else
        definition_string = strcat(num2str(grid_connection_node),':',num2str(grid_connection_capacity));
        param_capacity_grid = strcat('\n\t\tParameter Capacity_grid {\n\t\t\tIndexDomain: h;\n\t\t\tDefinition: data {',definition_string,'};\n\t\t}');
    end
end

%minimum allowable capacities
param_minimum_capacities = '';
technology_min_capacities_non_solar = technologies.conversion_techs_min_capacity(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(~strcmp(technologies.conversion_techs_names,'Grid'))));
non_solar_energy_conversion_technologies = technologies.conversion_techs_names(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(~strcmp(technologies.conversion_techs_names,'Grid'))));
if create_param_minimum_capacities == 1
    definition_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(non_solar_energy_conversion_technologies(t)),':',num2str(technology_min_capacities_non_solar(t)));
    end
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies(t)),'''');
        if t < length(non_solar_energy_conversion_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end        
    minimum_capacities = strcat('\n\t\tParameter Min_allowable_capacity {\n\t\t\tIndexDomain: conv | conv = ',index_domain_string,';');
    param_minimum_capacities = strcat(minimum_capacities,'\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%maximum allowable capacities
param_maximum_capacities = '';
technology_max_capacities_non_solar = technologies.conversion_techs_max_capacity(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(~strcmp(technologies.conversion_techs_names,'Grid'))));
non_solar_energy_conversion_technologies = technologies.conversion_techs_names(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(~strcmp(technologies.conversion_techs_names,'Grid'))));
if create_param_maximum_capacities == 1
    definition_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(non_solar_energy_conversion_technologies(t)),':',num2str(technology_max_capacities_non_solar(t)));
    end
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies(t)),'''');
        if t < length(non_solar_energy_conversion_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end        
    maximum_capacities = strcat('\n\t\tParameter Max_allowable_capacity {\n\t\t\tIndexDomain: conv | conv = ',index_domain_string,';');
    param_maximum_capacities = strcat(maximum_capacities,'\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%minimum allowable capacity grid
param_min_capacity_grid = '';
if create_param_min_capacity_grid == 1
   definition_string = num2str(technologies.conversion_techs_min_capacity(find(strcmp(technologies.conversion_techs_names,'Grid'))));
   param_min_capacity_grid = strcat('\n\t\tParameter Min_allowable_capacity_grid {\n\t\t\tDefinition:',definition_string,';\n\t\t}');
end

%maximum allowable capacity grid
param_max_capacity_grid = '';
if create_param_max_capacity_grid == 1
   definition_string = num2str(technologies.conversion_techs_max_capacity(find(strcmp(technologies.conversion_techs_names,'Grid'))));
   param_max_capacity_grid = strcat('\n\t\tParameter Max_allowable_capacity_grid {\n\t\t\tDefinition:',definition_string,';\n\t\t}');
end

%minimum part load
param_minimum_part_load = '';
electricity_technology_minimum_part_load = technologies.conversion_techs_min_part_load(find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_technology_minimum_part_load = technologies.conversion_techs_min_part_load(find(ismember(technologies.conversion_techs_outputs,{'Heat','CHP'})));
cooling_technology_minimum_part_load = technologies.conversion_techs_min_part_load(find(strcmp(technologies.conversion_techs_outputs,'Cool')));
dhw_technology_minimum_part_load = technologies.conversion_techs_min_part_load(find(strcmp(technologies.conversion_techs_outputs,'DHW')));
anergy_technology_minimum_part_load = technologies.conversion_techs_min_part_load(find(strcmp(technologies.conversion_techs_outputs,'Anergy')));

if create_param_minimum_part_load == 1
    index_domain_string = '';
    for t=1:length(dispatchable_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_technologies(t)),'''');
        if t < length(dispatchable_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    minimum_part_load = strcat('\n\t\tParameter Minimum_part_load {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: { data { ');
    definition_string = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_minimum_part_load(t)));
    end
    for t=1:length(heat_generating_technologies)
        definition_string = strcat(definition_string,',(Heat,',char(heat_generating_technologies(t)),'):',num2str(heat_technology_minimum_part_load(t)));
    end
    for t=1:length(cooling_technologies)
        definition_string = strcat(definition_string,',(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_minimum_part_load(t)));
    end
    for t=1:length(dhw_generating_technologies)
        definition_string = strcat(definition_string,',(DHW,',char(dhw_generating_technologies(t)),'):',num2str(dhw_technology_minimum_part_load(t)));
    end
    for t=1:length(anergy_generating_technologies)
        definition_string = strcat(definition_string,',(Anergy,',char(anergy_generating_technologies(t)),'):',num2str(anergy_technology_minimum_part_load(t)));
    end
    param_minimum_part_load = strcat(minimum_part_load,definition_string,'}\n\t\t\t;}\n\t\t}');
end

%installation (for pre-installed technologies)
param_installed_conversion_technologies = '';
if create_param_installed_conversion_technologies == 1
    number_of_installed_conversion_techs = length(installed_technologies.conversion_techs_names);
    definition_string = '';
    if multiple_hubs == 0
        index_domain_string = 'conv';
        for t=1:number_of_installed_conversion_techs
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,char(installed_technologies.conversion_techs_names(t)),' : 1');
        end      
    else
        index_domain_string = 'conv,h';
        for t=1:number_of_installed_conversion_techs
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(',char(installed_technologies.conversion_techs_names(t)),',',num2str(installed_technologies.conversion_techs_node(t)),') : 1');
        end
    end
    param_installed_conversion_technologies = strcat('\n\t\tParameter Installed_conversion_techs {\n\t\t\tIndexDomain:(',index_domain_string,');\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');
end


params_section = strcat(params_section,param_operating_costs,param_operating_costs_grid,param_OMV_costs,param_linear_capital_costs,param_fixed_capital_costs,...
    param_electricity_feedin_price,param_int_rate,param_lifetimes,param_technology_CRF,param_C_matrix,param_capacity,param_capacity_grid,param_minimum_capacities,param_maximum_capacities,...
    param_min_capacity_grid,param_max_capacity_grid,param_minimum_part_load,param_installed_conversion_technologies);
