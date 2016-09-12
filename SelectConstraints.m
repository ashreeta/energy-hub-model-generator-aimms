
%% SET THE CONSTRAINTS TO BE APPLIED
% These constraints are automatically set based on selected options/inputs
% Generally, these should not be changed

% INITIALLY, SET ALL THE CONSTRAINTS TO ZERO
apply_constraint_energy_balance = 0;
apply_constraint_capacity = 0;
apply_constraint_min_part_load1 = 0;
apply_constraint_min_part_load2 = 0;
apply_constraint_solar_availability = 0;
apply_constraint_roof_area = 0;
apply_constraint_max_capacity = 0;
apply_constraint_fixed_cost = 0;
apply_constraint_operation = 0;
apply_constraint_electricity_export = 0;
apply_constraint_htp_ratio = 0;
apply_constraint_chp1 = 0;
apply_constraint_chp2 = 0;
apply_constraint_energy_balance_storage = 0;
apply_constraint_max_charging_rate_storage = 0;
apply_constraint_max_discharging_rate_storage = 0;
apply_constraint_capacity_storage = 0;
apply_constraint_min_soc_storage = 0;
apply_constraint_electrical_storage_initialization_to_min_soc = 0;
apply_constraint_electrical_storage_initialization_cyclical = 0;
apply_constraint_electrical_storage_1st_hour = 0;
apply_constraint_heat_storage_initialization_to_min_soc = 0;
apply_constraint_heat_storage_initialization_cyclical = 0;
apply_constraint_heat_storage_1st_hour = 0;
apply_constraint_cool_storage_initialization_to_min_soc = 0;
apply_constraint_cool_storage_initialization_cyclical = 0;
apply_constraint_cool_storage_1st_hour = 0;
apply_constraint_fixed_cost_storage = 0;
apply_constraint_max_capacity_storage = 0;
apply_constraint_max_carbon = 0;

%ACTIVATE THE DIFFERENT CONSTRAINTS DEPENDING ON THE INPUTS
% These constraints are applicable as long as you are considering energy conversion techs
if isempty(technologies.conversion_techs_names) == 0
    apply_constraint_energy_balance = 1;
    apply_constraint_capacity = 1;
    apply_constraint_min_part_load1 = 1;
    apply_constraint_min_part_load2 = 1;
    
    %only applicable if the system is grid connected
    if grid_connected_system == 1
        apply_constraint_electricity_export = 1;
    end
    
    %only applicable if you're considering solar technologies
    if isempty(solar_technologies) == 0
        apply_constraint_solar_availability = 1;
        apply_constraint_roof_area = 1;
    end

    %only applicable if you're doing sizing & tech selection of conversion techs
    if select_techs_and_do_sizing == 1
        apply_constraint_max_capacity = 1;
        apply_constraint_fixed_cost = 1;
        apply_constraint_operation = 1;
    end

    %only applicable if you're doing sizing & tech selection AND are considering CHP techs
    if isempty(chp_technologies) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_htp_ratio = 1;
        apply_constraint_chp1 = 1;
        apply_constraint_chp2 = 1;
    end
end

if isempty(technologies.conversion_techs_names) == 0
    %only applicable if you're considering storage techs
    apply_constraint_energy_balance_storage = 1;
    apply_constraint_max_charging_rate_storage = 1;
    apply_constraint_max_discharging_rate_storage = 1;
    apply_constraint_capacity_storage = 1;
    apply_constraint_min_soc_storage = 1;
    
    %only applicable if you're doing sizing and tech selection of storage
    if select_techs_and_do_sizing == 1
        apply_constraint_fixed_cost_storage = 1;
        apply_constraint_max_capacity_storage = 1;
    end
end

%based on the selected initialization method options
%only applicable if you're considering electricity storage techs
if isempty(electricity_storage_technologies) == 0
    if electrical_storage_initialization_method == 1 
        apply_constraint_electrical_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_electrical_storage_initialization_cyclical = 1;
        apply_constraint_electrical_storage_1st_hour = 1;
    end 
end

%only applicable if you're considering heat storage techs
if isempty(heat_storage_technologies) == 0
    if heat_storage_initialization_method == 1
        apply_constraint_heat_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_heat_storage_initialization_cyclical = 1;
        apply_constraint_heat_storage_1st_hour = 1;
    end
end

%only applicable if you're considering cool storage techs
if isempty(cool_storage_technologies) == 0
    if cool_storage_initialization_method == 1
        apply_constraint_cool_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_cool_storage_initialization_cyclical = 1;
        apply_constraint_cool_storage_1st_hour = 1;
    end
end

%only applicable if you have a carbon constraint
if carbon_limit_boolean == 1
    apply_constraint_max_carbon = 1;
end
