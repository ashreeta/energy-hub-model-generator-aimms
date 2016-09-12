%% LOAD THE RELVANT TECHNOLOGY AND CASE DATA

LoadCaseData
LoadTechnologyData

%% SELECT THE SETS, PARAMS, VARIABLES AND CONSTRAINTS TO APPLY

SelectSetsParamsAndVariables
SelectConstraints

%% GENERATE THE AMS FILE COMPONENTS

GenerateSets
GenerateParams
GenerateVariables
GenerateObjectiveFunctions
GenerateConstraints
GenerateMathematicalProgram
GenerateMainExecution

%% COMPILE THE COMPLETE STRING FOR AMS FILE

%define some headers and footers for the main sections of the model
header_model = 'Model Energy_Hub_Model {';
footer_model = '\n}';

%compile the complete string
ams_string = strcat(header_model,...
    sets_section,...
    load_params_section,...
    cost_params_section,...
    technical_params_section,...
    other_params_section,...
    variables_section,...
    objective_functions_section,...
    conversion_constraints_section,...
    storage_constraints_section,...
    carbon_constraints_section,...
    mathematical_program_section,...
    problem_solution_section,...
    main_termination_section,...
    footer_model);


%% GENERATE THE AMS FILE

%initialize new AMS file based on the template
template_AMS = 'module_EHM_generation\energy_hub_template.ams';
new_AMS_path = '';
new_AMS_name = 'aimms_model\energy_hub\MainProject\energy_hub.ams';
new_AMS = [new_AMS_path new_AMS_name];
copyfile(template_AMS,new_AMS);

%write to the file
fileID = fopen(new_AMS,'a');
fprintf(fileID,ams_string);
fclose(fileID);