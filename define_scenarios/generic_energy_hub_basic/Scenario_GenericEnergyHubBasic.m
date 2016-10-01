%% DESCRIPTION OF THE SCENARIO
% This is a simple scenario based on the generic energy hub model. 

%% SET THE SCENARIO NAME

%used for saving the results
scenario_name = 'generic_energy_hub_basic';

%% CASE TO BE ANALYZED

case_study = 'generic_energy_hub';

%% TECHNOLOGIES TO BE INCLUDED

%technologies = ['CHP 1','CHP 2', 'CHP 3','Gas boiler 1','Solar PV 1','Solar thermal 1','Battery 1','Hot water tank 1'];

%% OBJECTIVE AND THE TYPE OF OPTIMIZATION

%objectives
% 1: cost minimization
% 2: carbon minimization
objective = 1;

%select technologies and do sizing?
select_techs_and_do_sizing = 1;

%% TIME VARIABLES

timestep = 'hours';
timesteps = 1:8760;
number_of_timesteps = length(timesteps);

%% ELECTRICITY GRID PARAMETERS

grid_connected_system = 1;

grid_initial_connection_cost_per_kW = 0;
grid_initial_connection_cost_fixed = 0;
grid_connection_cost_per_kW = 0;
grid_connection_cost_fixed = 0;
grid_connection_capacity = 1000000;
grid_min_connection_capacity = 1000000;
grid_max_connection_capacity = 1000000;

%% PRICE PARAMETERS

dynamic_electricity_price = 0;

grid_electricity_price = 0.24;
grid_electricity_feedin_price = 0.14;
gas_price = 0.09;
carbon_price = 0;
interest_rate = 0.08;

if dynamic_electricity_price == 1
    grid_electricity_price = csvread(strcat('scenarios\',scenario_name,'\electricity_costs.csv'));
    grid_electricity_price = grid_electricity_price(:,3);
    xlswrite('aimms_model\energy_hub\electricity_costs.xlsx',grid_electricity_price,'electricity_costs');
end

%% CARBON PARAMETERS

carbon_limit_boolean = 0;
carbon_limit = 0;
electricity_grid_carbon_factor = 0.137;
natural_gas_carbon_factor = 0.198;

%% CONSTRAINT OPTIONS

%storage initialization methods:
% 1: initialize the storage SOC to the minimum SOC
% 2: constrain the initial storage SOC to the same value as the end value
electrical_storage_initialization_method = 1; 
heat_storage_initialization_method = 2;
cool_storage_initialization_method = 2;