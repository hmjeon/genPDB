function genPDB(inDIR, outDIR, inName, inOut)
%
% =============================================================================
%
% genPDB v1.0
% Last Updated : 01/16/2019, by Hyungmin Jun (hyungminjun@outlook.com)
%
%=============================================================================
%
% genPDB is an open-source software, which converts to the cndo file to
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
%-----------------------------------------------------------------------------
%
close all;

%% Set input arguments
switch nargin
    case 0
        % Set path
        if ispc
            addpath ..\src
        else
            addpath ../src
        end

        if ispc
            inputDIR  = 'cndo\';
            outputDIR = 'output\';
        else
            inputDIR  = 'cndo/';
            outputDIR = 'output/';
        end
    case 4
        inputDIR  = inDIR;
        outputDIR = outDIR;
        name_prob = {inName};
        optOut    = inOut;
    otherwise
        return
end

%% Parameter setting
optProj  = 'orthographic';      % [orthographic | perspective]
optColor = 'defined';           % [defined | multiple | two]
optOut   = 'all';               % [cmd | tif | all]
optType  = 'molmap';            % [molmap | ribbon]
optView  = 'xy';                % [xy | yz | xyz]
optList  = 0;                   % 0: single 1:list

% Read cndo files
if(optList == 0)
    name_prob = {'ex1'};
else
    name_prob = readProblem;
end

if ispc
    param.chi_exe = '"C:\Program Files\Chimera 1.10.2\bin\chimera.exe"';
else
    param.chi_exe = '"/cm/shared/hl-Chimera/bin/chimera"';
end

%% Set parameters for rendering resolution and Chimera environments
param.chi_opt  = '--silent --script';
param.chi_cmd  = param.chi_exe;
param.size     = [800 800];
param.proj     = optProj;           % [orthographic | perspective]
param.color    = optColor;          % [defined | multiple | two]
param.out      = optOut;            % [pdb | cmd | tif | all]
param.type     = optType;           % [molmap | ribbon] - only for tif
param.view     = optView;           % [xy | yz | xyz]
param.scale    = 1.0;               % Scale
param.bulge    = 1;                 % 0 - no bulge, 1 - with bulge
param.cndo     = 2;                 % cndo format version
param.trans    = 0.0;               % Transparency (0.0(original) ~ 1.0)
param.mol_res  = 3;                 % Parameter for molmap
param.vol_step = 1;                 % Parameter for volume step

%% Generate the atomic model, PDB
for i = 1 : numel(name_prob)
    tic;
    disp(strcat('     # Problem name    :  ', name_prob{i}));

    % Input folder
    if(optList == 0)
        path_input{i} = fullfile(inputDIR, strcat(name_prob{i}, '.cndo'));
    else
        path_input{i} = strcat(inputDIR, name_prob{i});
        path_input{i} = fullfile(path_input{i}, strcat(name_prob{i}, '_CanDo.cndo'));
    end

    % Output folder
    switch nargin
        case 0
            path_output{i} = strcat(outputDIR, name_prob{i});
        case 4
            path_output{i} = outputDIR;
    end

    % Generate PDB
    main_cndo2pdb(path_input{i}, path_output{i}, param);
    toc
end

end