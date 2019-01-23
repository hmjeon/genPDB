%
% =============================================================================
%
% main_cndo2pdb
% Last Updated : 01/14/2019, by Hyungmin Jun (hyungminjun@outlook.com)
%
% =============================================================================
%
% This is part of genPDB, which converts to the cndo file to
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
function [] = main_cndo2pdb(CAD_path, work_DIR, param)

% Convert the orientation from 3DNA
%   x -- major groove
%   y -- preferred nt
%   z -- 3'-direction of the preferred nt
% to off-lattice CanDo
%   x' -- non-preferred nt (-y)
%   y' -- 3'-direction of the preferred nt (z)
%   z' -- minor groove (-x)

rot_mat = [ 0, 0,-1; ...
           -1, 0, 0; ...
            0, 1, 0];

%% Preparation
% Load the structure 'dnaInfo'
% load(CAD_path, 'dnaInfo');
% Read the .cndo file

[dnaInfo, param] = cndo2dnaInfo(CAD_path, param);

% Filename without the extension
[~, bodyFN] = fileparts(CAD_path);

% Create the working directory
if(exist(work_DIR, 'dir')==7)
    mesg = sprintf('The directory %s already exists and will be removed', work_DIR);
    disp(mesg)
    rmdir(work_DIR, 's');
end
mkdir(work_DIR);

% Extract individual fields from 'dnaInfo'
dnaTop = dnaInfo.dnaTop;
dNode  = dnaInfo.dnaGeom.dNode;
triad  = dnaInfo.dnaGeom.triad;
id_nt  = dnaInfo.dnaGeom.id_nt;
clear dnaInfo


%% Render the CAD design
%renderCAD(fullfile(work_DIR, strcat(bodyFN, '.bild')), dNode, triad, zeros(0,2), zeros(0,2));


%% Build strands
[dnaTop, strand] = buildStrand(dnaTop);         % get strand information (with two fields: isCircular & tour), routing the whole design

% Add four fields (isMain, seq, R, d) to the strand structure
for i = 1 : numel(strand)
    L = numel(strand(i).tour);
    strand(i).isMain = false(1, L);
    strand(i).seq = repmat('N', 1, L);
    strand(i).R = cell(1, L);
    strand(i).d = cell(1, L);
end

% Assign values for the four newly added fields
for i = 1 : size(id_nt,1)
    i1 = id_nt(i,1);    % ID of the preferred nt
    i2 = id_nt(i,2);    % ID of the non-preferred nt
    s1 = dnaTop(i1).strand;
    r1 = dnaTop(i1).residue;
    s2 = dnaTop(i2).strand;
    r2 = dnaTop(i2).residue;
    
    assert(isempty(strand(s1).R{r1}) && ...
        isempty(strand(s1).d{r1}) && ...
        isempty(strand(s2).R{r2}) && ...
        isempty(strand(s2).d{r2}));
    
    strand(s1).isMain(r1) = true;
    strand(s1).seq(r1) = dnaTop(i1).seq;
    strand(s1).R{r1} = triad(:,:,i) * rot_mat;
    strand(s1).d{r1} = dNode(i,:)';
    
    strand(s2).isMain(r2) = false;
    strand(s2).seq(r2) = dnaTop(i2).seq;
    strand(s2).R{r2} = triad(:,:,i) * rot_mat;
    strand(s2).d{r2} = dNode(i,:)';
end

% Create bulges
if(param.bulge == 1)
    for i = 1:numel(strand)
        [strand(i).R, strand(i).d, strand(i).isMain] = generateBulgeDOF(strand(i).R, strand(i).d, strand(i).isMain, strand(i).isCircular);
        for j = 1:numel(strand(i).seq)
            if(strcmp(strand(i).seq(j), 'N'))
                tmp = strand(i).tour(j);
                assert(dnaTop(tmp).across == -1);
                strand(i).seq(j) = dnaTop(tmp).seq;
            end
        end
    end
end


%% Create the PDB file
pdb_path = fullfile(work_DIR, strcat(bodyFN,'.pdb'));
pdbFinal = pdbGenerate(strand);
pdbFinal = pdbModify_multimodel(pdbFinal);
mypdbwrite_v2(pdb_path, pdbFinal);

%% Render atomic model
if(strcmp(param.out,'cmd'))
    pdb2cmd(pdb_path, bodyFN, strand, param, 'molmap');
    pdb2cmd(pdb_path, bodyFN, strand, param, 'ribbon');
elseif(strcmp(param.out, 'tif'))
    pdb2tif(pdb_path, bodyFN, strand, param);
elseif(strcmp(param.out, 'all'))
    pdb2cmd(pdb_path, bodyFN, strand, param, 'molmap');
    pdb2cmd(pdb_path, bodyFN, strand, param, 'ribbon');
    pdb2tif(pdb_path, bodyFN, strand, param);
else
    return
end
end
