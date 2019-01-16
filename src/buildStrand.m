%
% =============================================================================
%
% buildStrand
% Last Updated : 01/14/2019, by Hyungmin Jun (hyungminjun@outlook.com)
%
% =============================================================================
%
% This is part of genPDB, which converts to the cndo file to
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
% -----------------------------------------------------------------------------
%
function [dnaTop,strand] = buildStrand(dnaTop)

nBase     = numel(dnaTop);      % number of bases in the DNA nanostructure
iStrand   = 0;
isVisited = false(nBase,1);

% Each loop creates a new strand
while(~isempty(find(~isVisited,1)))
    iStrand = iStrand + 1;
    currBase = dnaTop(find(~isVisited,1));
    initBaseID = currBase.id;
    
    % Find the first base in the current strand
    while(currBase.up>=0 && currBase.up~=initBaseID)
        currBase = dnaTop(currBase.up);
        if(isVisited(currBase.id))
            error('Reached a visited base.');
        end
    end
    if(currBase.up<0)   % currBase is at the 5'-end of the strand
        strand(iStrand).isCircular = false;
    elseif(currBase.up==initBaseID) % currBase goes back to the starting point
        strand(iStrand).isCircular = true;
        currBase = dnaTop(initBaseID);
    else
        error('Exception.');
    end
    
    % Set strand type
    if(currBase.types==0)
        strand(iStrand).types = 0;
    else
        strand(iStrand).types = 1;
    end
    
    % Walk through the current strand
    iResidue = 1;
    strand(iStrand).tour = currBase.id;
    dnaTop(currBase.id).strand = iStrand;
    dnaTop(currBase.id).residue = iResidue;
    isVisited(currBase.id) = true;
    % Each loop adds a new base
    while((~strand(iStrand).isCircular && currBase.down>=0) || ...
          (strand(iStrand).isCircular && currBase.down~=initBaseID))
        currBase = dnaTop(currBase.down);
        if(isVisited(currBase.id))
            error('Reached a visited base.');
        end
        iResidue = iResidue + 1;
        strand(iStrand).tour = cat(1, strand(iStrand).tour, currBase.id);
        dnaTop(currBase.id).strand = iStrand;
        dnaTop(currBase.id).residue = iResidue;
        isVisited(currBase.id) = true;
    end
end

end