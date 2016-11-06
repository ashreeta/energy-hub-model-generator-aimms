%% LOAD THE TECHNOLOGY DATA

if select_techs_and_do_sizing == 1

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
    technologies.conversion_techs_min_capacity = num(9,1:end);
    technologies.conversion_techs_max_capacity = num(10,1:end);

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
    technologies.storage_techs_min_capacity = num(10,1:end);
    technologies.storage_techs_max_capacity = num(11,1:end);

    %if min/max thermal storage temperatures are given, set the values
    if sum(~isnan(cell2mat(raw(14,2:end)))) > 0 && sum(~isnan(cell2mat(raw(15,2:end)))) > 0 && sum(~isnan(cell2mat(raw(16,2:end)))) > 0
        technologies.storage_techs_min_temperature = cell2mat(raw(14,2:end));
        technologies.storage_techs_max_temperature = cell2mat(raw(15,2:end));
        technologies.storage_techs_specific_heat = cell2mat(raw(16,2:end));
    end
    
else
    
    %create empty conversion technology variables
    technologies.conversion_techs_names = [];
    technologies.conversion_techs_outputs = [];
    technologies.conversion_techs_inputs = [];
    technologies.conversion_techs_lifetime = [];
    technologies.conversion_techs_capital_cost_variable = [];
    technologies.conversion_techs_capital_cost_fixed = [];
    technologies.conversion_techs_OM_cost_variable = [];
    technologies.conversion_techs_OM_cost_fixed = [];
    technologies.conversion_techs_efficiency = [];
    technologies.conversion_techs_min_part_load = [];
    technologies.conversion_techs_HTP_ratio = [];
    technologies.conversion_techs_min_capacity = [];
    technologies.conversion_techs_max_capacity = [];
    
    %create empty storage technology variables
    technologies.storage_techs_names = [];
    technologies.storage_techs_types = [];
    technologies.storage_techs_lifetime = [];
    technologies.storage_techs_capital_cost_variable = [];
    technologies.storage_techs_capital_cost_fixed = [];
    technologies.storage_techs_charging_efficiency = [];
    technologies.storage_techs_discharging_efficiency = [];
    technologies.storage_techs_decay = [];
    technologies.storage_techs_max_charging_rate = [];
    technologies.storage_techs_max_discharging_rate = [];
    technologies.storage_techs_min_state_of_charge = [];
    technologies.storage_techs_min_capacity = [];
    technologies.storage_techs_max_capacity = [];
    
end

%% ADD THE INSTALLED TECHNOLOGIES

%if there are installed conversion technologies
if exist(strcat('case_study_data\',case_study,'\installed_conversion_technologies.csv'),'file')==2

    %add the installed energy conversion technologies
    number_of_installed_conversion_techs = length(installed_technologies.conversion_techs_names);

    technologies.conversion_techs_names = horzcat(technologies.conversion_techs_names,installed_technologies.conversion_techs_names);
    technologies.conversion_techs_outputs = horzcat(technologies.conversion_techs_outputs,installed_technologies.conversion_techs_outputs);
    technologies.conversion_techs_inputs = horzcat(technologies.conversion_techs_inputs,installed_technologies.conversion_techs_inputs);
    technologies.conversion_techs_lifetime = horzcat(technologies.conversion_techs_lifetime,zeros(1,number_of_installed_conversion_techs));
    technologies.conversion_techs_capital_cost_variable = horzcat(technologies.conversion_techs_capital_cost_variable,zeros(1,number_of_installed_conversion_techs));
    technologies.conversion_techs_capital_cost_fixed = horzcat(technologies.conversion_techs_capital_cost_fixed,zeros(1,number_of_installed_conversion_techs));
    technologies.conversion_techs_OM_cost_variable = horzcat(technologies.conversion_techs_OM_cost_variable,zeros(1,number_of_installed_conversion_techs));
    technologies.conversion_techs_OM_cost_fixed = horzcat(technologies.conversion_techs_OM_cost_fixed,zeros(1,number_of_installed_conversion_techs));
    technologies.conversion_techs_efficiency = horzcat(technologies.conversion_techs_efficiency,installed_technologies.conversion_techs_efficiency);
    technologies.conversion_techs_min_part_load = horzcat(technologies.conversion_techs_min_part_load,installed_technologies.conversion_techs_min_part_load);
    technologies.conversion_techs_HTP_ratio = horzcat(technologies.conversion_techs_HTP_ratio,installed_technologies.conversion_techs_HTP_ratio);
    technologies.conversion_techs_min_capacity = horzcat(technologies.conversion_techs_min_capacity,installed_technologies.conversion_techs_capacity);
    technologies.conversion_techs_max_capacity = horzcat(technologies.conversion_techs_max_capacity,installed_technologies.conversion_techs_capacity);
end

%if there are installed storage technologies
if exist(strcat('case_study_data\',case_study,'\installed_storage_technologies.csv'),'file')==2
    
    %add the installed energy storage technologies
    number_of_installed_storage_techs = length(installed_technologies.storage_techs_names);

    technologies.storage_techs_names = horzcat(technologies.storage_techs_names,installed_technologies.storage_techs_names);
    technologies.storage_techs_types = horzcat(technologies.storage_techs_types,installed_technologies.storage_techs_types);
    technologies.storage_techs_lifetime = horzcat(technologies.storage_techs_lifetime,zeros(1,number_of_installed_storage_techs));
    technologies.storage_techs_capital_cost_variable = horzcat(technologies.storage_techs_capital_cost_variable,zeros(1,number_of_installed_storage_techs));
    technologies.storage_techs_capital_cost_fixed = horzcat(technologies.storage_techs_capital_cost_fixed,zeros(1,number_of_installed_storage_techs));
    technologies.storage_techs_charging_efficiency = horzcat(technologies.storage_techs_charging_efficiency,installed_technologies.storage_techs_charging_efficiency);
    technologies.storage_techs_discharging_efficiency = horzcat(technologies.storage_techs_discharging_efficiency,installed_technologies.storage_techs_discharging_efficiency);
    technologies.storage_techs_decay = horzcat(technologies.storage_techs_decay,installed_technologies.storage_techs_decay);
    technologies.storage_techs_max_charging_rate = horzcat(technologies.storage_techs_max_charging_rate,installed_technologies.storage_techs_max_charging_rate);
    technologies.storage_techs_max_discharging_rate = horzcat(technologies.storage_techs_max_discharging_rate,installed_technologies.storage_techs_max_discharging_rate);
    technologies.storage_techs_min_state_of_charge = horzcat(technologies.storage_techs_min_state_of_charge,installed_technologies.storage_techs_min_state_of_charge);
    technologies.storage_techs_min_capacity = horzcat(technologies.storage_techs_min_capacity,installed_technologies.storage_techs_capacity);
    technologies.storage_techs_max_capacity = horzcat(technologies.storage_techs_max_capacity,installed_technologies.storage_techs_capacity);

    %if min/max thermal storage temperatures are given, set the values
    if exist('installed_technologies.storage_techs_min_temperature','var') == 1 && exist('installed_technologies.storage_techs_max_temperature','var') == 1 && exist('installed_technologies.storage_techs_specific_heat','var') == 1
        technologies.storage_techs_min_temperature = horzcat(technologies.storage_techs_min_temperature,installed_technologies.storage_techs_min_temperature);
        technologies.storage_techs_max_temperature = horzcat(technologies.storage_techs_max_temperature,installed_technologies.storage_techs_max_temperature);
        technologies.storage_techs_specific_heat = horzcat(technologies.storage_techs_specific_heat,installed_technologies.storage_techs_specific_heat);
    end
end

%% ADD THE ELECTRICITY GRID

%add the electricity grid properties to the conversion technology data
if grid_connected_system == 1
    if size_grid_connection == 1

        technologies.conversion_techs_names(end+1) = {'Grid'};
        technologies.conversion_techs_outputs(end+1) = {'Elec'};
        technologies.conversion_techs_inputs(end+1) = {'None'};
        technologies.conversion_techs_lifetime(end+1) = 0;
        technologies.conversion_techs_capital_cost_variable(end+1) = grid_initial_connection_cost_per_kW;
        technologies.conversion_techs_capital_cost_fixed(end+1) = grid_initial_connection_cost_fixed;
        technologies.conversion_techs_OM_cost_variable(end+1) = grid_connection_cost_per_kW;
        technologies.conversion_techs_OM_cost_fixed(end+1) = grid_connection_cost_fixed;
        technologies.conversion_techs_efficiency(end+1) = 1.0;
        technologies.conversion_techs_min_part_load(end+1) = 0;
        technologies.conversion_techs_HTP_ratio(end+1) = 0;
        technologies.conversion_techs_min_capacity(end+1) = grid_min_connection_capacity;
        technologies.conversion_techs_max_capacity(end+1) = grid_max_connection_capacity;

    else

        technologies.conversion_techs_names(end+1) = {'Grid'};
        technologies.conversion_techs_outputs(end+1) = {'Elec'};
        technologies.conversion_techs_inputs(end+1) = {'None'};
        technologies.conversion_techs_lifetime(end+1) = 0;
        technologies.conversion_techs_capital_cost_variable(end+1) = 0;
        technologies.conversion_techs_capital_cost_fixed(end+1) = 0;
        technologies.conversion_techs_OM_cost_variable(end+1) = 0;
        technologies.conversion_techs_OM_cost_fixed(end+1) = 0;
        technologies.conversion_techs_efficiency(end+1) = 1.0;
        technologies.conversion_techs_min_part_load(end+1) = 0;
        technologies.conversion_techs_HTP_ratio(end+1) = 0;
        technologies.conversion_techs_min_capacity(end+1) = grid_connection_capacity;
        technologies.conversion_techs_max_capacity(end+1) = grid_connection_capacity;

    end
end

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

%% CLEAN UP THE STRINGS

%remove spaces from the names/properties of the conversion and storage technologies
technologies.conversion_techs_names = strrep(technologies.conversion_techs_names,' ','_');
technologies.conversion_techs_outputs = strrep(technologies.conversion_techs_outputs,' ','_');
technologies.conversion_techs_inputs = strrep(technologies.conversion_techs_inputs,' ','_');
technologies.storage_techs_names = strrep(technologies.storage_techs_names,' ','_');
technologies.storage_techs_types = strrep(technologies.storage_techs_types,' ','_');

%remove spaces from the names/properties of the installed conversion and storage technologies

%if there are installed conversion technologies
if exist(strcat('case_study_data\',case_study,'\installed_conversion_technologies.csv'),'file')==2
    installed_technologies.conversion_techs_names = strrep(installed_technologies.conversion_techs_names,' ','_');
    installed_technologies.conversion_techs_outputs = strrep(installed_technologies.conversion_techs_outputs,' ','_');
    installed_technologies.conversion_techs_inputs = strrep(installed_technologies.conversion_techs_inputs,' ','_');
end

%if there are installed storage technologies
if exist(strcat('case_study_data\',case_study,'\installed_storage_technologies.csv'),'file')==2
    installed_technologies.storage_techs_names = strrep(installed_technologies.storage_techs_names,' ','_');
    installed_technologies.storage_techs_types = strrep(installed_technologies.storage_techs_types,' ','_');
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
dhw_generating_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_outputs,'DHW')));
anergy_generating_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_outputs,'Anergy')));
electricity_consuming_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_inputs,'Elec')));
heat_consuming_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_inputs,'Heat')));
anergy_consuming_technologies = technologies.conversion_techs_names(find(strcmp(technologies.conversion_techs_inputs,'Anergy')));
electricity_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Elec')));
heat_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Heat')));
cool_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Cool')));
dhw_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'DHW')));
anergy_storage_technologies = technologies.storage_techs_names(find(strcmp(technologies.storage_techs_types,'Anergy')));
if exist('technologies.storage_techs_min_temperature','var')
    storages_with_temperature_constraints = technologies.storage_techs_names(find(~isnan(technologies.storage_techs_min_temperature)));
else
    storages_with_temperature_constraints = [];
end

