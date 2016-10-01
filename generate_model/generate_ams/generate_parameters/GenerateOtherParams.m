%% GENERATE OTHER PARAMS FOR AMS FILE

%roof area
param_roof_area = '';
if create_param_roof_area == 1
    param_roof_area = strcat('\n\t\tParameter Building_roof_area {\n\t\t\tDefinition: ',num2str(roof_areas),';\n\t\t}');
end

%carbon factors
param_carbon_factors = '';
if create_param_carbon_factors == 1
    definition_string = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(technologies.conversion_techs_carbon_factors(t)));
    end
    param_carbon_factors = strcat('\n\t\tParameter Technology_carbon_factors {\n\t\t\tIndexDomain: (conv);\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
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

%compile other parameters to string
params_section = strcat(params_section,param_roof_area,param_carbon_factors,param_max_carbon,param_solar_radiation,param_big_M);