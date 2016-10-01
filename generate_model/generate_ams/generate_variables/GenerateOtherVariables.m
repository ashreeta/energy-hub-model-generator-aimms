%% GENERATE OTHER VARIABLES

variable_energy_demands = '';
if create_variable_energy_demands
    variable_energy_demands = '\n\t\tVariable Energy_demands {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Loads(t,x);\n\t\t}';
end

variable_total_carbon_per_technology = '';
if create_variable_total_carbon_per_technology
    variable_total_carbon_per_technology = '\n\t\tVariable Total_carbon_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: free;\n\t\t\tDefinition: Technology_carbon_factors(conv)*sum(t,Input_energy(t,conv));\n\t\t}';
end

variable_total_carbon_per_timestep = '';
if create_variable_total_carbon_per_timestep
    variable_total_carbon_per_timestep = '\n\t\tVariable Total_carbon_per_timestep {\n\t\t\tIndexDomain: t;\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv,Technology_carbon_factors(conv)*Input_energy(t,conv));\n\t\t}';
end

section_footer = '\n\t}';

variables_section = strcat(variables_section,variable_energy_demands,variable_total_carbon_per_technology,variable_total_carbon_per_timestep);