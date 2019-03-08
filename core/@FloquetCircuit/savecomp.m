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

function savecomp(varargin)
self = varargin{1}; % self object
name = varargin{2};
comp = self.comp{self.get_compid_by_name(name)};
switch nargin
    case 2
        % If no name specified, use the name of the component
        filename = comp.name;
    case 3
        % If name is specified, use it 
        filename = varargin{3};
    otherwise
        error('Wrong number of input arguments');
end
% Save the object 'comp' to a .mat file
try
    save([self.DEFAULT_SAVE_PATH,filename,'.mat'],'comp');
    fprintf(['Component "',name,'" has been successfuly saved to /',...
        self.DEFAULT_SAVE_PATH,filename,'.mat\n'])
catch
    error(['Unable to save component "',name,'" to /',...
        self.DEFAULT_SAVE_PATH,filename,'.mat\n'])
end