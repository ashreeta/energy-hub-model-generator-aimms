%% GENERATE CARBON CONSTRAINTS

%max allowable carbon constraint
constraint_max_carbon = '';
if apply_constraint_max_carbon == 1
    constraint_max_carbon = '\n\t\tConstraint Maximum_carbon_emissions_constraint {\n\t\t\tDefinition: Total_carbon <= Carbon_emissions_limit;\n\t\t}';
end

constraint_interhub_exchange = '';
if apply_constraint_interhub_exchange == 1
    constraint_interhub_exchange = '\n\t\tConstraint Interhub_exchange_constraint {\n\t\t\tIndexDomain: (t,x,h,hh);\n\t\t\tDefinition: Interhub_exchanged_energy(t,x,h,hh) = -1 * Interhub_exchanged_energy(t,x,hh,h);\n\t\t}';
end

constraint_self_exchange = '';
if apply_constraint_self_exchange == 1
    constraint_self_exchange = '\n\t\tConstraint Self_exchange_constraint {\n\t\t\tIndexDomain: (t,x,h,hh) | h = hh;\n\t\t\tDefinition: Interhub_exchanged_energy(t,x,h,hh) = 0;\n\t\t}';
end

constraints_section = strcat(constraints_section,constraint_max_carbon,constraint_interhub_exchange,constraint_self_exchange);
