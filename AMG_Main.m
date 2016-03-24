clear all;
close all;

% Step 1. Add MATLAB paths.
addpath Source

% Step 2. Assign colors for the DNA strands. In this example, if a strand contains less than 100 nucleotides, then a color with the RGB value (190, 190, 190) is assigned to this strand. Otherwise a color with the RGB value (204, 121, 167) is assigned.
param.StrandColor = [190 190 190; 86 180, 233];
param.L_thres = 100;

% Step 3. Assign the rendering resolution (typically between 3 and 6) and figure size (typically 640-by-480).
param.molmapResolution = 3;
param.WindowSize = [640 480];

% Step 4. Assign the path to UCSF Chimera.
param.chimeraEXE = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chimeraOPTION = '--silent --script';

% Step 5. Set working environments
Input_path = 'Input\';
Name_prob  = {  ...
    'icosahedron_cando', ...
    'icosahedron', ...
}

% Step 5. Generate the atomic model
for i = 1 : numel(Name_prob)
    design_path = fullfile(Input_path, strcat(Name_prob{i}, '.cndo'));
    work_path = strcat('Output\', Name_prob{i});
    main_cndo2pdb(design_path, work_path, param);
end