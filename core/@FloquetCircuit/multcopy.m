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

function copies_names = multcopy(varargin)
self = varargin{1};
compid = varargin{2};
switch nargin
    case 2
        N_copies = 1;
        suffix = '_COPY';
    case 3
        N_copies = varargin{3};
        suffix = '_COPY';
    case 4
        N_copies = varargin{3};
        suffix = varargin{4};
    otherwise
        error('Wrong number of input parameters');
end

copies_names = cell(1,N_copies);

for icopy = 1:N_copies
    isuffix = [suffix, num2str(icopy)];
    copies_names{icopy} = self.copycomp(self.compid(compid).name, isuffix);
end % for

end % fun