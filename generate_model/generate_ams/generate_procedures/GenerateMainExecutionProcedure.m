%% GENERATE MAIN EXECUTION/TERMINATION PROCEDURE FOR AMS FILE

%empty variables
execution_empty_variables = '\n\t\t\tempty AllVariables;';

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
execution_relaxations = relaxations_string;

%load the input data
execution_load_data = '\n\t\t\tLoadInputData;';

%set the objective
if objective == 1
    execution_solve_problem = '\n\t\t\tsolve Cost_minimization;';
elseif objective == 2
    execution_solve_problem = '\n\t\t\tsolve Carbon_minimization;';
end

%write the output data
execution_write_data = '\n\t\t\tWriteOutputData;';

%compile problem solution to string
main_execution_procedure = strcat(main_execution_procedure,execution_empty_variables,execution_relaxations,execution_load_data,execution_solve_problem,execution_write_data);
