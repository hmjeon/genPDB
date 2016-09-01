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
param.scale            = 1.0;

%% Step 5. Set problem name with array
name_prob = { '01_Tetrahedron_16cs_31bp_flat_mod_max_4' }

%% Step 6. Generate the atomic model
for i = 1 : numel(name_prob)
    tic;
    disp(strcat('Problem name : ', name_prob{i}))
    path_input{i}  = fullfile('Input\', strcat(name_prob{i}, '.cndo'));
    path_output{i} = strcat('Output\', name_prob{i});
    main_cndo2pdb(path_input{i}, path_output{i}, param);
    toc;
end