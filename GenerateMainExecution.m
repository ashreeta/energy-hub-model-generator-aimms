%% GENERATE MAIN EXECUTION/TERMINATION PROCEDURE FOR AMS FILE

header_procedure = '\n\tProcedure MainExecution {';
header_body = '\n\t\tBody: {';

%empty variables
solution_empty_variables = '\n\t\t\tempty AllVariables;';

%relaxations
%TODO: figure out why this is necessary
relaxations_string = '';
non_solar_heat_generating_technologies_excluding_chp = technologies.conversion_techs_names(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(strcmp(technologies.conversion_techs_outputs,'Heat'))));
non_solar_electricity_generating_technologies_excluding_chp = technologies.conversion_techs_names(intersect(find(~strcmp(technologies.conversion_techs_inputs,'Solar')),find(strcmp(technologies.conversion_techs_outputs,'Elec'))));
for t=1:length(non_solar_heat_generating_technologies_excluding_chp)
    relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Heat'',''',char(non_solar_heat_generating_technologies_excluding_chp(t)),''').relax := 1;');
end
for t=1:length(non_solar_electricity_generating_technologies_excluding_chp)
    relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Elec'',''',char(non_solar_electricity_generating_technologies_excluding_chp(t)),''').relax := 1;');
end
for t=1:length(cooling_technologies)
    relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Cool'',''',char(cooling_technologies(t)),''').relax := 1;');
end
solution_relaxations = relaxations_string;

electricity_demand_data_solve_problem = '';
heating_demand_data_solve_problem = '';
cooling_demand_data_solve_problem = '';
if consider_electricity_demand == 1
    electricity_demand_data_solve_problem = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "electricity_demand.xlsx", Loads(t,''Elec''),"A1:A',num2str(number_of_timesteps),'","electricity_demand");');
end
if consider_heating_demand == 1
    heating_demand_data_solve_problem = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "heating_demand.xlsx", Loads(t,''Heat''),"A1:A',num2str(number_of_timesteps),'","heating_demand");');
end
if consider_cooling_demand == 1
    cooling_demand_data_solve_problem = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "cooling_demand.xlsx", Loads(t,''Cool''),"A1:A',num2str(number_of_timesteps),'","cooling_demand");');
end

solar_data_solve_problem = '';
if isempty(solar_technologies) == 0
    solar_data_solve_problem = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "solar_inputs.xlsx", Solar_radiation(t),"A1:A',num2str(number_of_timesteps),'","solar");');
end

electricity_price_data_solve_problem = '';
if length(grid_electricity_price) > 1
    electricity_price_data_solve_problem = 'Spreadsheet::RetrieveParameter( "electricity_costs.xlsx", Operating_costs_grid(t),"A1:A',num2str(number_of_timesteps),'","electricity_costs");';
end

if objective == 1
    solution_solve_problem = '\n\t\t\tsolve Cost_minimization;';
elseif objective == 2
    solution_solve_problem = '\n\t\t\tsolve Carbon_minimization;';
end

%calculate some variables for printing the results
number_of_conversion_techs = length(technologies.conversion_techs_names);
number_of_dispatchable_techs = length(dispatchable_technologies);
number_of_storage_techs = length(technologies.storage_techs_names);
number_of_timesteps = length(timesteps);

%find the excel column assignments
%NOTE: THIS ONLY WORKS IF YOU HAVE 26 OR FEWER TECHNOLOGIES
max_excel_column_conversion_techs = char('A' + number_of_conversion_techs - 1 + 1);
max_excel_column_dispatchable_techs = char('A' + number_of_dispatchable_techs - 1 + 1);
max_excel_column_storage_techs = char('A' + number_of_storage_techs - 1 + 1);

%print the results
print_results = '\n\t\t\tSpreadsheet::CreateWorkbook("energy_hub_results.xlsx","Input_energy");';
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Exported_energy");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Operation");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Storage_input_energy");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Storage_output_energy");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Storage_SOC");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Installation");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Capacity");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Storage_capacity");');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Installation_storage");');

print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Input_energy,"B2:',max_excel_column_conversion_techs,num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',max_excel_column_conversion_techs,'1","Input_energy",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Exported_energy,"B2:C',num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:C1","Exported_energy",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Operation,"B2:F',num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',max_excel_column_dispatchable_techs,'1","Operation",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Storage_input_energy,"B2:C',num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:C1","Storage_input_energy",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Storage_output_energy,"B2:C',num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:C1","Storage_output_energy",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Storage_SOC,"B2:C',num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:C1","Storage_SOC",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Installation,"B2:',max_excel_column_conversion_techs,'3","A2:A3","B1:',max_excel_column_conversion_techs,'1","Installation",0,1,1);');
print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Capacity,"B2:',max_excel_column_conversion_techs,'3","A2:A3","B1:',max_excel_column_conversion_techs,'1","Capacity",0,1,1);');

%conditional results printing
if ismember('Elec',technologies.conversion_techs_outputs) == 1
    print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Output_energy_electricity");');
    print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Output_energy_electricity,"B2:',max_excel_column_conversion_techs,num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',max_excel_column_conversion_techs,'1","Output_energy_electricity",0,1,1);');
end
if ismember('Heat',technologies.conversion_techs_outputs) == 1
    print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Output_energy_heat");');
    print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Output_energy_heat,"B2:',max_excel_column_conversion_techs,num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',max_excel_column_conversion_techs,'1","Output_energy_heat",0,1,1);');
end
if ismember('Cool',technologies.conversion_techs_outputs) == 1
    print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AddNewSheet("energy_hub_results.xlsx","Output_energy_cool");');
    print_results = strcat(print_results,'\n\t\t\tSpreadsheet::AssignTable("energy_hub_results.xlsx",Output_energy_cool,"B2:',max_excel_column_conversion_techs,num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',max_excel_column_conversion_techs,'1","Output_energy_cool",0,1,1);');
end

print_results = strcat(print_results,'\n\t\t\tSpreadsheet::CloseWorkbook("energy_hub_results.xlsx",1);');

%!write Storage_cap to file "Storage_cap.txt" in dense replace mode;
%!write y_stor to file "y_stor.txt" in dense replace mode;

footer_body = '\n\t\t}';
footer_procedure = '\n\t}';

%compile problem solution to string
problem_solution_section = strcat(header_procedure,header_body,solution_empty_variables,solution_relaxations,electricity_demand_data_solve_problem,heating_demand_data_solve_problem,cooling_demand_data_solve_problem,...
    solar_data_solve_problem,electricity_price_data_solve_problem,solution_solve_problem,print_results,footer_body,footer_procedure);

%% GENERATE MAIN TERMINATION PROCEDURE FOR AMS FILE

header_procedure = '\n\tProcedure MainTermination {';
header_body = '\n\t\tBody: {';

main_termination_string = '\n\t\t\treturn 1;';

footer_body = '\n\t\t}';
footer_procedure = '\n\t}';

main_termination_section = strcat(header_procedure,header_body,main_termination_string,footer_body,footer_procedure);