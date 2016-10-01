%% GENERATE COST PARAMS FOR ENERGY STORAGE TECHNOLOGIES

if simplified_storage_representation == 0

    %linear storage costs
    param_linear_storage_costs = '';
    if create_param_linear_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_capital_cost_variable(t)));
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
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_capital_cost_fixed(t)));
        end
        param_fixed_storage_costs = strcat('\n\t\tParameter Fixed_capital_costs_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage lifetimes
    param_storage_lifetimes = '';
    if create_param_storage_lifetimes == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_lifetime(t)));
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
            technology_linear_storage_costs = technologies.storage_techs_capital_cost_variable(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            technology_fixed_storage_costs2 = technologies.storage_techs_capital_cost_fixed(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            energy_storage_technology_lifetimes = technologies.storage_techs_lifetime(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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

%% GENERATE TECHNICAL PARAMS FOR AMS FILE FOR ENERGY STORAGE TECHNOLOGIES

if simplified_storage_representation == 0

    %S matrix
    param_S_matrix = '';
    if create_param_S_matrix == 1
        S_matrix = '\n\t\tParameter Smatrix {\n\t\t\tIndexDomain: (x,stor);\n\t\t\tDefinition: { data { ';
        definition_string = '';
        for t=1:length(electricity_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Elec,',char(electricity_storage_technologies(t)),'):1.0');
        end
        for t=1:length(heat_storage_technologies)
            definition_string = strcat(definition_string,',(Heat,',char(heat_storage_technologies(t)),'):1.0');
        end
        for t=1:length(cool_storage_technologies)
            definition_string = strcat(definition_string,',(Cool,',char(cool_storage_technologies(t)),'):1.0');
        end
        param_S_matrix = strcat(S_matrix,definition_string,'}\n\t\t\t}\n\t\t}');
    end

    %storage maximum charging rate
    param_max_charge_rate = '';
    if create_param_max_charge_rate == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_max_charging_rate(t)));
        end
        param_max_charge_rate = strcat('\n\t\tParameter Storage_max_charge_rate {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum discharging rate
    param_max_discharge_rate = '';
    if create_param_max_discharge_rate == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_max_discharging_rate(t)));
        end
        param_max_discharge_rate = strcat('\n\t\tParameter Storage_max_discharge_rate {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage standing losses
    param_standing_losses = '';
    if create_param_standing_losses == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_decay(t)));
        end
        param_standing_losses = strcat('\n\t\tParameter Storage_standing_losses {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage charging efficiency
    param_charging_efficiency = '';
    if create_param_charging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_charging_efficiency(t)));
        end
        param_charging_efficiency = strcat('\n\t\tParameter Storage_charging_efficiency {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage discharging efficiency
    param_discharging_efficiency = '';
    if create_param_discharging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_discharging_efficiency(t)));
        end
        param_discharging_efficiency = strcat('\n\t\tParameter Storage_discharging_efficiency {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage minimum state of charge
    param_min_soc = '';
    if create_param_min_soc == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_min_state_of_charge(t)));
        end
        param_min_soc = strcat('\n\t\tParameter Storage_min_SOC {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum capacity
    param_max_capacity_storage = '';
    if create_param_max_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(technologies.storage_techs_max_capacity(t)));
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
            storage_max_charge_rate = technologies.storage_techs_max_charging_rate(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            storage_max_discharge_rate = technologies.storage_techs_max_discharging_rate(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            storage_standing_losses = technologies.storage_techs_decay(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            storage_charging_efficiency = technologies.storage_techs_charging_efficiency(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            storage_discharging_efficiency = technologies.storage_techs_discharging_efficiency(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            storage_min_soc = technologies.storage_techs_min_state_of_charge(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
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
            storage_max_capacity = technologies.storage_techs_max_capacity(find(strcmp(technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_capacity));
        end
        param_max_capacity_storage = strcat('\n\t\tParameter Storage_maximum_capacity {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
end

%compile technical parameters to string
params_section = strcat(params_section,param_linear_storage_costs,param_fixed_storage_costs,param_storage_lifetimes,param_storage_CRF,...
    param_S_matrix,param_max_charge_rate,param_max_discharge_rate,param_standing_losses,param_charging_efficiency,param_discharging_efficiency,param_min_soc,param_max_capacity_storage);
