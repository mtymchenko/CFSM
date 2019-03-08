% Composite Floquet Scattering Matrix (CFSM) Circuit Simulator 
% 
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

function loadcomp(varargin)
self = varargin{1}; % self object
filename = varargin{2};
try
    data = load([self.DEFAULT_SAVE_PATH,filename,'.mat'],'comp');
catch
    fprintf(['Unable to load /',self.DEFAULT_SAVE_PATH,filename,'.mat\n'])
end
switch nargin
    case 2
        % If name is not specified
        self.addcomp(data.comp);
    case 3
        % If name is specified
        name = varargin{3};
        self.addcomp(data.comp, name);
    otherwise
        error('Wrong number of input arguments');
end