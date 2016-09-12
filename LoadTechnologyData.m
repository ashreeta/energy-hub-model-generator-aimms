%% LOAD TECHNOLOGY DATA

%in the future, this should be done as follows:
%obtain technology data from database using query
%translate database output to the matrix format below and save as an m-file or struct

%create conversion technology matrix
%1: Capital cost per kW
%2: Capital cost per m2
%3: OMF cost (CHF/kW)
%4: OMV cost (CHF/kWh)
%5: Efficiency
%6: Lifetime (years)
%7: Heat-to-power_ratio
%8: Minimum load (percent)
%9: Minimum capacity (kW)
%10: Maximum capacity (kW)
%11: Carbon factors

%create storage technology matrix
%1: Capital cost (CHF/kWh)
%2: Lifetime (years)
%3: Charging efficiency
%4: Discharging efficiency
%5: Decay (per hour)
%6: Maximum charging rate
%7: Maximum discharging rate
%8: Minimum storage state
%9: Minimum capacity (kWh)
%10: Maximum capacity (kWh)

%notes:
%remember to include grid as technology
%energy_conversion_technologies (put semicolens between entries)

%create the technology data
conversion_techs_names = {'Heat_pump','Boiler','CHP1','PV','ST'};
conversion_techs_inputs = {'Elec','Gas','Gas','Solar','Solar'};
conversion_techs_outputs = {'Heat','Heat','CHP','Elec','Heat'};
conversion_techs_specs = [1000,200,1500,437.5,2030;0,0,0,0,0;0.1,0.01,0.021,0.06,0.12;3.2,0.94,0.3,0.14,0.46;20,30,20,20,35;0,0,1.73,0,0;0,0,0.5,0,0;0,0,50,0,0;100,100,50,roof_areas,roof_areas;0,gas_carbon_factor,gas_carbon_factor,0,0];
storage_techs_names = {'Battery','Hot_water_tank'};
storage_techs_types = {'Elec','Heat'};
storage_techs_specs = [100,100;20,17;0.9,0.9;0.9,0.9;0.001,0.01;0.3,0.25;0.3,0.25;0.3,0;0,0;100,100];

%add two more chp technologies, identical to the first
conversion_techs_names(end+1) = {'CHP2'};
conversion_techs_inputs(end+1) = {'Gas'};
conversion_techs_outputs(end+1) = {'CHP'};
conversion_techs_specs = horzcat(conversion_techs_specs,[1500;0;0.021;0.3;20;1.73;0.5;50;50;gas_carbon_factor]);
conversion_techs_names(end+1) = {'CHP3'};
conversion_techs_inputs(end+1) = {'Gas'};
conversion_techs_outputs(end+1) = {'CHP'};
conversion_techs_specs = horzcat(conversion_techs_specs,[1500;0;0.021;0.3;20;1.73;0.5;50;50;gas_carbon_factor]);

%add grid as a technology
conversion_techs_names(end+1) = {'Grid'};
conversion_techs_inputs(end+1) = {'None'};
conversion_techs_outputs(end+1) = {'Elec'};
conversion_techs_specs = horzcat(conversion_techs_specs,[0;0;0;1.0;0;0;0;0;0;grid_carbon_factor]);

%add technology operating costs
technology_operating_costs = [];
for t=1:length(conversion_techs_inputs)
    if strcmp(conversion_techs_names(t),'Grid')
        technology_operating_costs(t) = grid_electricity_price;
    elseif strcmp(conversion_techs_inputs(t),'Gas')
        technology_operating_costs(t) = gas_price;
    else
        technology_operating_costs(t) = 0;
    end
end

%creat a struct of the technology data
%technologies = struct('conversion_techs_names',conversion_techs_names,'conversion_techs_inputs',conversion_techs_inputs,'conversion_techs_outputs',conversion_techs_outputs,'conversion_techs_specs',conversion_techs_specs),...
%    'storage_techs_names',storage_techs_names,'storage_techs_types',storage_techs_types,'storage_techs_specs',storage_techs_specs);
technologies.conversion_techs_names = conversion_techs_names;
technologies.conversion_techs_inputs = conversion_techs_inputs;
technologies.conversion_techs_outputs = conversion_techs_outputs;
technologies.conversion_techs_specs = conversion_techs_specs;
technologies.storage_techs_names = storage_techs_names;
technologies.storage_techs_types = storage_techs_types;
technologies.storage_techs_specs = storage_techs_specs;

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

%this is temporary since in the initial data we have now there's no fixed
%storage cost category.
technology_fixed_storage_costs = zeros(1,length(technologies.storage_techs_names));







