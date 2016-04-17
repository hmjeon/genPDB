% --------------------------------------------------
% AMG : Atomic Model Generation
% --------------------------------------------------
clear all;
close all;
addpath Source

%% Assign colors for the DNA strands.
param.StrandColor_red  = [190 190 190; 204 121 167];    % Red color staple
param.StrandColor_blue = [190 190 190;  86 180 233];    % Blue color staple

%% Set parameters for rendering resolution and Chimera environments
param.molmapResolution = 3;
param.WindowSize       = [600 600];
param.chimeraEXE       = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chimeraOPTION    = '--silent --script';
param.fileType         = 'all';      % cmd / tif / all

%% Step 5. Set problem name with array
name_prob = { '01_tetrahedron_1_32_2_0' }

%% Step 6. Generate the atomic model
for i = 1 : numel(name_prob)
    tic;
    disp(strcat('Problem name : ', name_prob{i}))
    path_input{i}  = fullfile('Input\', strcat(name_prob{i}, '.cndo'));
    path_output{i} = strcat('Output\', name_prob{i});
    main_cndo2pdb(path_input{i}, path_output{i}, param);
    toc;
end