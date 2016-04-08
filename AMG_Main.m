% --------------------------------------------------
% AMG : Atomic Model Generation
% --------------------------------------------------
clear all;
close all;
addpath Source

%% Assign colors for the DNA strands.
% If a strand contains less than 120 nucleotides,
% then a color with the RGB value (190, 190, 190) is assigned to this strand.
% Otherwise a color with the RGB value (204, 121, 167) is assigned.
param.StrandColor_red  = [190 190 190; 204 121 167];    % Red color staple
param.StrandColor_blue = [190 190 190;  86 180 233];    % Blue color staple
param.L_thres          = 120;

%% Set parameters for rendering resolution and Chimera environments
fid = fopen('Path_Chimera.txt');
str = strtrim(fgetl(fid));
fclose(fid);

param.molmapResolution = 3;
param.WindowSize       = [600 600];
param.chimeraEXE       = str;
param.chimeraOPTION    = '--silent --script';

%% Step 5. Set working environments and read input list
fid = fopen('Input_List.txt');
str = strtrim(fgetl(fid));
cn  = 0;
while(~isempty(str));
    cn = cn + 1;
    name_prob{cn} = str;   
    str = fgetl(fid);
    if(~ischar(str))
        break;
    end
    str = strtrim(str);
end
fclose(fid);
path_input = strcat('Input\', name_prob);
path_input = strcat(path_input, '\');

%% Step 6. Generate the atomic model
for i = 1 : numel(name_prob)
    disp(name_prob{i})
    path_input{i} = fullfile(path_input{i}, strcat(name_prob{i}, '.cndo'));
    path_output{i} = strcat('Output\', name_prob{i});
    main_cndo2pdb(path_input{i}, path_output{i}, param);
end