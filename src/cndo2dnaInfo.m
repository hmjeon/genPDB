%
% =============================================================================
%
% cndo2dnaInfo
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
function [dnaInfo, param] = cndo2dnaInfo(cndo_FN, param)

tol = 1e-10;

%% Initialization
conn  = zeros(0,5);     % id, up, down, across
seq   = cell (0,1);     % seq
types = zeros(0,1);     % type
dNode = zeros(0,4);
triad = zeros(0,10);
id_nt = zeros(0,3);


%% Read the file
fid = fopen(cndo_FN);

% Ignore 2 lines
for i = 1 : 2
    ss = strtrim(fgetl(fid));
    assert(ischar(ss));
end

param.StrandColor = [190 190 190;  86 180 233];

% Read the field 'dnaTop'
ss = strtrim(fgetl(fid));
assert(strcmp(ss(1:6), 'dnaTop'));
ss = strtrim(fgetl(fid));
while(~isempty(ss));

    a = strsplit(ss, ',');
    assert(numel(a) == 6);
    conn = cat(1, conn, [str2double(a{1}), ...
                         str2double(a{2}), ...
                         str2double(a{3}), ...
                         str2double(a{4}), ...
                         str2double(a{5})]);
    seq = cat(1, seq, a(6));
    ss  = strtrim(fgetl(fid));
end

% Read the field 'dNode'
ss = strtrim(fgetl(fid));
assert(strcmp(ss(1:5), 'dNode'));
ss = strtrim(fgetl(fid));
while(~isempty(ss))
    a = strsplit(ss, ',');
    assert(numel(a) == 4);
    dNode = cat(1, dNode, [str2double(a{1}), ...
                           str2double(a{2}), ...
                           str2double(a{3}), ...
                           str2double(a{4})]);
    ss = strtrim(fgetl(fid));
end

% Read the field 'triad'
ss = strtrim(fgetl(fid));
assert(strcmp(ss(1:5), 'triad'));
ss = strtrim(fgetl(fid));
while(~isempty(ss))
    a = strsplit(ss, ',');
    assert(numel(a) == 10);
    triad = cat(1, triad, [str2double(a{1}), ...
                           str2double(a{2}), ...
                           str2double(a{3}), ...
                           str2double(a{4}), ...
                           str2double(a{5}), ...
                           str2double(a{6}), ...
                           str2double(a{7}), ...
                           str2double(a{8}), ...
                           str2double(a{9}), ...
                           str2double(a{10})]);
    ss = strtrim(fgetl(fid));
end

% Read the field 'id_nt'
ss = strtrim(fgetl(fid));
assert(strcmp(ss(1:5), 'id_nt'));
ss = strtrim(fgetl(fid));
while(~isempty(ss))
    a = strsplit(ss, ',');
    assert(numel(a) == 3);
    id_nt = cat(1, id_nt, [str2double(a{1}), ...
                           str2double(a{2}), ...
                           str2double(a{3})]);
    ss = fgetl(fid);
    if(~ischar(ss))
        break;
    end
    ss = strtrim(ss);
end

if(param.cndo == 2)
    % Read view
    %param.view = strtrim(fgetl(fid));
    %ss = strtrim(fgetl(fid));
    
    % Read scale
    %param.scale = fscanf(fid,'%f/n');
    %ss = strtrim(fgetl(fid));

    % Read RGB
    r = fscanf(fid,'%f/n');
    g = fscanf(fid,'%f/n');
    b = fscanf(fid,'%f/n');
    param.StrandColor(2,:) = [r g b];
    ss = strtrim(fgetl(fid));
    
    for i = 1 : size(conn,1)
        types(i) = fscanf(fid,'%f/n');
    end
end
fclose(fid);

%% Generate the MATLAB script 'dnaInfo'
n_nt = size(conn,1);
assert(n_nt == numel(seq));
assert(norm(conn(:,1) - (1:n_nt)') < tol);
conn(:,1) = [];

n_bp = size(dNode,1);

if(n_nt > 30000)
    if(n_nt > 40000)
        if(n_nt > 50000)
            param.mol_res = 6;
        else
            param.mol_res = 5;
        end
    else
        param.mol_res = 4;
    end
else
    param.mol_res = 3;
end

fprintf('     # of nucleotides  : %d\n', n_nt)
fprintf('     # of base pairs   : %d\n', n_bp)
fprintf('     Molmap Resolution : %d\n', param.mol_res)

assert(n_bp == size(triad,1) && n_bp == size(id_nt,1));
dNode(:,1) = [];
triad(:,1) = [];
id_nt(:,1) = [];

triad2 = zeros(3,3,n_bp);
for i = 1 : n_bp
    triad2(:,:,i) = reshape(triad(i,:), 3, 3);
end

for i = 1 : n_nt
    if(param.cndo == 1)
        dnaInfo.dnaTop(i) = struct('id',     conn(i,1), ...
                                   'up',     conn(i,2), ...
                                   'down',   conn(i,3), ...
                                   'across', conn(i,4), ...
                                   'seq',    seq{i}, ...
                                   'types',  0);
    elseif(param.cndo == 2)
        dnaInfo.dnaTop(i) = struct('id',     conn(i,1), ...
                                   'up',     conn(i,2), ...
                                   'down',   conn(i,3), ...
                                   'across', conn(i,4), ...
                                   'seq',    seq{i}, ...
                                   'types',  types(i));
    end
    dnaInfo.dnaGeom.dNode = dNode;
    dnaInfo.dnaGeom.triad = triad2;
    dnaInfo.dnaGeom.id_nt = id_nt;
end

end