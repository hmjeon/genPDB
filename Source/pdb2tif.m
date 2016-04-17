function [] = pdb2tif(pdb_path, bodyFN, strand, sysParam)

work_dir = fileparts(pdb_path);

if(sysParam.view == 'XY')
    tif_1_path = fullfile(work_dir, strcat(bodyFN, '_red_XY.tif'));
    tif_2_path = fullfile(work_dir, strcat(bodyFN, '_blue_XY.tif'));
    tif_3_path = fullfile(work_dir, strcat(bodyFN, '_multi_XY.tif'));
elseif(sysParam.view == 'XZ')
    tif_1_path = fullfile(work_dir, strcat(bodyFN, '_red_XZ.tif'));
    tif_2_path = fullfile(work_dir, strcat(bodyFN, '_blue_XZ.tif'));
    tif_3_path = fullfile(work_dir, strcat(bodyFN, '_multi_XZ.tif'));
elseif(sysParam.view == 'YZ')
    tif_1_path = fullfile(work_dir, strcat(bodyFN, '_red_YZ.tif'));
    tif_2_path = fullfile(work_dir, strcat(bodyFN, '_blue_YZ.tif'));
    tif_3_path = fullfile(work_dir, strcat(bodyFN, '_multi_YZ.tif'));
elseif(sysParam.view == 'XYZ')
    tif_1_path = fullfile(work_dir, strcat(bodyFN, '_red_XYZ.tif'));
    tif_2_path = fullfile(work_dir, strcat(bodyFN, '_blue_XYZ.tif'));
    tif_3_path = fullfile(work_dir, strcat(bodyFN, '_multi_XYZ.tif'));
end

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
fprintf(fid, 'runCommand(''scale 1.0'')\n');

% Turn off the original rendering
fprintf(fid, 'runCommand(''~ribbon'')\n');
fprintf(fid, 'runCommand(''~display'')\n');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Red color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RGB_scaf = sysParam.StrandColor_red(1,:)/255;
RGB_stap = sysParam.StrandColor_red(2,:)/255;
for i = 1:numel(strand)
    if(strand(i).types == 0)
        RGB = RGB_scaf;
    else
        RGB = RGB_stap;
    end
    fprintf(fid, 'runCommand(''molmap #0.%d %d'')\n', i, sysParam.molmapResolution);
    fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step 1'')\n', i, RGB(1), RGB(2), RGB(3));
end

% Save as .tif files
if(sysParam.view == 'XY')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_1_path,'\','/'));
elseif(sysParam.view == 'XZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_1_path,'\','/'));
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(sysParam.view == 'YZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -90'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_1_path,'\','/'));
    fprintf(fid, 'runCommand(''turn y 90'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(sysParam.view == 'XYZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -120'')\n');
    fprintf(fid, 'runCommand(''turn x 35'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_1_path,'\','/'));
    fprintf(fid, 'runCommand(''turn x -35'')\n');
    fprintf(fid, 'runCommand(''turn y 120'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Blue color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RGB_scaf = sysParam.StrandColor_blue(1,:)/255;
RGB_stap = sysParam.StrandColor_blue(2,:)/255;
for i = 1:numel(strand)
    if(strand(i).types == 0)
        RGB = RGB_scaf;
    else
        RGB = RGB_stap;
    end
    fprintf(fid, 'runCommand(''molmap #0.%d %d'')\n', i, sysParam.molmapResolution);
    fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step 1'')\n', i, RGB(1), RGB(2), RGB(3));
end

% Save as .tif files
if(sysParam.view == 'XY')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_2_path,'\','/'));
elseif(sysParam.view == 'XZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_2_path,'\','/'));
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(sysParam.view == 'YZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -90'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_2_path,'\','/'));
    fprintf(fid, 'runCommand(''turn y 90'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(sysParam.view == 'XYZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -120'')\n');
    fprintf(fid, 'runCommand(''turn x 35'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_2_path,'\','/'));
    fprintf(fid, 'runCommand(''turn x -35'')\n');
    fprintf(fid, 'runCommand(''turn y 120'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% multi color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strandColorList = [184 5 108; 247 67 8; 3 182 162; 247 147 30; 204 0 0; 87 187 0; 0 114 0; 115 0 222];
nColor = size(strandColorList,1);
nStrand = numel(strand);
strandColor = zeros(nStrand,3);
for i = 1:nStrand
    if(strand(i).types == 0)
        strandColor(i,:) = [0 102 204];
    else
        strandColor(i,:) = strandColorList(mod(i-1,nColor)+1,:);
    end
end
for i = 1:size(strandColor,1)
    RGB = strandColor(i,:)/255;
    fprintf(fid, 'runCommand(''molmap #0.%d 3'')\n', i);
    fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step 1'')\n', i, RGB(1), RGB(2), RGB(3));
end

% Save as .tif files
if(sysParam.view == 'XY')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_3_path,'\','/'));
elseif(sysParam.view == 'XZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_3_path,'\','/'));
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(sysParam.view == 'YZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -90'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_3_path,'\','/'));
    fprintf(fid, 'runCommand(''turn y 90'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(sysParam.view == 'XYZ')
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -120'')\n');
    fprintf(fid, 'runCommand(''turn x 35'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_3_path,'\','/'));
    fprintf(fid, 'runCommand(''turn x -35'')\n');
    fprintf(fid, 'runCommand(''turn y 120'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
end

fprintf(fid, 'runCommand(''close all'')\n');
fprintf(fid, 'runCommand(''stop yes'')\n');

fclose(fid);

runChimera = sprintf('%s %s %s',sysParam.chimeraEXE, sysParam.chimeraOPTION, chimeraScr);
system(runChimera);
end
