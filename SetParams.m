%% SET PARAMETER VALUES

case_study = 'generic_energy_hub';
%technologies = ['CHP 1','CHP 2', 'CHP 3','Gas boiler 1','Solar PV 1','Solar thermal 1','Battery 1','Hot water tank 1'];
timestep = 'hours';
timesteps = 1:8760;
number_of_timesteps = length(timesteps);

%objectives
% 1: cost minimization
% 2: carbon minimization
objective = 1;

%select technologies and do sizing?
select_techs_and_do_sizing = 1;

%grid parameters
grid_connected_system = 1;

%price parameters
grid_electricity_price = 0.24;
grid_electricity_feedin_price = 0.14;
gas_price = 0.09;
carbon_price = 0;
interest_rate = 0.08;

%carbon parameters
carbon_limit_boolean = 0;
carbon_limit = 0;
grid_carbon_factor = 0.137;
gas_carbon_factor = 0.198;

%storage initialization methods:
% 1: initialize the storage SOC to the minimum SOC
% 2: constrain the initial storage SOC to the same value as the end value
electrical_storage_initialization_method = 1; 
heat_storage_initialization_method = 2;
cool_storage_initialization_method = 2;