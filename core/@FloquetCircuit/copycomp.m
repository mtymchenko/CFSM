% Copyright (C) 2017  Mykhailo Tymchenko
% Email: mtymchenko@utexas.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function copy_name = copycomp(varargin)
self = varargin{1};
name = varargin{2};
switch nargin
    case 2
        suffix = '_COPY';
    case 3
        suffix = varargin{3};
    otherwise
        error('Wrong number of input parameters');
end

copy_name = [name, suffix];

% IMPORTANT: here copy() function makes a deep copy of an object handle
% self.compid(name)
self.add(copy_name, copy(self.compid(name)));
%     parent_copy_name
if strcmp(self.compid(copy_name).component_type, 'circuit')
    for ichild = 1:numel(self.compid(copy_name).children)
        child_id = self.compid(copy_name).children(ichild);
        child_name = self.compid(child_id).name;
        child_copy_name = [child_name, suffix];
        self.copycomp(self.compid(child_id).name, suffix);
        % Overwrite old children IDs with copied children IDs
        self.compid(copy_name).children(ichild) = self.compid(child_copy_name).id;
    end % for
end % if

end % fun