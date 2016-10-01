%% LOAD THE TECHNOLOGY DATA

%read the conversion technology data
filename = 'technology_data\conversion_technology_data.csv';
[num,text,raw] = xlsread(filename);

technologies.conversion_techs_names = raw(1,2:end);
technologies.conversion_techs_outputs = raw(2,2:end);
technologies.conversion_techs_inputs = raw(3,2:end);
technologies.conversion_techs_lifetime = num(1,1:end);
technologies.conversion_techs_capital_cost_variable = num(2,1:end);
technologies.conversion_techs_capital_cost_fixed = num(3,1:end);
technologies.conversion_techs_OM_cost_variable = num(4,1:end);
technologies.conversion_techs_OM_cost_fixed = num(5,1:end);
technologies.conversion_techs_efficiency = num(6,1:end);
technologies.conversion_techs_min_part_load = num(7,1:end);
technologies.conversion_techs_HTP_ratio = num(8,1:end);
technologies.conversion_techs_capacity = num(9,1:end);
technologies.conversion_techs_min_capacity = num(10,1:end);
technologies.conversion_techs_max_capacity = num(11,1:end);

% read the storage technology data
filename = 'technology_data\storage_technology_data.csv';
[num,text,raw] = xlsread(filename);

technologies.storage_techs_names = raw(1,2:end);
technologies.storage_techs_types = raw(2,2:end);
technologies.storage_techs_lifetime = num(1,1:end);
technologies.storage_techs_capital_cost_variable = num(2,1:end);
technologies.storage_techs_capital_cost_fixed = num(3,1:end);
technologies.storage_techs_charging_efficiency = num(4,1:end);
technologies.storage_techs_discharging_efficiency = num(5,1:end);
technologies.storage_techs_decay = num(6,1:end);
technologies.storage_techs_max_charging_rate = num(7,1:end);
technologies.storage_techs_max_discharging_rate = num(8,1:end);
technologies.storage_techs_min_state_of_charge = num(9,1:end);
technologies.storage_techs_capacity = num(10,1:end);
technologies.storage_techs_min_capacity = num(11,1:end);
technologies.storage_techs_max_capacity = num(12,1:end);

%% ADD THE ELECTRICITY GRID

%add the electricity grid properties to the conversion technology data
technologies.conversion_techs_names(end+1) = {'Electricity grid'};
technologies.conversion_techs_outputs(end+1) = {'Electricity'};
technologies.conversion_techs_inputs(end+1) = {'None'};
technologies.conversion_techs_lifetime(end+1) = 0;
technologies.conversion_techs_capital_cost_variable(end+1) = grid_initial_connection_cost_per_kW;
technologies.conversion_techs_capital_cost_fixed(end+1) = grid_initial_connection_cost_fixed;
technologies.conversion_techs_OM_cost_variable(end+1) = grid_connection_cost_per_kW;
technologies.conversion_techs_OM_cost_fixed(end+1) = grid_connection_cost_fixed;
technologies.conversion_techs_efficiency(end+1) = 1.0;
technologies.conversion_techs_min_part_load(end+1) = 0;
technologies.conversion_techs_HTP_ratio(end+1) = 0;
technologies.conversion_techs_capacity(end+1) = grid_connection_capacity;
technologies.conversion_techs_min_capacity(end+1) = grid_min_connection_capacity;
technologies.conversion_techs_max_capacity(end+1) = grid_max_connection_capacity;

%% ADD OPERATING COSTS

%add operating costs to the conversion technology data
technologies.conversion_techs_operating_costs = [];
for t=1:length(technologies.conversion_techs_names)
    if strcmp(technologies.conversion_techs_names(t),'Grid')
        technologies.conversion_techs_operating_costs(t) = grid_electricity_price;
    elseif strcmp(technologies.conversion_techs_inputs(t),'Gas')
        technologies.conversion_techs_operating_costs(t) = gas_price;
    else
        technologies.conversion_techs_operating_costs(t) = 0;
    end
end

%% ADD CARBON FACTORS

%add carbon factors to the conversion technology data
technologies.conversion_techs_carbon_factors = [];
for t=1:length(technologies.conversion_techs_names)
    if strcmp(technologies.conversion_techs_names(t),'Grid')
        technologies.conversion_techs_carbon_factors(t) = electricity_grid_carbon_factor;
    elseif strcmp(technologies.conversion_techs_inputs(t),'Gas')
        technologies.conversion_techs_carbon_factors(t) = natural_gas_carbon_factor;
    else
        technologies.conversion_techs_carbon_factors(t) = 0;
    end
end


%% SET SOME VARIABLE VALUES FOR LATER USE

%get a list of the energy outputs
energy_outputs = technologies.conversion_techs_outputs;
energy_outputs(find(strcmp(energy_outputs,'CHP'))) = []; %remove CHP
if sum(strcmp(technologies.conversion_techs_outputs,'CHP')) > 0
    energy_outputs = horzcat(energy_outputs,{'Heat','Elec'}); %add the outputs of CHP
end
energy_outputs = unique(energy_outputs);

%get lists of different groupings of conversion technologies
energy_conversion_technologies = technologies.conversion_techs_names;
energy_storage_technologies = technologies.storage_techs_names;
solar_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_inputs,'Solar')));
technologies_excluding_grid = technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_names,'Grid')));
dispatchable_technologies = intersect(technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_names,'Grid'))),...
    technologies.conversion_techs_names(find(~strcmp(technologies.conversion_techs_inputs,'Solar'))));
chp_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_outputs,'CHP')));
electricity_generating_technologies = technologies.conversion_techs_names(find(ismember(technologies.conversion_techs_outputs,{'Elec','CHP'})));
heat_generating_technologies = technologies.conversion_techs_names(find(ismember(technologies.conversion_techs_outputs,{'Heat','CHP'})));
heat_generating_technologies_excluding_chp = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_outputs,'Heat')));
cooling_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_outputs,'Cool')));
electricity_consuming_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_inputs,'Elec')));
heat_consuming_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_inputs,'Heat')));
electricity_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Elec')));
heat_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Heat')));
cool_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Cool')));
