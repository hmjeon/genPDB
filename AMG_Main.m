% --------------------------------------------------
% AMG : Atomic Model Generation
% --------------------------------------------------
clear all;
close all;

%% Step 1. Add MATLAB paths.
addpath Source

% Step 2. Assign colors for the DNA strands.
% If a strand contains less than 120 nucleotides,
% then a color with the RGB value (190, 190, 190) is assigned to this strand.
% Otherwise a color with the RGB value (204, 121, 167) is assigned.
param.StrandColor_red  = [190 190 190; 204 121 167];    % Red color staple
param.StrandColor_blue = [190 190 190;  86 180 233];    % Blue color staple
param.L_thres          = 120;

%% Step 3. Assign the rendering resolution
param.molmapResolution = 3;
param.WindowSize = [600 600];

%% Step 4. Assign the path to UCSF Chimera.
param.chimeraEXE = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chimeraOPTION = '--silent --script';

%% Step 5. Set working environments and read input list
fid = fopen('Input_List.txt');
ss  = strtrim(fgetl(fid));
cn  = 0;

while(~isempty(ss));
    cn = cn + 1;
    Name_prob{cn} = ss;
    ss = strtrim(fgetl(fid));
    
    ss = fgetl(fid);
    if(~ischar(ss))
        break;
    end
    ss = strtrim(ss);
end

disp(Name_prob);
fclose(fid);
Input_path = 'cndo\';

%% Step 6. Generate the atomic model
for i = 1 : numel(Name_prob)
    design_path = fullfile(Input_path, strcat(Name_prob{i}, '.cndo'));
    work_path = strcat('Output\', Name_prob{i});
    main_cndo2pdb(design_path, work_path, param);
end