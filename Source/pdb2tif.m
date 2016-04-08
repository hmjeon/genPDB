function [] = pdb2tif(pdb_path, bodyFN, strand, sysParam)

L_thres = sysParam.L_thres;  % staple: L < L_thres

work_dir = fileparts(pdb_path);
tif_1_path = fullfile(work_dir, strcat(bodyFN, '_simple_red.tif'));
tif_2_path = fullfile(work_dir, strcat(bodyFN, '_simple_red_x90.tif'));
tif_3_path = fullfile(work_dir, strcat(bodyFN, '_simple_red_y90.tif'));
tif_4_path = fullfile(work_dir, strcat(bodyFN, '_simple_blue.tif'));
tif_5_path = fullfile(work_dir, strcat(bodyFN, '_simple_blue_x90.tif'));
tif_6_path = fullfile(work_dir, strcat(bodyFN, '_simple_blue_y90.tif'));
tif_7_path = fullfile(work_dir, strcat(bodyFN, '_multi.tif'));
tif_8_path = fullfile(work_dir, strcat(bodyFN, '_multi_x90.tif'));
tif_9_path = fullfile(work_dir, strcat(bodyFN, '_multi_y90.tif'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the UCSF Chimera script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chimeraScr = fullfile(work_dir, strcat(bodyFN, '_chimera.py'));
fid = fopen(chimeraScr, 'w');
% Import the Python interface
fprintf(fid,'from chimera import runCommand\n');

% Open the PDB file
fprintf(fid, 'runCommand(''open %s'')\n', strrep(pdb_path,'\','/'));

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

% Save as .tif files
fprintf(fid, 'runCommand(''window'')\n');
fprintf(fid, 'runCommand(''scale 0.8'')\n');
fprintf(fid, 'runCommand(''wait'')\n');

fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_1_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');

fprintf(fid, 'runCommand(''turn x 90'')\n');
fprintf(fid, 'runCommand(''copy file %s png supersample 3'')\n', strrep(tif_2_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');
fprintf(fid, 'runCommand(''turn x -90'')\n');

fprintf(fid, 'runCommand(''turn y 90'')\n');
fprintf(fid, 'runCommand(''copy file %s png supersample 3'')\n', strrep(tif_3_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');
fprintf(fid, 'runCommand(''turn y -90'')\n');

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

% Save as .tif files
%fprintf(fid, 'runCommand(''window'')\n');
%fprintf(fid, 'runCommand(''scale 0.8'')\n');
fprintf(fid, 'runCommand(''wait'')\n');

fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_4_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');

fprintf(fid, 'runCommand(''turn x 90'')\n');
fprintf(fid, 'runCommand(''copy file %s png supersample 3'')\n', strrep(tif_5_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');
fprintf(fid, 'runCommand(''turn x -90'')\n');

fprintf(fid, 'runCommand(''turn y 90'')\n');
fprintf(fid, 'runCommand(''copy file %s png supersample 3'')\n', strrep(tif_6_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');
fprintf(fid, 'runCommand(''turn y -90'')\n');

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

% Save as .tif files
%fprintf(fid, 'runCommand(''window'')\n');
%fprintf(fid, 'runCommand(''scale 0.8'')\n');
fprintf(fid, 'runCommand(''wait'')\n');

fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_7_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');

fprintf(fid, 'runCommand(''turn x 90'')\n');
fprintf(fid, 'runCommand(''copy file %s png supersample 3'')\n', strrep(tif_8_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');
fprintf(fid, 'runCommand(''turn x -90'')\n');

fprintf(fid, 'runCommand(''turn y 90'')\n');
fprintf(fid, 'runCommand(''copy file %s png supersample 3'')\n', strrep(tif_9_path,'\','/'));
fprintf(fid, 'runCommand(''wait'')\n');
fprintf(fid, 'runCommand(''turn y -90'')\n');

fprintf(fid, 'runCommand(''close all'')\n');
fprintf(fid, 'runCommand(''stop yes'')\n');

fclose(fid);

runChimera = sprintf('%s %s %s',sysParam.chimeraEXE, sysParam.chimeraOPTION, chimeraScr);
system(runChimera);
end
