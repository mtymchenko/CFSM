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

function add(varargin)
%
%   Adds a new component to the circuit and assigns a unique name
%
%         self[class] = add(self[class], comp[class]) 
%               Here 'comp_new' is a new component. 
%               The name is generated automatically
%
%         self[self] = add(self[class], name[string], comp[class]) 
%               Here 'comp_new' is a new component with a name 'name'  
%

self = varargin{1}; % self object
switch nargin
    case 2
        comp = varargin{2}; % new component object
        if isempty(comp.name)
            comp.name = self.generate_name(comp.component_type);
        end
    case 3
        comp = varargin{3}; % new component object
        comp.name = varargin{2}; 

    otherwise
       error('Wrong number of input parameters');
end % switch

comp.freq = self.freq;
comp.omega = 2*pi*self.freq;
comp.N_orders = self.N_orders;

if self.is_unique_name(comp.name)==0
    if self.WARNINGS_OFF == 0
        disp(['WARNING: Component "',comp.name,'" already exists. Overwritten.'])
    end
    comp.id = self.get_compid_by_name(comp.name);
else
    comp.id = numel(self.comp)+1;
end
self.comp{comp.id} = comp;
if strcmp(self.comp{comp.id}.component_type,'circuit')~=1
    % if is not circuit, run update()
    self.comp{comp.id}.update();
end % if

end

