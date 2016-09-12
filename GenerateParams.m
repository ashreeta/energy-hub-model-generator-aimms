%% GENERATE LOAD PARAMS FOR AMS FILE

header_load_params = '\n\tDeclarationSection Load_Parameters {';

param_loads = '';
if create_param_loads == 1
    param_loads = strcat('\n\t\tParameter Loads {\n\t\t\tIndexDomain: (t,x);\n\t\t}');
end

footer_load_params = '\n\t}';

%compile load parameters to string
load_params_section = strcat(header_load_params,param_loads,footer_load_params);


%% GENERATE COST PARAMS FOR AMS FILE FOR ENERGY CONVERSION TECHNOLOGIES

%GENERATE COST PARAMS
header_cost_params = '\n\tDeclarationSection Cost_Parameters {';

%operating costs
param_operating_costs = '';
if create_param_operating_costs == 1
    definition_string = '';
    technologies_excluding_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_names,'Grid')));
    operating_costs_excluding_grid = technology_operating_costs(find(~strcmp(technologies.conversion_techs_names,'Grid')));
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
technology_OMV_costs = technologies.conversion_techs_specs(3,:);
if create_param_OMV_costs == 1
    technology_OMV_costs_with_titles = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            technology_OMV_costs_with_titles = strcat(technology_OMV_costs_with_titles,', ');
        end
        technology_OMV_costs_with_titles = strcat(technology_OMV_costs_with_titles,char(energy_conversion_technologies(t)),':',num2str(technology_OMV_costs(t)));
    end
    param_OMV_costs = strcat('\n\t\tParameter OMV_costs {\n\t\t\tIndexDomain: conv;\n\t\t\tDefinition: data { ',technology_OMV_costs_with_titles,' };\n\t\t}');
end

%linear capital costs
param_linear_capital_costs = '';
electricity_technology_linear_capital_costs = technologies.conversion_techs_specs(1,find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_technology_linear_capital_costs = technologies.conversion_techs_specs(1,find(strcmp(technologies.conversion_techs_outputs,'Heat'))); %don't include chp here
cooling_technology_linear_capital_costs = technologies.conversion_techs_specs(1,find(strcmp(technologies.conversion_techs_outputs,'Cool')));
if create_param_linear_capital_costs == 1
    linear_capital_costs = '\n\t\tParameter Linear_capital_costs {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: {\n\t\t\tdata { ';
    technology_linear_capital_costs_with_titles = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            technology_linear_capital_costs_with_titles = strcat(technology_linear_capital_costs_with_titles,', ');
        end
        technology_linear_capital_costs_with_titles = strcat(technology_linear_capital_costs_with_titles,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_linear_capital_costs(t)));
    end
    for t=1:length(heat_generating_technologies_excluding_chp)
        technology_linear_capital_costs_with_titles = strcat(technology_linear_capital_costs_with_titles,',(Heat,',char(heat_generating_technologies_excluding_chp(t)),'):',num2str(heat_technology_linear_capital_costs(t)));
    end
    for t=1:length(cooling_technologies)
        technology_linear_capital_costs_with_titles = strcat(technology_linear_capital_costs_with_titles,',(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_linear_capital_costs(t)));
    end
    param_linear_capital_costs = strcat(linear_capital_costs,technology_linear_capital_costs_with_titles,'}\n\t\t\t};\n\t\t}');
end

%fixed capital costs
param_fixed_capital_costs = '';
electricity_technology_fixed_capital_costs = technologies.conversion_techs_specs(2,find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_technology_fixed_capital_costs = technologies.conversion_techs_specs(2,find(strcmp(technologies.conversion_techs_outputs,'Heat'))); %don't include chp here
cooling_technology_fixed_capital_costs = technologies.conversion_techs_specs(2,find(strcmp(technologies.conversion_techs_outputs,'Cool')));
if create_param_fixed_capital_costs == 1
    fixed_capital_costs = '\n\t\tParameter Fixed_capital_costs {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: {\n\t\t\tdata { ';
    technology_fixed_capital_costs_with_titles = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            technology_fixed_capital_costs_with_titles = strcat(technology_fixed_capital_costs_with_titles,', ');
        end
        technology_fixed_capital_costs_with_titles = strcat(technology_fixed_capital_costs_with_titles,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_fixed_capital_costs(t)));
    end
    for t=1:length(heat_generating_technologies_excluding_chp)
        technology_fixed_capital_costs_with_titles = strcat(technology_fixed_capital_costs_with_titles,',(Heat,',char(heat_generating_technologies_excluding_chp(t)),'):',num2str(heat_technology_fixed_capital_costs(t)));
    end
    for t=1:length(cooling_technologies)
        technology_fixed_capital_costs_with_titles = strcat(technology_fixed_capital_costs_with_titles,',(Cool,',char(cooling_technologies(t)),'):',num2str(cooling_technology_fixed_capital_costs(t)));
    end
    param_fixed_capital_costs = strcat(fixed_capital_costs,technology_fixed_capital_costs_with_titles,'}\n\t\t\t};\n\t\t}');
end

%energy feed-in price
param_electricity_feedin_price = '';
if create_param_electricity_feedin_price == 1
    electricity_feedin_price_with_titles = strcat('Elec:',num2str(grid_electricity_feedin_price));
    param_electricity_feedin_price = strcat('\n\t\tParameter Electricity_feedin_price {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',electricity_feedin_price_with_titles,' };\n\t\t}');
end

%interest rate
param_int_rate = '';
if create_param_int_rate == 1
    param_int_rate = strcat('\n\t\tParameter Interest_rate {\n\t\t\tDefinition: ',num2str(interest_rate),';\n\t\t}');
end

%lifetimes
param_lifetimes = '';
energy_conversion_technology_lifetimes = technologies.conversion_techs_specs(5,:);
if create_param_lifetimes == 1
    technology_lifetime_with_titles = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            technology_lifetime_with_titles = strcat(technology_lifetime_with_titles,', ');
        end
        technology_lifetime_with_titles = strcat(technology_lifetime_with_titles,char(energy_conversion_technologies(t)),':',num2str(energy_conversion_technology_lifetimes(t)));
    end
    param_lifetimes = strcat('\n\t\tParameter Lifetime {\n\t\t\tIndexDomain: conv | conv <> "Grid";\n\t\t\tDefinition: data { ',technology_lifetime_with_titles,' };\n\t\t}');
end

%capital recovery factor
%note: used to annualize investment costs
param_technology_CRF = '';
if create_param_technology_CRF == 1
    param_technology_CRF = '\n\t\tParameter CRF_tech {\n\t\t\tIndexDomain: conv | conv <> "Grid";\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime(conv)))));\n\t\t}';
end

%% GENERATE COST PARAMS FOR AMS FILE FOR ENERGY STORAGE TECHNOLOGIES

if simplified_storage_representation == 0

    %linear storage costs
    param_linear_storage_costs = '';
    technology_linear_storage_costs = technologies.storage_techs_specs(1,:);
    if create_param_linear_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technology_linear_storage_costs(t)));
        end
        param_linear_storage_costs = strcat('\n\t\tParameter Linear_capital_costs_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %fixed storage costs
    param_fixed_storage_costs = '';
    if create_param_fixed_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technology_fixed_storage_costs(t)));
        end
        param_fixed_storage_costs = strcat('\n\t\tParameter Fixed_capital_costs_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage lifetimes
    param_storage_lifetimes = '';
    if create_param_storage_lifetimes == 1
        energy_storage_technology_lifetimes = technologies.storage_techs_specs(2,:);
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(energy_storage_technology_lifetimes(t)));
        end
        param_storage_lifetimes = strcat('\n\t\tParameter Lifetime_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    param_storage_CRF = '';
    if create_param_storage_CRF == 1
        param_storage_CRF = '\n\t\tParameter CRF_stor {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime_storage(stor)))));\n\t\t}';
    end

else
    
    %linear storage costs
    param_linear_storage_costs = '';
    if create_param_linear_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            technology_linear_storage_costs = technologies.storage_techs_specs(1,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(technology_linear_storage_costs));
        end
        param_linear_storage_costs = strcat('\n\t\tParameter Linear_capital_costs_storage {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %fixed storage costs
    param_fixed_storage_costs = '';
    if create_param_fixed_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            technology_fixed_storage_costs2 = technology_fixed_storage_costs(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(technology_fixed_storage_costs2));
        end
        param_fixed_storage_costs = strcat('\n\t\tParameter Fixed_capital_costs_storage {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage lifetimes
    param_storage_lifetimes = '';
    if create_param_storage_lifetimes == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            energy_storage_technology_lifetimes = technologies.storage_techs_specs(2,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(energy_storage_technology_lifetimes));
        end
        param_storage_lifetimes = strcat('\n\t\tParameter Lifetime_storage {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    param_storage_CRF = '';
    if create_param_storage_CRF == 1
        param_storage_CRF = '\n\t\tParameter CRF_stor {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime_storage(x)))));\n\t\t}';
    end
    
end

footer_cost_params = '\n\t}';

%compile cost parameters to string
cost_params_section = strcat(header_cost_params,param_operating_costs,param_operating_costs_grid,param_OMV_costs,param_linear_capital_costs,param_fixed_capital_costs,param_linear_storage_costs,param_fixed_storage_costs,param_electricity_feedin_price,param_int_rate,param_lifetimes,param_storage_lifetimes,param_technology_CRF,param_storage_CRF,footer_cost_params);

%% GENERATE TECHNICAL PARAMS FOR AMS FILE FOR ENERGY CONVERSION TECHNOLOGIES

header_technical_params = '\n\tDeclarationSection Technical_Parameters {';

%C matrix
param_C_matrix = '';
electricity_generating_technology_efficiencies = technologies.conversion_techs_specs(4,find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_generating_technology_efficiencies = technologies.conversion_techs_specs(4,find(ismember(technologies.conversion_techs_outputs,{'Heat','CHP'})));
cooling_technology_efficiencies = technologies.conversion_techs_specs(4,find(strcmp(technologies.conversion_techs_outputs,'Cool')));
if create_param_C_matrix == 1
    C_matrix = '\n\t\tParameter Cmatrix {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: { data { ';
    C_matrix_values_with_titles = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            C_matrix_values_with_titles = strcat(C_matrix_values_with_titles,', ');
        end
        C_matrix_values_with_titles = strcat(C_matrix_values_with_titles,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_generating_technology_efficiencies(t)));
    end
    for t=1:length(heat_generating_technologies)
        C_matrix_values_with_titles = strcat(C_matrix_values_with_titles,',(Heat,',char(heat_generating_technologies(t)),'):',num2str(heat_generating_technology_efficiencies(t)));
    end
    for t=1:length(electricity_consuming_technologies)
        C_matrix_values_with_titles = strcat(C_matrix_values_with_titles,',(Elec,',char(electricity_consuming_technologies(t)),'):',num2str(-1.0));
    end
    for t=1:length(heat_consuming_technologies)
        C_matrix_values_with_titles = strcat(C_matrix_values_with_titles,',(Heat,',char(heat_consuming_technologies(t)),'):',num2str(-1.0));
    end
    param_C_matrix = strcat(C_matrix,C_matrix_values_with_titles,'}\n\t\t\t}\n\t\t}');
end

%maximum allowable capacities
param_maximum_capacities = '';
technology_max_capacities_non_solar = technologies.conversion_techs_specs(9,find(~strcmp(technologies.conversion_techs_inputs,'Solar')));
non_solar_energy_conversion_technologies_excluding_grid = technologies.conversion_techs_names(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(~strcmp(technologies.conversion_techs_names,'Grid'))));
if create_param_maximum_capacities == 1
    technology_max_capacities_with_titles = '';
    for t=1:length(non_solar_energy_conversion_technologies_excluding_grid)
        if t>1
            technology_max_capacities_with_titles = strcat(technology_max_capacities_with_titles,', ');
        end
        technology_max_capacities_with_titles = strcat(technology_max_capacities_with_titles,char(non_solar_energy_conversion_technologies_excluding_grid(t)),':',num2str(technology_max_capacities_non_solar(t)));
    end
    max_capacities_index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies_excluding_grid)
        max_capacities_index_domain_string = strcat(max_capacities_index_domain_string,'''',char(non_solar_energy_conversion_technologies_excluding_grid(t)),'''');
        if t < length(non_solar_energy_conversion_technologies_excluding_grid)
             max_capacities_index_domain_string = strcat(max_capacities_index_domain_string,' OR conv = '); 
        end
    end        
    maximum_capacities = strcat('\n\t\tParameter Max_allowable_capacity {\n\t\t\tIndexDomain: conv | conv = ',max_capacities_index_domain_string,';');
    param_maximum_capacities = strcat(maximum_capacities,'\n\t\t\tDefinition: data { ',technology_max_capacities_with_titles,' };\n\t\t}');
end

%minimum part load
param_minimum_part_load = '';
electricity_technology_minimum_part_load = technologies.conversion_techs_specs(7,find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_technology_minimum_part_load = technologies.conversion_techs_specs(7,find(ismember(technologies.conversion_techs_outputs,{'Heat','CHP'})));
cooling_technology_minimum_part_load = technologies.conversion_techs_specs(7,find(strcmp(technologies.conversion_techs_outputs,'Cool')));
if create_param_minimum_part_load == 1
    index_domain_string = '';
    for t=1:length(dispatchable_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_technologies(t)),'''');
        if t < length(dispatchable_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    minimum_part_load = strcat('\n\t\tParameter Minimum_part_load {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: { data { ');
    technology_minimum_part_load_with_titles = '';
    for t=1:length(electricity_generating_technologies)
        if t>1
            technology_minimum_part_load_with_titles = strcat(technology_minimum_part_load_with_titles,', ');
        end
        technology_minimum_part_load_with_titles = strcat(technology_minimum_part_load_with_titles,'(Elec,',char(electricity_generating_technologies(t)),'):',num2str(electricity_technology_minimum_part_load(t)));
    end
    for t=1:length(heat_generating_technologies)
        technology_minimum_part_load_with_titles = strcat(technology_minimum_part_load_with_titles,',(Heat,',char(heat_generating_technologies(t)),'):',num2str(heat_technology_minimum_part_load(t)));
    end
    for t=1:length(cooling_technologies)
        technology_minimum_part_load_with_titles = strcat(technology_minimum_part_load_with_titles,',(Heat,',char(cooling_technologies(t)),'):',num2str(cooling_technology_minimum_part_load(t)));
    end
    param_minimum_part_load = strcat(minimum_part_load,technology_minimum_part_load_with_titles,'}\n\t\t\t}\n\t\t}');
end

%% GENERATE TECHNICAL PARAMS FOR AMS FILE FOR ENERGY STORAGE TECHNOLOGIES

if simplified_storage_representation == 0

    %S matrix
    param_S_matrix = '';
    if create_param_S_matrix == 1
        S_matrix = '\n\t\tParameter Smatrix {\n\t\t\tIndexDomain: (x,stor);\n\t\t\tDefinition: { data { ';
        S_matrix_values_with_titles = '';
        for t=1:length(electricity_storage_technologies)
            if t>1
                S_matrix_values_with_titles = strcat(S_matrix_values_with_titles,', ');
            end
            S_matrix_values_with_titles = strcat(S_matrix_values_with_titles,'(Elec,',char(electricity_storage_technologies(t)),'):1.0');
        end
        for t=1:length(heat_storage_technologies)
            S_matrix_values_with_titles = strcat(S_matrix_values_with_titles,',(Heat,',char(heat_storage_technologies(t)),'):1.0');
        end
        for t=1:length(cool_storage_technologies)
            S_matrix_values_with_titles = strcat(S_matrix_values_with_titles,',(Cool,',char(cool_storage_technologies(t)),'):1.0');
        end
        param_S_matrix = strcat(S_matrix,S_matrix_values_with_titles,'}\n\t\t\t}\n\t\t}');
    end

    %storage maximum charging rate
    param_max_charge_rate = '';
    storage_max_charge_rate = technologies.storage_techs_specs(6,:);
    if create_param_max_charge_rate == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_max_charge_rate(t)));
        end
        param_max_charge_rate = strcat('\n\t\tParameter Storage_max_charge_rate {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum discharging rate
    param_max_discharge_rate = '';
    storage_max_discharge_rate = technologies.storage_techs_specs(7,:);
    if create_param_max_discharge_rate == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_max_discharge_rate(t)));
        end
        param_max_discharge_rate = strcat('\n\t\tParameter Storage_max_discharge_rate {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage standing losses
    param_standing_losses = '';
    storage_standing_losses = technologies.storage_techs_specs(5,:);
    if create_param_standing_losses == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_standing_losses(t)));
        end
        param_standing_losses = strcat('\n\t\tParameter Storage_standing_losses {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage charging efficiency
    param_charging_efficiency = '';
    storage_charging_efficiency = technologies.storage_techs_specs(3,:);
    if create_param_charging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_charging_efficiency(t)));
        end
        param_charging_efficiency = strcat('\n\t\tParameter Storage_charging_efficiency {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage discharging efficiency
    param_discharging_efficiency = '';
    storage_discharging_efficiency = technologies.storage_techs_specs(4,:);
    if create_param_discharging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_discharging_efficiency(t)));
        end
        param_discharging_efficiency = strcat('\n\t\tParameter Storage_discharging_efficiency {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage minimum state of charge
    param_min_soc = '';
    storage_min_soc = technologies.storage_techs_specs(8,:);
    if create_param_min_soc == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_min_soc(t)));
        end
        param_min_soc = strcat('\n\t\tParameter Storage_min_SOC {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum capacity
    param_max_capacity_storage = '';
    storage_max_capacity = technologies.storage_techs_specs(10,:);
    if create_param_max_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(storage_max_capacity(t)));
        end
        param_max_capacity_storage = strcat('\n\t\tParameter Storage_maximum_capacity {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

else
    
    %S matrix
    param_S_matrix = '';

    %storage maximum charging rate
    param_max_charge_rate = '';
    if create_param_max_charge_rate == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_max_charge_rate = technologies.storage_techs_specs(6,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_charge_rate));
        end
        param_max_charge_rate = strcat('\n\t\tParameter Storage_max_charge_rate {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum discharging rate
    param_max_discharge_rate = '';
    if create_param_max_discharge_rate == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_max_discharge_rate = technologies.storage_techs_specs(7,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_discharge_rate));
        end
        param_max_discharge_rate = strcat('\n\t\tParameter Storage_max_discharge_rate {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage standing losses
    param_standing_losses = '';
    if create_param_standing_losses == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_standing_losses = technologies.storage_techs_specs(5,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_standing_losses));
        end
        param_standing_losses = strcat('\n\t\tParameter Storage_standing_losses {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage charging efficiency
    param_charging_efficiency = '';
    if create_param_charging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_charging_efficiency = technologies.storage_techs_specs(3,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_charging_efficiency));
        end
        param_charging_efficiency = strcat('\n\t\tParameter Storage_charging_efficiency {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage discharging efficiency
    param_discharging_efficiency = '';
    if create_param_discharging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_discharging_efficiency = technologies.storage_techs_specs(4,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_discharging_efficiency));
        end
        param_discharging_efficiency = strcat('\n\t\tParameter Storage_discharging_efficiency {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage minimum state of charge
    param_min_soc = '';
    if create_param_min_soc == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_min_soc = technologies.storage_techs_specs(8,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_min_soc));
        end
        param_min_soc = strcat('\n\t\tParameter Storage_min_SOC {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum capacity
    param_max_capacity_storage = '';
    if create_param_max_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_max_capacity = technologies.storage_techs_specs(10,(find(strcmp(technologies.storage_techs_types,energy_outputs(t)))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_capacity));
        end
        param_max_capacity_storage = strcat('\n\t\tParameter Storage_maximum_capacity {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
end

footer_technical_params = '\n\t}';

%compile technical parameters to string
technical_params_section = strcat(header_technical_params,param_C_matrix,param_S_matrix,param_maximum_capacities,param_minimum_part_load,param_max_charge_rate,param_max_discharge_rate,param_standing_losses,param_charging_efficiency,param_discharging_efficiency,param_min_soc,param_max_capacity_storage,footer_technical_params);

%% GENERATE OTHER PARAMS FOR AMS FILE

header_other_params = '\n\tDeclarationSection Other_Parameters {';

%roof area
param_roof_area = '';
if create_param_roof_area == 1
    param_roof_area = strcat('\n\t\tParameter Building_roof_area {\n\t\t\tDefinition: ',num2str(roof_areas),';\n\t\t}');
end

%carbon factors
param_carbon_factors = '';
technology_carbon_factors = technologies.conversion_techs_specs(10,:);
if create_param_carbon_factors == 1
    technology_carbon_factors_with_titles = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            technology_carbon_factors_with_titles = strcat(technology_carbon_factors_with_titles,', ');
        end
        technology_carbon_factors_with_titles = strcat(technology_carbon_factors_with_titles,char(energy_conversion_technologies(t)),':',num2str(technology_carbon_factors(t)));
    end
    param_carbon_factors = strcat('\n\t\tParameter Technology_carbon_factors {\n\t\t\tIndexDomain: (conv);\n\t\t\tDefinition: data { ',technology_carbon_factors_with_titles,' };\n\t\t}');
end

%max allowable carbon
param_max_carbon = '';
if create_param_max_carbon == 1
    param_max_carbon = strcat('\n\t\tParameter Carbon_emissions_limit {\n\t\t\tDefinition: ',carbon_limit,';\n\t\t}');
end

%solar radiation
param_solar_radiation = '';
if create_param_solar_radiation == 1
    param_solar_radiation = strcat('\n\t\tParameter Solar_radiation {\n\t\t\tIndexDomain: t;\n\t\t}');
end

%big M
%note: used for linearization of constraints
param_big_M = '';
if create_param_big_M == 1
    param_big_M = strcat('\n\t\tParameter Big_M {\n\t\t\tDefinition: 100000;\n\t\t}');
end

footer_other_params = '\n\t}';

%compile other parameters to string
other_params_section = strcat(header_other_params,param_roof_area,param_carbon_factors,param_max_carbon,param_solar_radiation,param_big_M,footer_other_params);