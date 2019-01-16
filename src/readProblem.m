%
% =============================================================================
%
% readProblem
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
function name_prob = readProblem

%% Read the file
fid   = fopen('list.txt');
count = 0;

% Read problem list
str = strtrim(fgetl(fid));
while(~isempty(str))
    count = count + 1;
    name_prob{count} = str;
    str = fgetl(fid);
    if(~ischar(str))
        break;
    end
    str = strtrim(str);
end

fclose(fid);

end