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
%
%
% ***********************************************************************
% Creates a new subcircuit component and assigns links among its children
% 
%       subcrt(self, children, links)
%           self[obj]
%           children[cell of [string]] - circuits comprising this subcircuit
%           links[array] - array of links like [to_port2, from_port1; to_port3, from_port4]
%
%       subcrt(self, name, children, links)
%           self[obj]
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%           links[array] - array of links like [to_port2, from_port1; to_port3, from_port4]
%
%       subcrt(self, name, children, links, N_internal)
%           self[obj]
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%           links[array] - array of links like [to_port2, from_port1; to_port3, from_port4]
%           N_internal[int] - USE WITH CAUTION: number of harmonics to use when connecting
%           (external number of harmonics remains the same)
%
% ***********************************************************************

function subcrt(varargin)

subcrt = Subcircuit();

self = varargin{1};


switch nargin
    case 3
        % subcrt(self, children, links)
        subcrt.name = self.generate_name(subcrt.component_type);
        subcrt.children = self.get_numeric_compids(varargin{2});
        subcrt.links = varargin{3};
        subcrt.N_orders_internal = self.N_orders;
    case 4
        % subcrt(self, name, children, links) 
        subcrt.name = varargin{2};
        subcrt.children = self.get_numeric_compids(varargin{3});
        subcrt.links = varargin{4};
        subcrt.N_orders_internal = self.N_orders;
    case 5
        % subcrt(self, name, children, links, N_orders_internal) 
        subcrt.name = varargin{2};
        subcrt.children = self.get_numeric_compids(varargin{3});
        subcrt.links = varargin{4};
        subcrt.N_orders_internal = varargin{5};
    otherwise
        error('Wrong number of input arguments');
end

subcrt.N_orders = self.N_orders;
self.add(subcrt);
self.sort_ports(subcrt.name);

end % fun

