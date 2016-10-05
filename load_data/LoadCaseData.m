%% LOAD CASE STUDY DATA

%clean up the files
if exist('aimms_model\energy_hub\electricity_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\electricity_demand.xlsx');
end
if exist('aimms_model\energy_hub\heating_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\heating_demand.xlsx');
end
if exist('aimms_model\energy_hub\cooling_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\cooling_demand.xlsx');
end
if exist('aimms_model\energy_hub\dhw_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\dhw_demand.xlsx');
end
if exist('aimms_model\energy_hub\solar_inputs.xlsx','file')==2
  delete('aimms_model\energy_hub\solar_inputs.xlsx');
end

%load  demand data
filename = strcat('case_study_data\',case_study,'\demand_data.csv');
[demand_data,demand_types,raw] = xlsread(filename);

%extract the demand data
demand_data = demand_data(11:end,:);
demand_types = demand_types(3,2:end);

%determine the number of hubs
multiple_hubs = 0;
hubs = cell2mat(raw(4,2:end));
hub_list = sort(unique(hubs));
number_of_hubs = length(hub_list);
if number_of_hubs > 1
    multiple_hubs = 1;
end

%write the demand data files
consider_electricity_demand = 0;
consider_heating_demand = 0;
consider_cooling_demand = 0;
consider_dhw_demand = 0;

hub_demands = [];
if sum(strcmp('Electricity',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Electricity',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_electricity_demand = 1;
        xlswrite('aimms_model\energy_hub\electricity_demand.xlsx',hub_demands,'electricity_demand');
    end
end
hub_demands = [];
if sum(strcmp('Heat',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Heat',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_heating_demand = 1;
        xlswrite('aimms_model\energy_hub\heating_demand.xlsx',hub_demands,'heating_demand');
    end
end
hub_demands = [];
if sum(strcmp('Cooling',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Cooling',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_cooling_demand = 1;
        xlswrite('aimms_model\energy_hub\cooling_demand.xlsx',hub_demands,'cooling_demand');
    end
end
hub_demands = [];
if sum(strcmp('DHW',demand_types)) > 0
    relevant_demand_columns = find(strcmp('DHW',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_dhw_demand = 1;
        xlswrite('aimms_model\energy_hub\dhw_demand.xlsx',hub_demands,'dhw_demand');
    end
end

%load energy inputs data
filename = strcat('case_study_data\',case_study,'\energy_inputs_data.csv');
[inputs_data,inputs_types,raw] = xlsread(filename);

inputs_data = inputs_data(11:end,:);
inputs_types = inputs_types(3,2:end);
hubs = cell2mat(raw(4,2:end));

consider_solar_inputs = 0;
solar_radiations = [];
if sum(strcmp('Solar',inputs_types)) > 0
    solar_inputs_columns = find(strcmp('Solar',inputs_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        solar_radiation = inputs_data(:,intersect(hub_columns,solar_inputs_columns));
        solar_radiations = horzcat(solar_radiations, solar_radiation);
    end
    if sum(sum(solar_radiations)) > 0
        consider_solar_inputs = 1;
        xlswrite('aimms_model\energy_hub\solar_inputs.xlsx',solar_radiations,'solar');
    end
end

%load node data
filename = strcat('case_study_data\',case_study,'\node_data.csv');
[data,text,raw] = xlsread(filename);

hubs = cell2mat(raw(1,2:end));

%set the value of the roof areas
%TODO: this is a stupidly inefficient way to do this
if ~isnan(cell2mat(raw(5,2:end)))
    roof_areas_unsorted = data(5,:);
    for h = sort(unique(hubs))
        roof_areas_sorted(h) = roof_areas_unsorted(find(hubs == h));
    end
end
roof_areas = roof_areas_sorted;

%set the value of the floor areas
%TODO: this is a stupidly inefficient way to do this
if ~isnan(cell2mat(raw(6,2:end)))
    floor_areas_unsorted = data(6,:);
    for h = sort(unique(hubs))
        floor_areas_sorted(h) = floor_areas_unsorted(find(hubs == h));
    end
end
floor_areas = floor_areas_sorted;