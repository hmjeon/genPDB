function [] = pdb2cmd(pdb_path, bodyFN, strand, sysParam)

L_thres = sysParam.L_thres;  % staple: L < L_thres

work_dir = fileparts(pdb_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the UCSF Chimera script & new rendering with red
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chimeraScr = fullfile(work_dir, strcat(bodyFN, '_simple_red.py'));
fid = fopen(chimeraScr, 'w');
% Import the Python interface
fprintf(fid,'from chimera import runCommand\n');

% Open the PDB file
fprintf(fid, 'runCommand(''open %s'')\n', strcat(bodyFN, '.pdb'));

% Set the environment
fprintf(fid, 'runCommand(''windowsize %d %d'')\n', sysParam.WindowSize(1), sysParam.WindowSize(2));
fprintf(fid, 'runCommand(''preset apply publication 3'')\n');
fprintf(fid, 'runCommand(''window'')\n');
fprintf(fid, 'runCommand(''scale 0.8'')\n');

% Turn off the original rendering
fprintf(fid, 'runCommand(''~ribbon'')\n');
fprintf(fid, 'runCommand(''~display'')\n');

% Use the new rendering
RGB_scaf = sysParam.StrandColor_red(1,:)/255;
RGB_stap = sysParam.StrandColor_red(2,:)/255;
for i = 1:numel(strand)
    if(numel(strand(i).tour) >= L_thres)
        RGB = RGB_scaf;
    else
        RGB = RGB_stap;
    end
    fprintf(fid, 'runCommand(''molmap #0.%d %d'')\n', i, sysParam.molmapResolution);
    fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step 1'')\n', i, RGB(1), RGB(2), RGB(3));
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the UCSF Chimera script & new rendering with red
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chimeraScr = fullfile(work_dir, strcat(bodyFN, '_simple_blue.py'));
fid = fopen(chimeraScr, 'w');
% Import the Python interface
fprintf(fid,'from chimera import runCommand\n');

% Open the PDB file
fprintf(fid, 'runCommand(''open %s'')\n', strcat(bodyFN, '.pdb'));

% Set the environment
fprintf(fid, 'runCommand(''windowsize %d %d'')\n', sysParam.WindowSize(1), sysParam.WindowSize(2));
fprintf(fid, 'runCommand(''preset apply publication 3'')\n');
fprintf(fid, 'runCommand(''window'')\n');
fprintf(fid, 'runCommand(''scale 0.8'')\n');

% Turn off the original rendering
fprintf(fid, 'runCommand(''~ribbon'')\n');
fprintf(fid, 'runCommand(''~display'')\n');

% Use the new rendering
RGB_scaf = sysParam.StrandColor_blue(1,:)/255;
RGB_stap = sysParam.StrandColor_blue(2,:)/255;
for i = 1:numel(strand)
    if(numel(strand(i).tour) >= L_thres)
        RGB = RGB_scaf;
    else
        RGB = RGB_stap;
    end
    fprintf(fid, 'runCommand(''molmap #0.%d %d'')\n', i, sysParam.molmapResolution);
    fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step 1'')\n', i, RGB(1), RGB(2), RGB(3));
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the UCSF Chimera script & multi color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chimeraScr = fullfile(work_dir, strcat(bodyFN, '_multi.py'));
fid = fopen(chimeraScr, 'w');
% Import the Python interface
fprintf(fid,'from chimera import runCommand\n');

% Open the PDB file
fprintf(fid, 'runCommand(''open %s'')\n', strcat(bodyFN, '.pdb'));

% Set the environment
fprintf(fid, 'runCommand(''windowsize %d %d'')\n', sysParam.WindowSize(1), sysParam.WindowSize(2));
fprintf(fid, 'runCommand(''preset apply publication 3'')\n');
fprintf(fid, 'runCommand(''window'')\n');
fprintf(fid, 'runCommand(''scale 0.8'')\n');

% Turn off the original rendering
fprintf(fid, 'runCommand(''~ribbon'')\n');
fprintf(fid, 'runCommand(''~display'')\n');

% multi color
strandColorList = [0 102 204; 184 5 108; 247 67 8; 3 182 162; 247 147 30; 204 0 0; 87 187 0; 0 114 0; 115 0 222];
nColor = size(strandColorList,1);
nStrand = numel(strand);
strandColor = zeros(nStrand,3);
for i = 1:nStrand
    strandColor(i,:) = strandColorList(mod(i-1,nColor)+1,:);
end
for i = 1:size(strandColor,1)
    RGB = strandColor(i,:)/255;
    fprintf(fid, 'runCommand(''molmap #0.%d 3'')\n', i);
    fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step 1'')\n', i, RGB(1), RGB(2), RGB(3));
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the cmd file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmd_path = fullfile(work_dir, strcat(bodyFN, '_simple_red.cmd'));
fid = fopen(cmd_path, 'w');
fprintf(fid,'@echo off\n');
fprintf(fid, '%s --script %s\n', strrep(sysParam.chimeraEXE,'\','/'), strcat(bodyFN, '_simple_red.py'));
fclose(fid);

cmd_path = fullfile(work_dir, strcat(bodyFN, '_simple_blue.cmd'));
fid = fopen(cmd_path, 'w');
fprintf(fid,'@echo off\n');
fprintf(fid, '%s --script %s\n', strrep(sysParam.chimeraEXE,'\','/'), strcat(bodyFN, '_simple_blue.py'));
fclose(fid);

cmd_path = fullfile(work_dir, strcat(bodyFN, '_multi.cmd'));
fid = fopen(cmd_path, 'w');
fprintf(fid,'@echo off\n');
fprintf(fid, '%s --script %s\n', strrep(sysParam.chimeraEXE,'\','/'), strcat(bodyFN, '_multi.py'));
fclose(fid);

end
