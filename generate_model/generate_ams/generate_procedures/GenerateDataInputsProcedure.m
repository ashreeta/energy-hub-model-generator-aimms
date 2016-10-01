%% LOAD INPUT DATA

load_electricity_demand_data = '';
load_heating_demand_data = '';
load_cooling_demand_data = '';

if consider_electricity_demand == 1
    load_electricity_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "electricity_demand.xlsx", Loads(t,''Elec''),"A1:A',num2str(number_of_timesteps),'","electricity_demand");');
end
if consider_heating_demand == 1
    load_heating_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "heating_demand.xlsx", Loads(t,''Heat''),"A1:A',num2str(number_of_timesteps),'","heating_demand");');
end
if consider_cooling_demand == 1
    load_cooling_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "cooling_demand.xlsx", Loads(t,''Cool''),"A1:A',num2str(number_of_timesteps),'","cooling_demand");');
end

load_solar_data = '';
if isempty(solar_technologies) == 0
    load_solar_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "solar_inputs.xlsx", Solar_radiation(t),"A1:A',num2str(number_of_timesteps),'","solar");');
end

load_electricity_price_data = '';
if length(grid_electricity_price) > 1
    load_electricity_price_data = strcat('Spreadsheet::RetrieveParameter( "electricity_costs.xlsx", Operating_costs_grid(t),"A1:A',num2str(number_of_timesteps),'","electricity_costs");');
end

data_inputs_procedure = strcat(load_electricity_demand_data,load_heating_demand_data,load_cooling_demand_data,load_solar_data,load_electricity_price_data);
