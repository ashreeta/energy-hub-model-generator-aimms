%% GENERATE STORAGE TECHNOLOGY CONSTRAINTS

if simplified_storage_representation == 0

    %energy balance constraints for storages
    constraint_energy_balance_storage = '';
    if apply_constraint_energy_balance_storage == 1
        constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,stor) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor) = (1 - Storage_standing_losses(stor)) * Storage_SOC(t-1,stor) + Storage_charging_efficiency(stor) *  Storage_input_energy(t,stor) - (1 / Storage_discharging_efficiency(stor)) * Storage_output_energy(t,stor);\n\t\t}';
    end

    %max allowable charging rate constraint
    constraint_max_charging_rate_storage = '';
    if apply_constraint_max_charging_rate_storage == 1
        constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_input_energy(t,stor) <= Storage_max_charge_rate(stor) * Storage_capacity(stor);\n\t\t}';
    end

    %max allowable discharging rate constraint
    constraint_max_discharging_rate_storage = '';
    if apply_constraint_max_discharging_rate_storage == 1
        constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_output_energy(t,stor) <= Storage_max_discharge_rate(stor) * Storage_capacity(stor);\n\t\t}';
    end

    %storage capacity constraint
    constraint_capacity_storage = '';
    if apply_constraint_capacity_storage == 1
        constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_SOC(t,stor) <= Storage_capacity(stor);\n\t\t}';
    end

    %minimum state of charge constraint
    constraint_min_soc_storage = '';
    if apply_constraint_min_soc_storage == 1
        constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_SOC(t,stor) >= Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}';
    end

    %fixed cost constraint for storage
    constraint_fixed_cost_storage = '';
    if apply_constraint_fixed_cost_storage == 1
        constraint_fixed_cost_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) <= Big_M * Installation_storage(stor);\n\t\t}';
    end

    %max capacity constraint for storage
    constraint_max_capacity_storage = '';
    if apply_constraint_max_capacity_storage == 1
        constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) <= Storage_maximum_capacity(stor);\n\t\t}';
    end
    
else
    
    %energy balance constraints for storages
    constraint_energy_balance_storage = '';
    if apply_constraint_energy_balance_storage == 1
        constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,x) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,x) = (1 - Storage_standing_losses(x)) * Storage_SOC(t-1,x) + Storage_charging_efficiency(x) *  Storage_input_energy(t,x) - (1 / Storage_discharging_efficiency(x)) * Storage_output_energy(t,x);\n\t\t}';
    end

    %max allowable charging rate constraint
    constraint_max_charging_rate_storage = '';
    if apply_constraint_max_charging_rate_storage == 1
        constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_input_energy(t,x) <= Storage_max_charge_rate(x) * Storage_capacity(x);\n\t\t}';
    end

    %max allowable discharging rate constraint
    constraint_max_discharging_rate_storage = '';
    if apply_constraint_max_discharging_rate_storage == 1
        constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_output_energy(t,x) <= Storage_max_discharge_rate(x) * Storage_capacity(x);\n\t\t}';
    end

    %storage capacity constraint
    constraint_capacity_storage = '';
    if apply_constraint_capacity_storage == 1
        constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_SOC(t,x) <= Storage_capacity(x);\n\t\t}';
    end

    %minimum state of charge constraint
    constraint_min_soc_storage = '';
    if apply_constraint_min_soc_storage == 1
        constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_SOC(t,x) >= Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
    end

    %fixed cost constraint for storage
    constraint_fixed_cost_storage = '';
    if apply_constraint_fixed_cost_storage == 1
        constraint_fixed_cost_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) <= Big_M * Installation_storage(x);\n\t\t}';
    end

    %max capacity constraint for storage
    constraint_max_capacity_storage = '';
    if apply_constraint_max_capacity_storage == 1
        constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) <= Storage_maximum_capacity(x);\n\t\t}';
    end
    
end

constraints_section = strcat(constraints_section,constraint_energy_balance_storage,constraint_max_charging_rate_storage,constraint_max_discharging_rate_storage,constraint_capacity_storage,...
    constraint_min_soc_storage,constraint_fixed_cost_storage,constraint_max_capacity_storage);
