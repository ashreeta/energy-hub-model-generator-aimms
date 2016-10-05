%% WRITE OUTPUT DATA

%calculate some variables for printing the results
number_of_conversion_techs = length(technologies.conversion_techs_names);
number_of_dispatchable_techs = length(dispatchable_technologies);
number_of_storage_techs = length(technologies.storage_techs_names);
number_of_timesteps = length(timesteps);

%find the excel column assignments
%NOTE: THIS ONLY WORKS IF YOU HAVE 26 OR FEWER TECHNOLOGIES

demand_data_for_printing = '';
if print_demand_data == 1
    demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results_demands.xlsx","Energy_demands");');
    if multiple_hubs == 0
        demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_demands.xlsx",Energy_demands,"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Energy_demands",0,1,1);');
    else
        for h = 1:number_of_hubs
            demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_demands.xlsx","Energy_demands_hub',num2str(h),'");');
            demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_demands.xlsx",Energy_demands(t,x,''',num2str(h),'''),"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Energy_demands_hub',num2str(h),'",0,1,1);');
        end
    end
    demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results_demands.xlsx",1);');
end

conversion_data_for_printing = '';
if print_conversion_data == 1 && isempty(technologies.conversion_techs_names) == 0
    conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results_conversion.xlsx","Input_energy");');
    if multiple_hubs == 0
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Input_energy,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Input_energy",0,1,1);');
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Exported_energy");');
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Exported_energy,"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Exported_energy",0,1,1);');
        if consider_electricity_demand == 1
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Output_energy_electricity");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Output_energy_electricity,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_electricity",0,1,1);');
        end
        if consider_heating_demand == 1
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Output_energy_heat");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Output_energy_heat,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_heat",0,1,1);');
        end
        if consider_cooling_demand == 1
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Output_energy_cool");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Output_energy_heat,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_cool",0,1,1);');
        end
    else
        for h = 1:number_of_hubs
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Input_energy_hub',num2str(h),'");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Input_energy(t,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Input_energy_hub',num2str(h),'",0,1,1);');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Exported_energy_hub',num2str(h),'");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Exported_energy(t,x,''',num2str(h),'''),"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Exported_energy_hub',num2str(h),'",0,1,1);');
            if consider_electricity_demand == 1
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Output_energy_electricity_hub',num2str(h),'");');
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Output_energy_electricity(t,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_electricity_hub',num2str(h),'",0,1,1);');
            end
            if consider_heating_demand == 1
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Output_energy_heat_hub',num2str(h),'");');
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Output_energy_heat(t,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_heat_hub',num2str(h),'",0,1,1);');
            end
            if consider_cooling_demand == 1
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_conversion.xlsx","Output_energy_cool_hub',num2str(h),'");');
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_conversion.xlsx",Output_energy_heat(t,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_cool_hub',num2str(h),'",0,1,1);');
            end
        end
    end
    conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results_conversion.xlsx",1);');
end

storage_data_for_printing = '';
if print_storage_data == 1 && isempty(technologies.storage_techs_names) == 0
	storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results_storage.xlsx","Storage_input_energy");');
    if multiple_hubs == 0
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_storage.xlsx","Storage_output_energy");');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_storage.xlsx","Storage_SOC");');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_input_energy,"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_input_energy",0,1,1);');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_output_energy,"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_output_energy",0,1,1);');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_SOC,"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_SOC",0,1,1);');
    else
        for h = 1:number_of_hubs
            storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_storage.xlsx","Storage_input_energy_hub',num2str(h),'");');
            storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_storage.xlsx","Storage_output_energy_hub',num2str(h),'");');
            storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_storage.xlsx","Storage_SOC_hub',num2str(h),'");');
            if simplified_storage_representation == 1
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_input_energy(t,x,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_input_energy_hub',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_output_energy(t,x,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_output_energy_hub',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_SOC(t,x,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_SOC_hub',num2str(h),'",0,1,1);');
            else
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_input_energy(t,stor,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_input_energy_hub',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_output_energy(t,stor,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_output_energy_hub',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_storage.xlsx",Storage_SOC(t,stor,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_SOC_hub',num2str(h),'",0,1,1);');
            end
        end
    end
    storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results_storage.xlsx",1);');
end

installation_data_for_printing = '';
if print_installation_data == 1 && select_techs_and_do_sizing == 1
	installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results_capacities.xlsx","Installation");');
    if multiple_hubs == 0
        installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Capacity");');
        installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Storage_capacity");');
        installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Installation_storage");');
        if isempty(technologies.conversion_techs_names) == 0
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Installation,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(length(energy_outputs) + 1),'","A2:A',num2str(length(energy_outputs) + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Installation",0,1,1);');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Capacity,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(length(energy_outputs) + 1),'","A2:A',num2str(length(energy_outputs) + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Capacity",0,1,1);');
        end
        if isempty(technologies.storage_techs_names) == 0
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Storage_capacity,"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Storage_capacity",0,1,3);');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Installation_storage,"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Installation_storage",0,1,3);');
        end    
    else
        for h = 1:number_of_hubs
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Installation_hub',num2str(h),'");');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Capacity_hub',num2str(h),'");');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Storage_capacity_hub',num2str(h),'");');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_capacities.xlsx","Installation_storage_hub',num2str(h),'");');
            if isempty(technologies.conversion_techs_names) == 0
                installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Installation(x,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(length(energy_outputs) + 1),'","A2:A',num2str(length(energy_outputs) + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Installation_hub',num2str(h),'",0,1,1);');
                installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Capacity(x,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(length(energy_outputs) + 1),'","A2:A',num2str(length(energy_outputs) + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Capacity_hub',num2str(h),'",0,1,1);');
            end
            if isempty(technologies.storage_techs_names) == 0
                if simplified_storage_representation == 1
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Storage_capacity(x,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Storage_capacity_hub',num2str(h),'",0,1,3);');
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Installation_storage(x,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Installation_storage_hub',num2str(h),'",0,1,3);');
                else
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Storage_capacity(x,stor,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Storage_capacity_hub',num2str(h),'",0,1,3);');
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_capacities.xlsx",Installation_storage(x,stor,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Installation_storage_hub',num2str(h),'",0,1,3);');
                end
            end  
        end
    end
    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results_capacities.xlsx",1);');
end

%TODO: ADD CONDITIONAL STATEMENTS IN HERE DEPENDING ON PRESENCE OF CONVERSION, STORAGE TECHS, ETC.
cost_data_for_printing = '';
if print_cost_data == 1
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results_costs.xlsx","Operating_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Maintenance_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Capital_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Total_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Operating_cost_grid");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Total_cost_grid");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Capital_cost_per_storage");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Total_cost_per_storage");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_costs.xlsx","Income_via_exports");');
	if isempty(technologies.conversion_techs_names) == 0
    	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_costs.xlsx",Operating_cost_per_technology,"B1:B7","A1:A7","","Operating_cost_per_technology",0,1,3);');
    	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_costs.xlsx",Maintenance_cost_per_technology,"B1:B',num2str(number_of_conversion_techs + 1),'","A1:A',num2str(number_of_conversion_techs + 1),'","","Maintenance_cost_per_technology",0,1,3);');
    	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_costs.xlsx",Capital_cost_per_technology,"B1:B',num2str(number_of_conversion_techs + 1),'","A1:A',num2str(number_of_conversion_techs + 1),'","","Capital_cost_per_technology",0,1,3);');
    	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_costs.xlsx",Total_cost_per_technology,"B1:B',num2str(number_of_conversion_techs + 1),'","A1:A',num2str(number_of_conversion_techs + 1),'","","Total_cost_per_technology",0,1,3);');
	end
	if grid_connected_system == 1
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignValue("results_costs.xlsx",Operating_cost_grid,"A1:A1","Operating_cost_grid");');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignValue("results_costs.xlsx",Total_cost_grid,"A1:A1","Total_cost_grid");');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignValue("results_costs.xlsx",Income_via_exports,"A1:A1","Income_via_exports");');
	end
    if isempty(technologies.storage_techs_names) == 0
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_costs.xlsx",Capital_cost_per_storage,"B1:B',num2str(number_of_storage_techs + 1),'","A1:A',num2str(number_of_storage_techs + 1),'","","Capital_cost_per_storage",0,1,3);');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_costs.xlsx",Total_cost_per_storage,"B1:B',num2str(number_of_storage_techs + 1),'","A1:A',num2str(number_of_storage_techs + 1),'","","Total_cost_per_storage",0,1,3);');
    end
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results_costs.xlsx",1);');
end

emissions_data_for_printing = '';
if print_emissions_data == 1
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results_emissions.xlsx","Total_carbon_per_technology");');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results_emissions.xlsx","Total_carbon_per_timestep");');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_emissions.xlsx",Total_carbon_per_technology,"B1:B',num2str(number_of_conversion_techs),'","A1:A',num2str(number_of_conversion_techs),'","","Total_carbon_per_technology",0,1,3);');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results_emissions.xlsx",Total_carbon_per_timestep,"B1:B',num2str(number_of_timesteps),'","A1:A',num2str(number_of_timesteps),'","","Total_carbon_per_timestep",0,1,3);');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results_emissions.xlsx",1);');
end

data_outputs_procedure = strcat(data_outputs_procedure,demand_data_for_printing,conversion_data_for_printing,storage_data_for_printing,installation_data_for_printing,cost_data_for_printing,emissions_data_for_printing);


