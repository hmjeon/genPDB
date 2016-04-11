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
param.molmapResolution = 3;
param.WindowSize       = [600 600];
param.chimeraEXE       = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chimeraOPTION    = '--silent --script';

%% Step 5. Set working environments and read input list
name_prob  = { 'cube_2_2_2_-1' }

%% Step 6. Generate the atomic model
for i = 1 : numel(name_prob)
    path_input{i} = fullfile('Input\', strcat(name_prob{i}, '.cndo'));
    path_output{i} = strcat('Output\', name_prob{i});
    main_cndo2pdb(path_input{i}, path_output{i}, param);
end