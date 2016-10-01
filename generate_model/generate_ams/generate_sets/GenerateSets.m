%% GENERATE SETS FOR AMS FILE

header_sets = '\n\tDeclarationSection Sets {';

%generate time set
time_set = '';
if create_time_set == 1
    time_set = strcat('\n\t\tSet Time {\n\t\t\tSubsetOf: Integers;\n\t\t\tIndex: t, s;\n\t\t\tInitialData: data{1 .. ',num2str(number_of_timesteps),'};\n\t\t}');
end

%generate conversion technologies set
conversion_techs_set = '';
if create_conversion_techs_set == 1
    energy_conversion_technologies_string=sprintf('%s,',energy_conversion_technologies{:});
    energy_conversion_technologies_string(end)=[];
    conversion_techs_set = strcat('\n\t\tSet Energy_conversion_technologies {\n\t\t\tIndex: conv;\n\t\t\tDefinition: data {',energy_conversion_technologies_string,'};\n\t\t}');
end

%generate storage technologies set
storage_techs_set = '';
if create_storage_techs_set == 1
    energy_storage_technologies_string=sprintf('%s,',energy_storage_technologies{:});
    energy_storage_technologies_string(end)=[];
    storage_techs_set = strcat('\n\t\tSet Energy_storage_technologies {\n\t\t\tIndex: stor;\n\t\t\tDefinition: data {',energy_storage_technologies_string,'};\n\t\t}');
end

%generate energy carriers set
energy_carriers_set = '';
if create_energy_carriers_set == 1
    energy_carriers_string=sprintf('%s,',energy_outputs{:});
    energy_carriers_string(end)=[];
    energy_carriers_set = strcat('\n\t\tSet Energy_carriers {\n\t\t\tIndex: x;\n\t\t\tDefinition: data {',energy_carriers_string,'};\n\t\t}');
end

footer_sets = '\n\t}';

%compile sets section elements to string
sets_section = strcat(header_sets,time_set,conversion_techs_set,storage_techs_set,energy_carriers_set,footer_sets);