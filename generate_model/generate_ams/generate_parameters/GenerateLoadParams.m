%% GENERATE LOAD PARAMS FOR AMS FILE

param_loads = '';
if create_param_loads == 1
    param_loads = strcat('\n\t\tParameter Loads {\n\t\t\tIndexDomain: (t,x);\n\t\t}');
end

%compile load parameters to string
params_section = strcat(params_section,param_loads);