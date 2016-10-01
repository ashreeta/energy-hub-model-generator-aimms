%% GENERATE OBJECTIVE FUNCTIONS FOR AMS FILE

%equation for operating cost for grid
objectivefn_operating_cost_grid = '';
if create_objectivefn_operating_cost_grid
	if length(grid_electricity_price) > 1
        objectivefn_operating_cost_grid = '\n\t\tVariable Operating_cost_grid {\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv | conv = ''Grid'', sum(t, Operating_costs_grid(t) * Input_energy(t,conv)));\n\t\t}';
    else
        objectivefn_operating_cost_grid = '\n\t\tVariable Operating_cost_grid {\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv | conv = ''Grid'', sum(t, Operating_costs_grid * Input_energy(t,conv)));\n\t\t}';
	end
end

%equation for operating cost for energy carriers utilization, excluding the electricity grid
objectivefn_operating_cost = '\n\t\tVariable Operating_cost {\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv | conv <> ''Grid'', Operating_costs(conv) * sum(t,Input_energy(t,conv)));\n\t\t}';

%equation for total maintenance cost for operation of the devices
objectivefn_maintenance_cost = '\n\t\tVariable Maintenance_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((t,conv,x), Maintenance_cost_per_timestep(t,conv,x));\n\t\t}';

%equation for maintenance cost per timestep
objectivefn_maintenance_cost_per_timestep = '\n\t\tVariable Maintenance_cost_per_timestep {\n\t\t\tIndexDomain: (t,conv,x) | Cmatrix(x,conv) > 0;\n\t\t\tRange: free;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) * OMV_costs(conv);\n\t\t}';

%equation for income via exports
objectivefn_income_via_exports = '';
if grid_connected_system == 1
    objectivefn_income_via_exports = '\n\t\tVariable Income_via_exports {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(x, Electricity_feedin_price(x) * sum(t, Exported_energy(t,x)));\n\t\t}';
end

%equation for total investment costs for the energy hub
if simplified_storage_representation == 0
    if isempty(technologies.conversion_techs_names) == 0 && isempty(technologies.storage_techs_names) == 0 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,conv), (Fixed_capital_costs(x,conv) * Installation(x,conv) + Linear_capital_costs(x,conv) * Capacity(x,conv)) * CRF_tech(conv)) + sum((x,stor),(Fixed_capital_costs_storage(stor) * Installation_storage(x,stor) + Linear_capital_costs_storage(stor) * Storage_capacity(x,stor)) * CRF_stor(stor));\n\t\t}';
    elseif isempty(technologies.conversion_techs_names) == 1 && isempty(technologies.storage_techs_names) == 0 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,stor),(Fixed_capital_costs_storage(stor) * Installation_storage(x,stor) + Linear_capital_costs_storage(stor) * Storage_capacity(x,stor)) * CRF_stor(stor));\n\t\t}';
    elseif isempty(technologies.conversion_techs_names) == 0 && isempty(technologies.storage_techs_names) == 1 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,conv), (Fixed_capital_costs(x,conv) * Installation(x,conv) + Linear_capital_costs(x,conv) * Capacity(x,conv)) * CRF_tech(conv))';    
    elseif isempty(technologies.conversion_techs_names) == 1 && isempty(technologies.storage_techs_names) == 1 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: 0';
    else
        objectivefn_capital_cost = '';
    end
else
    if isempty(technologies.conversion_techs_names) == 0 && isempty(technologies.storage_techs_names) == 0 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,conv), (Fixed_capital_costs(x,conv) * Installation(x,conv) + Linear_capital_costs(x,conv) * Capacity(x,conv)) * CRF_tech(conv)) + sum(x,(Fixed_capital_costs_storage(x) * Installation_storage(x) + Linear_capital_costs_storage(x) * Storage_capacity(x)) * CRF_stor(x));\n\t\t}';
    elseif isempty(technologies.conversion_techs_names) == 1 && isempty(technologies.storage_techs_names) == 0 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(x,(Fixed_capital_costs_storage(x) * Installation_storage(x) + Linear_capital_costs_storage(x) * Storage_capacity(x)) * CRF_stor(x));\n\t\t}';
    elseif isempty(technologies.conversion_techs_names) == 0 && isempty(technologies.storage_techs_names) == 1 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,conv), (Fixed_capital_costs(x,conv) * Installation(x,conv) + Linear_capital_costs(x,conv) * Capacity(x,conv)) * CRF_tech(conv))';    
    elseif isempty(technologies.conversion_techs_names) == 1 && isempty(technologies.storage_techs_names) == 1 && select_techs_and_do_sizing == 1
        objectivefn_capital_cost = '\n\t\tVariable Capital_cost {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: 0';
    else
        objectivefn_capital_cost = '';
    end
end
    
%equation for total cost
if select_techs_and_do_sizing == 1 && grid_connected_system == 1
    objectivefn_total_cost = '\n\t\tVariable Total_cost {\n\t\t\tRange: free;\n\t\t\tDefinition: Capital_cost + Operating_cost + Operating_cost_grid + Maintenance_cost - Income_via_exports;\n\t\t}';
elseif select_techs_and_do_sizing == 0 && grid_connected_system == 1
    objectivefn_total_cost = '\n\t\tVariable Total_cost {\n\t\t\tRange: free;\n\t\t\tDefinition: Operating_cost + Operating_cost_grid + Maintenance_cost - Income_via_exports;\n\t\t}';
elseif select_techs_and_do_sizing == 1 && grid_connected_system == 0
    objectivefn_total_cost = '\n\t\tVariable Total_cost {\n\t\t\tRange: free;\n\t\t\tDefinition: Capital_cost + Operating_cost + Maintenance_costs;\n\t\t}';
else
    objectivefn_total_cost = '\n\t\tVariable Total_cost {\n\t\t\tRange: free;\n\t\t\tDefinition: Operating_cost + Maintenance_costs;\n\t\t}';
end
     
%equation for total carbon
objectivefn_total_carbon = '\n\t\tVariable Total_carbon {\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv,Technology_carbon_factors(conv)*sum(t,Input_energy(t,conv)));\n\t\t}';

%compile objective functions to string
objective_functions_section = strcat(objective_functions_section,objectivefn_operating_cost_grid,objectivefn_operating_cost,objectivefn_maintenance_cost,objectivefn_maintenance_cost_per_timestep,...
    objectivefn_income_via_exports,objectivefn_capital_cost,objectivefn_total_cost,objectivefn_total_carbon);