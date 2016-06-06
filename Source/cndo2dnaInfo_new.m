function dnaInfo = cndo2dnaInfo_new(cndo_FN)

tol = 1e-10;

%% Initialization
conn  = zeros(0,5);     % id, up, down, across
seq   = cell(0,1);      % seq
types = zeros(0,1);     % type
dNode = zeros(0,4);
triad = zeros(0,10);
id_nt = zeros(0,3);


%% Read the file
fid = fopen(cndo_FN, 'r');

% Read the number of dnatops
ntop = fscanf(fid,'%d', 1);
for i = 1 : ntop
    conn(i,1) = fscanf(fid,'%i', 1);
    conn(i,2) = fscanf(fid,'%i', 1);
    conn(i,3) = fscanf(fid,'%i', 1);
    conn(i,4) = fscanf(fid,'%i', 1);
    conn(i,5) = fscanf(fid,'%i', 1);
    seq{i,1}  = fscanf(fid,'%s', 1);
    types(i,1)= fscanf(fid,'%i', 1);
end

% Read the field 'dNode'
nnode = fscanf(fid,'%d', 1);
for i = 1 : nnode
    dNode(i,1) = fscanf(fid,'%f', 1);
    dNode(i,2) = fscanf(fid,'%f', 1);
    dNode(i,3) = fscanf(fid,'%f', 1);
    dNode(i,4) = fscanf(fid,'%f', 1);
end

% Read the field 'triad'
ntriad = fscanf(fid,'%d', 1);
for i = 1 : ntriad
    triad(i,1)  = fscanf(fid,'%f', 1);
    triad(i,2)  = fscanf(fid,'%f', 1);
    triad(i,3)  = fscanf(fid,'%f', 1);
    triad(i,4)  = fscanf(fid,'%f', 1);
    triad(i,5)  = fscanf(fid,'%f', 1);
    triad(i,6)  = fscanf(fid,'%f', 1);
    triad(i,7)  = fscanf(fid,'%f', 1);
    triad(i,8)  = fscanf(fid,'%f', 1);
    triad(i,9)  = fscanf(fid,'%f', 1);
    triad(i,10) = fscanf(fid,'%f', 1);
end

% Read the field 'id_nt'
nid_nt = fscanf(fid,'%d', 1);
for i = 1 : nid_nt
    id_nt(i,1)  = fscanf(fid,'%i', 1);
    id_nt(i,2)  = fscanf(fid,'%i', 1);
    id_nt(i,3)  = fscanf(fid,'%i', 1);
end

fclose(fid);

%% Generate the MATLAB script 'dnaInfo'
n_nt = size(conn,1);
assert(n_nt == numel(seq));
assert(norm(conn(:,1) - (1:n_nt)') < tol);
conn(:,1) = [];

n_bp = size(dNode,1);
assert(n_bp == size(triad,1) && n_bp == size(id_nt,1));
dNode(:,1) = [];
triad(:,1) = [];
id_nt(:,1) = [];

triad2 = zeros(3,3,n_bp);
for i = 1 : n_bp
    triad2(:,:,i) = reshape(triad(i,:), 3, 3);
end

for i = 1 : n_nt
    dnaInfo.dnaTop(i) = struct('id',     conn(i,1), ...
                               'up',     conn(i,2), ...
                               'down',   conn(i,3), ...
                               'across', conn(i,4), ...
                               'seq',    seq{i}, ...
                               'types',  types(i));
    dnaInfo.dnaGeom.dNode = dNode;
    dnaInfo.dnaGeom.triad = triad2;
    dnaInfo.dnaGeom.id_nt = id_nt;
end

end