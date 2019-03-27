%
% =============================================================================
%
% pdbModify_multimodel
% Last Updated : 01/14/2019, by Hyungmin Jun (hyungminjun@outlook.com)
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
function pdb_multimodel = pdbModify_multimodel(pdbOld)

pdbNew = pdbOld;
nChain = length(pdbNew.Model.Terminal);
chainList = cell(nChain,3);

% Start atomSerNo and end atomSerNo
atomSerNo_start = 1;
for i = 1:nChain
    chainList{i,1} = atomSerNo_start;
    chainList{i,2} = pdbNew.Model.Terminal(i).SerialNo - i;
    chainList{i,3} = assignChainID(i);
    atomSerNo_start = chainList{i,2} + 1;
end

% Assign the new chain IDs
for i = 1:nChain
    AtomSerNo_start = pdbNew.Model.Atom(chainList{i,1}).AtomSerNo;
    for j = chainList{i,1}:chainList{i,2}
        pdbNew.Model.Atom(j).AtomSerNo = pdbNew.Model.Atom(j).AtomSerNo - AtomSerNo_start + 1;
        pdbNew.Model.Atom(j).chainID = ' A';
    end
    pdbNew.Model.Terminal(i).SerialNo = pdbNew.Model.Atom(chainList{i,2}).AtomSerNo + 1;
    pdbNew.Model.Terminal(i).chainID = ' A';
end

% Create multiple models
pdb_multimodel.Model(nChain) = struct('Atom',[], 'Terminal',[]);
for i = 1:nChain
    pdb_multimodel.Model(i).Atom = pdbNew.Model.Atom(chainList{i,1}:chainList{i,2});
    pdb_multimodel.Model(i).Terminal = pdbNew.Model.Terminal(i);
end

end

% Assign chain ID
function ID = assignChainID(index)

% if(index>26*27)
%     error('The number of scaffold/staple strands exceed the limit');
% end

start = 'A'-1;
if(index<=26)
    ID = sprintf(' %s', start+index);
else
    index1 = mod(index-1,26)+1;
    index2 = floor((index-1)/26);
    ID = sprintf('%c%c', start+index2, start+index1);
end

end