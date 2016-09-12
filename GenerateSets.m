%% GENERATE SETS FOR AMS FILE

header_sets = '\n\tDeclarationSection sets {';

%generate time set
time_set = '';
if create_time_set == 1
    time_set = strcat('\n\t\tSet Time {\n\t\t\tSubsetOf: Integers;\n\t\t\tIndex: t, s;\n\t\t\tInitialData: data{1 .. ',num2str(number_of_timesteps),'};\n\t\t}');
end

%generate inputs set
inputs_set = '';
if create_inputs_set == 1
    energy_conversion_technologies_string=sprintf('%s,',energy_conversion_technologies{:});
    energy_conversion_technologies_string(end)=[];
    inputs_set = strcat('\n\t\tSet Energy_conversion_technologies {\n\t\t\tIndex: conv;\n\t\t\tDefinition: data {',energy_conversion_technologies_string,'};\n\t\t}');
end

%generate storage set
storage_set = '';
if create_storage_set == 1
    energy_storage_technologies_string=sprintf('%s,',energy_storage_technologies{:});
    energy_storage_technologies_string(end)=[];
    storage_set = strcat('\n\t\tSet Energy_storage_technologies {\n\t\t\tIndex: stor;\n\t\t\tDefinition: data {',energy_storage_technologies_string,'};\n\t\t}');
end

%generate outputs set
outputs_set = '';
if create_outputs_set == 1
    energy_outputs_string=sprintf('%s,',energy_outputs{:});
    energy_outputs_string(end)=[];
    outputs_set = strcat('\n\t\tSet Energy_carriers {\n\t\t\tIndex: x;\n\t\t\tDefinition: data {',energy_outputs_string,'};\n\t\t}');
end

footer_sets = '\n\t}';

%compile sets section elements to string
sets_section = strcat(header_sets,time_set,inputs_set,storage_set,outputs_set,footer_sets);