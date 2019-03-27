%
% =============================================================================
%
% pdb2cmd
% Last Updated : 01/31/2019, by Hyungmin Jun (hyungminjun@outlook.com)
%
% =============================================================================
%
% This is part of mPDB, which converts to the cndo file to
% the PDB file. The originial script was written by Keyao Pan, and modified
% by Hyungmin Jun. Original source is available in:
% https://cando-dna-origami.org/atomic-model-generator/
% Copyright 2018 Hyungmin Jun. All rights reserved.
%
% License - GPL version 3
% This program is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License
% for more details.
% You should have received a copy of the GNU General Public License along with
% this program. If not, see <http://www.gnu.org/licenses/>.
%
% -----------------------------------------------------------------------------
%
function [] = pdb2cmd(pdb_path, bodyFN, strand, sysParam, typeCMD)

work_dir = fileparts(pdb_path);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the UCSF Chimera script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(strcmp(typeCMD, 'molmap'))
    chimeraScr = fullfile(work_dir, strcat(bodyFN, '_mol.py'));
elseif(strcmp(typeCMD, 'ribbon'))
    chimeraScr = fullfile(work_dir, strcat(bodyFN, '_rib.py'));
end

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

%tan 				#d2b48c 	210 180 140
%salmon 			#fa8072 	250 128 114
%orange 			#ff7f00 	255 127 0
%gold 				#ffd700 	255 215 0
%dark green 		#006400 	0  	100 0
%dark cyan 			#008b8b 	0   139 139
%medium purple 		#9370db 	147 112 219
%rosy brown 		#bc8f8f 	188 143 143
%dark slate gray 	#2f4f4f 	47  79  79
%dark magenta 		#8b008b 	139 0   139
%sea green 			#2e8b57 	46  139 87
%olive drab 		#6b8e23 	107 142 35
%goldenrod 			#daa520 	218 165 32
%firebrick 			#b22222 	178 34  34
%sienna 			#a0522d 	160 82  45
%dark slate blue 	#483d8b 	72  61  139

% http://ksrowell.com/blog-visualizing-data/2012/02/02/optimal-colors-for-graphs/
strandColorList  = [114 147 203; 225 151  76; 132 186  91; 211  94  96; 128 133 133;...
                    144 103 167; 171 104  87; 204 194  16; 218 124  48;  62 150  81; ...
                    204  37  41;  83  81  84; 107  76 154; 146  36  40; 148 139  61; 57 106 177];
strandColorList1 = ['#7293cb'; '#e1974c'; '#84ba5b'; '#d35e60'; '#808585';...
                    '#9067a7'; '#ab6857'; '#ccc210'; '#da7c30'; '#3e9651';...
                    '#cc2529'; '#535154'; '#6b4c9a'; '#922428'; '#948b3d'; '#396ab1'];

nColor      = size(strandColorList,1);
nStrand     = numel(strand);
strandColor = zeros(nStrand,3);
for i = 1: nStrand
    strandColor(i, :)  = strandColorList(mod(i-1,nColor)+1, :);
    strandColor1(i, :) = strandColorList1(mod(i-1,nColor)+1, :);
end

for i = 1: numel(strand)
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
            %RGB  = [0, 102, 204]/255;
            %RGB1 = '#0066cc';
            RGB  = [114 147 203]/255;
            RGB1 = '#7293cb';
        elseif(strcmp(sysParam.color, 'multiple') && strand(i).types == 1)
            % Staples
            RGB  = strandColor(i-1,:)/255;
            RGB1 = strandColor1(i-1,:);
        elseif(strcmp(sysParam.color, 'two') && strand(i).types == 0)
            % Scaffold
            RGB  = [0, 114, 178]/255;
            RGB1 = '#0072B2';
        elseif(strcmp(sysParam.color, 'two') && strand(i).types == 1)
            % Staples
            RGB  = [213, 94, 0]/255;
            RGB1 = '#D55E00';
            %RGB  = [230, 159, 0]/255;
            %RGB1 = '#E69F00';
        end
    end
    if(strcmp(typeCMD, 'molmap'))
        fprintf(fid, 'runCommand(''molmap #0.%d %d'')\n', i, sysParam.mol_res);
        fprintf(fid, 'runCommand(''volume #0.%d color %f,%f,%f step %d transparency %f'')\n',...
            i, RGB(1), RGB(2), RGB(3), sysParam.vol_step, sysParam.trans);
    elseif(strcmp(typeCMD, 'ribbon'))
        fprintf(fid, 'runCommand(''ribbon #0.%d'')\n', i);
        fprintf(fid, 'runCommand(''ribcolor %s #0.%d'')\n', RGB1, i);
        fprintf(fid, 'runCommand(''transparency %f,r #0.%d'')\n', sysParam.trans*100, i);
    end
end

if(strcmp(typeCMD, 'molmap'))
    fprintf(fid, 'runCommand(''~set shadows'')\n');
    fprintf(fid, 'runCommand(''set silhouette'')\n');
    fprintf(fid, 'runCommand(''set silhouetteWidth 1.5'')\n');
    fprintf(fid, 'runCommand(''set subdivision 10.0'')\n');
    fprintf(fid, 'runCommand(''set bgTransparency'')\n');
elseif(strcmp(typeCMD, 'ribbon'))
    fprintf(fid, 'runCommand(''~set shadows'')\n');
    fprintf(fid, 'runCommand(''set silhouette'')\n');
    fprintf(fid, 'runCommand(''set silhouetteWidth 0.75'')\n');
    fprintf(fid, 'runCommand(''set subdivision 10.0'')\n');
    fprintf(fid, 'runCommand(''set bgTransparency'')\n');
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
if(strcmp(typeCMD, 'molmap'))
    cmd_path = fullfile(work_dir, strcat(bodyFN, '_mol.cmd'));
elseif(strcmp(typeCMD, 'ribbon'))
    cmd_path = fullfile(work_dir, strcat(bodyFN, '_rib.cmd'));
end
fid = fopen(cmd_path, 'w');
fprintf(fid,'@echo off\n');

if(strcmp(typeCMD, 'molmap'))
    fprintf(fid, '%s --silent --script %s\n', strrep(sysParam.chi_cmd,'\','/'), strcat(bodyFN, '_mol.py'));
elseif(strcmp(typeCMD, 'ribbon'))
    fprintf(fid, '%s --silent --script %s\n', strrep(sysParam.chi_cmd,'\','/'), strcat(bodyFN, '_rib.py'));
end
fclose(fid);

end
