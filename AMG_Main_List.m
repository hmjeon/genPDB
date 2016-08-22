% --------------------------------------------------
% AMG : Atomic Model Generation
% --------------------------------------------------
clear   all;
close   all;
addpath Source

%% Set parameters for rendering resolution and Chimera environments
param.molmapResolution = 3;
param.WindowSize       = [600 600];
param.chimeraEXE       = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chimeraOPTION    = '--silent --script';
param.fileType         = 'all';     % cmd / tif / all
param.bulge            = 1;         % 0 - no bulge, 1 - with bulge

%% Step 5. Read problem name from file
name_prob = ReadProbList;

%% Step 6. Generate the atomic model
for i = 1 : numel(name_prob)
    tic;
    disp(strcat('Problem name : ', name_prob{i}))
    path_input{i}  = strcat('Input\', name_prob{i});
    path_input{i}  = fullfile(path_input{i}, strcat(name_prob{i}, '.cndo'));
    path_output{i} = strcat('Output\', name_prob{i});
    main_cndo2pdb(path_input{i}, path_output{i}, param);
    toc
end