% --------------------------------------------------
% AMG : Atomic Model Generation
% --------------------------------------------------
clear   all;
close   all;
addpath Source

%% Set parameters for rendering resolution and Chimera environments
param.chi_exe = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chi_win = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chi_opt = '--silent --script';

param.size     = [800 800];
param.proj     = 'orthographic';    % [orthographic | perspective]
param.color    = 'defined';         % [defined | multiple]
param.out      = 'all';             % cmd / tif / all
param.type     = 'molmap'           % molmap or ribbon
param.view     = 'xy';              % Viewpoints, xy, yz, xyz
param.scale    = 1.0;               % Scale
param.bulge    = 1;                 % 0 - no bulge, 1 - with bulge
param.cndo     = 2;                 % cndo format version
param.trans    = 0.0;               % Transparency (0.0(original) ~ 1.0)
param.mol_res  = 3;                 % Parameter for molmap
param.vol_step = 1;                 % Parameter for volume step

%% Step 5. Set problem name with array
name_prob = {...
'16_4_Sided_Polygon_1cs_84bp_max_16_cndo',...
}

%% Step 6. Generate the atomic model
for i = 1 : numel(name_prob)
    tic;
    disp(strcat('     # Problem name : ', name_prob{i}))
    path_input{i}  = fullfile('Input\', strcat(name_prob{i}, '.cndo'));
    path_output{i} = strcat('Output\', name_prob{i});
    main_cndo2pdb(path_input{i}, path_output{i}, param);
    toc;
end