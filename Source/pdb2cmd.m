function [] = pdb2cmd(pdb_path, bodyFN, strand, sysParam)

work_dir = fileparts(pdb_path);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the UCSF Chimera script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chimeraScr = fullfile(work_dir, strcat(bodyFN, '.py'));
fid = fopen(chimeraScr, 'w');
% Import the Python interface
fprintf(fid,'from chimera import runCommand\n');

% Open the PDB file
fprintf(fid, 'runCommand(''open %s'')\n', strcat(bodyFN, '.pdb'));

% Set the environment
fprintf(fid, 'runCommand(''windowsize %d %d'')\n', sysParam.size(1), sysParam.size(2));
fprintf(fid, 'runCommand(''preset apply publication 3'')\n');
fprintf(fid, 'runCommand(''window'')\n');
fprintf(fid, 'runCommand(''scale 0.9'')\n');

% Turn off the original rendering
fprintf(fid, 'runCommand(''~ribbon'')\n');
fprintf(fid, 'runCommand(''~display'')\n');
fprintf(fid, 'runCommand(''set projection %s'')\n', sysParam.proj);

% Use the new rendering
RGB_scaf = sysParam.StrandColor(1,:)/255;
RGB_stap = sysParam.StrandColor(2,:)/255;

strandColorList = [184 5 108; 247 67 8; 3 182 162; 247 147 30; 204 0 0; 87 187 0; 0 114 0; 115 0 222];
strandColorList1 = ['#b8056c'; '#f74308'; '#03b6a2'; '#f7931e'; '#cc0000'; '#57bb00'; '#007200'; '#7300de'];

nColor = size(strandColorList,1);
nStrand = numel(strand);
strandColor = zeros(nStrand,3);
for i = 1:nStrand
    strandColor(i,:) = strandColorList(mod(i-1,nColor)+1,:);
    strandColor1(i,:)= strandColorList1(mod(i-1,nColor)+1,:);
end

for i = 1:numel(strand)
    if(sysParam.cndo == 1)
        if(numel(strand(i).tour) >= 200)
            RGB = RGB_scaf;
        else
            RGB = RGB_stap;
        end
    elseif(sysParam.cndo == 2)
        if(strcmp(sysParam.color, 'defined') && strand(i).types == 0)
            % Scaffold
            RGB  = RGB_scaf;
            RGB1 = '#0066cc';
        elseif(strcmp(sysParam.color, 'defined') && strand(i).types == 1)
            % Staples
            RGB  = RGB_stap;
            RGB1 = '#f7931e';
        elseif(strcmp(sysParam.color, 'multiple') && strand(i).types == 0)
            % Scaffold
            RGB  = [0, 102, 204]/255;
            RGB1 = '#0066cc';
        elseif(strcmp(sysParam.color, 'multiple') && strand(i).types == 1)
            % Staples
            RGB  = strandColor(i,:)/255;
            RGB1 = strandColor1(i,:);
        end
    end
    if(sysParam.type == 'molmap')
        fprintf(fid, 'runCommand(''molmap #0.%d %d'')\n', i, sysParam.mol_res);
        fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step %d transparency %f'')\n',...
            i, RGB(1), RGB(2), RGB(3), sysParam.vol_step, sysParam.trans);
    else
        fprintf(fid, 'runCommand(''ribbon #0.%d'')\n', i);
        fprintf(fid, 'runCommand(''ribcolor %s #0.%d'')\n', RGB1, i);
        fprintf(fid, 'runCommand(''transparency %f,r #0.%d'')\n', sysParam.trans*100, i);
    end
end

if(strcmp(sysParam.view, 'xy'))
elseif(strcmp(sysParam.view, 'xz'))
    fprintf(fid, 'runCommand(''turn x -90'')\n');
elseif(strcmp(sysParam.view, 'yz'))
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -90'')\n');
elseif(strcmp(sysParam.view, 'xyz1'))
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -45'')\n');
    fprintf(fid, 'runCommand(''turn z 35'')\n');
elseif(strcmp(sysParam.view, 'xyz2'))
    fprintf(fid, 'runCommand(''turn x 60'')\n');
elseif(strcmp(sysParam.view, 'xyz'))
    fprintf(fid, 'runCommand(''turn x -90'')\n');
    fprintf(fid, 'runCommand(''turn y -120'')\n');
    fprintf(fid, 'runCommand(''turn x 35'')\n');
end
fprintf(fid, 'runCommand(''scale %f'')\n', sysParam.scale);
fprintf(fid, 'runCommand(''center'')\n');
fclose(fid);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the cmd file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmd_path = fullfile(work_dir, strcat(bodyFN, '.cmd'));
fid = fopen(cmd_path, 'w');
fprintf(fid,'@echo off\n');
fprintf(fid, '%s --silent --script %s\n', strrep(sysParam.chi_win,'\','/'), strcat(bodyFN, '.py'));
fclose(fid);

end
