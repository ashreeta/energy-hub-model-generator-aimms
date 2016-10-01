%% GENERATE CARBON CONSTRAINTS

%max allowable carbon constraint
constraint_max_carbon = '';
if apply_constraint_max_carbon == 1
    constraint_max_carbon = '\n\t\tConstraint Maximum_carbon_emissions_constraint {\n\t\t\tIndexDomain: Total_carbon <= Carbon_emissions_limit;\n\t\t\tDefinition: ;\n\t\t}';
end

constraints_section = strcat(constraints_section,constraint_max_carbon);
