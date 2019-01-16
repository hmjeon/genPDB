%
% =============================================================================
%
% genPDB v1.0
% Last Updated : 01/16/2019, by Hyungmin Jun (hyungminjun@outlook.com)
%
%=============================================================================
%
% genPDB is an open-source software, which converts to the cndo file to
% the PDB file. The originial script was written by Keyao Pan,
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
%-----------------------------------------------------------------------------
%
clear   all;
close   all;
if ispc
    addpath ..\src
else
    addpath ../src
end
%% Set parameters for rendering resolution and Chimera environments
if ispc
    param.chi_exe = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
else
    param.chi_exe = '"/cm/shared/hl-Chimera/bin/chimera"';
end
param.chi_cmd = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
param.chi_opt = '--silent --script';

param.size     = [800 800];
param.proj     = 'orthographic';    % [orthographic | perspective]
param.color    = 'defined';         % [defined | multiple | two]
param.out      = 'all';             % cmd / tif / all
param.type     = 'molmap';          % molmap or ribbon
param.view     = 'xy';              % Viewpoints, xy, yz, xyz
param.scale    = 1.0;               % Scale
param.bulge    = 1;                 % 0 - no bulge, 1 - with bulge
param.cndo     = 2;                 % cndo format version
param.trans    = 0.0;               % Transparency (0.0(original) ~ 1.0)
param.mol_res  = 3;                 % Parameter for molmap
param.vol_step = 1;                 % Parameter for volume step
param.list     = 0;                 % 0: single 1:list

%% Read cndo files
if(param.list == 0)
    name_prob = {'example'};
else
    name_prob = readProblem;
end

%% Generate the atomic model, PDB
for i = 1 : numel(name_prob)
    tic;
    disp(strcat('     # Problem name    :  ', name_prob{i}));

    % Input folder
    if(param.list == 0)
        if ispc
            path_input{i}  = fullfile('cndo\', strcat(name_prob{i}, '.cndo'));
        else
            path_input{i}  = fullfile('cndo/', strcat(name_prob{i}, '.cndo'));
        end
    else
        if ispc
            path_input{i}  = strcat('cndo\', name_prob{i});
        else
            path_input{i}  = strcat('cndo/', name_prob{i});
        end
        path_input{i}  = fullfile(path_input{i}, strcat(name_prob{i}, '_16.cndo'));
    end

    % Output folder
    if ispc
        path_output{i} = strcat('outputs\', name_prob{i});
    else
        path_output{i} = strcat('outputs/', name_prob{i});
    end

    main_cndo2pdb(path_input{i}, path_output{i}, param);
    toc
end