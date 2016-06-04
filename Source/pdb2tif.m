function [] = pdb2tif(pdb_path, bodyFN, strand, sysParam)

work_dir = fileparts(pdb_path);

if(strcmp(sysParam.view, 'XY'))
    tif_path = fullfile(work_dir, strcat(bodyFN, '_XY.tif'));
elseif(strcmp(sysParam.view, 'XZ'))
    tif_path = fullfile(work_dir, strcat(bodyFN, '_XZ.tif'));
elseif(strcmp(sysParam.view, 'YZ'))
    tif_path = fullfile(work_dir, strcat(bodyFN, '_YZ.tif'));
elseif(strcmp(sysParam.view, 'XYZ'))
    tif_path = fullfile(work_dir, strcat(bodyFN, '_XYZ.tif'));
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
fprintf(fid, 'runCommand(''scale 0.8'')\n');

% Turn off the original rendering
fprintf(fid, 'runCommand(''~ribbon'')\n');
fprintf(fid, 'runCommand(''~display'')\n');

% Use the new rendering
RGB_scaf = sysParam.StrandColor(1,:)/255;
RGB_stap = sysParam.StrandColor(2,:)/255;
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
if(strcmp(sysParam.view, 'XY'))
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''scale 0.8'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_path,'\','/'));
    fprintf(fid, 'runCommand(''wait'')\n');
elseif(strcmp(sysParam.view, 'XZ'))
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''scale 0.8'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_path,'\','/'));
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(strcmp(sysParam.view, 'YZ'))
    fprintf(fid, 'runCommand(''window'')\n');
    fprintf(fid, 'runCommand(''scale 0.8'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -90'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_path,'\','/'));
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''turn y 90'')\n');
    fprintf(fid, 'runCommand(''turn x 90'')\n');
elseif(strcmp(sysParam.view, 'XYZ'))
    fprintf(fid, 'runCommand(''window'')\n')
    fprintf(fid, 'runCommand(''scale 0.8'')\n');
    fprintf(fid, 'runCommand(''wait'')\n');
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -120'')\n');
    fprintf(fid, 'runCommand(''turn x 35'')\n');
    fprintf(fid, 'runCommand(''copy file %s tiff dpi 300 supersample 3'')\n', strrep(tif_path,'\','/'));
    fprintf(fid, 'runCommand(''wait'')\n');
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
