%% LOAD CASE STUDY DATA

%in the future, this should be done as follows:
%obtain case study data from the database
%translate database output to formats below and save as CSVs

%load  demand data
filename = strcat('case_study_data\',case_study,'\demand_data.csv');
[demand_data,demand_types,raw] = xlsread(filename);

demand_data = demand_data(11:end,:);
demand_types = demand_types(3,2:end);
consider_electricity_demand = 0;
consider_heating_demand = 0;
consider_cooling_demand = 0;
if sum(strcmp('Electricity',demand_types)) > 0
    electricity_demand_column = find(strcmp('Electricity',demand_types));
    electricity_demand = demand_data(:,electricity_demand_column);
    if sum(electricity_demand) > 0
        consider_electricity_demand = 1;
        xlswrite('aimms_model\energy_hub\electricity_demand.xlsx',electricity_demand,'electricity_demand');
    end
end
if sum(strcmp('Heat',demand_types)) > 0
    heating_demand_column = find(strcmp('Heat',demand_types));
    heat_demand = demand_data(:,heating_demand_column);
    if sum(heat_demand) > 0
        xlswrite('aimms_model\energy_hub\heating_demand.xlsx',heat_demand,'heating_demand');
        consider_heating_demand = 1;
    end
end
if sum(strcmp('Cooling',demand_types)) > 0
    cooling_demand_column = find(strcmp('Cooling',demand_types));
    cooling_demand = demand_data(:,cooling_demand_column);
    if sum(cooling_demand) > 0
        xlswrite('aimms_model\energy_hub\cooling_demand.xlsx',cooling_demand,'cooling_demand');
        consider_cooling_demand = 1;
    end
end
if sum(strcmp('DHW',demand_types)) > 0
    cooling_demand_column = find(strcmp('DHW',demand_types));
    cooling_demand = demand_data(:,cooling_demand_column);
    if sum(cooling_demand) > 0
        xlswrite('aimms_model\energy_hub\dhw_demand.xlsx',cooling_demand,'dhw_demand');
        consider_cooling_demand = 1;
    end
end

%load energy inputs data
filename = strcat('case_study_data\',case_study,'\energy_inputs_data.csv');
[inputs_data,inputs_types,raw] = xlsread(filename);

inputs_data = inputs_data(11:end,:);
inputs_types = inputs_types(3,2:end);
consider_solar_inputs = 0;
if sum(strcmp('Solar',inputs_types)) > 0
    solar_inputs_column = find(strcmp('Solar',inputs_types));
    solar_radiation = inputs_data(:,solar_inputs_column);
    if sum(solar_radiation) > 0
        consider_solar_inputs = 1;
        xlswrite('aimms_model\energy_hub\solar_inputs.xlsx',solar_radiation,'solar');
    end
end

%load node data
filename = strcat('case_study_data\',case_study,'\node_data.csv');
[data,text,raw] = xlsread(filename);

if ~isnan(cell2mat(raw(5,2:end)))
    roof_areas = data(5,:);
    roof_area_total = sum(roof_areas);
end

if ~isnan(cell2mat(raw(6,2:end)))
    floor_areas = data(6,:);
    floor_area_total = sum(floor_areas);
end