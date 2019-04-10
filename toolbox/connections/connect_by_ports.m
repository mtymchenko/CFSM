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
% Connects networks in arbitrary configurations
% 
%       connect_by_ports(crt, children, links)
%           crt[obj] - circuit object
%           children[cell of [string]] - circuits comprising this subcircuit
%           links[array] - array of links like [to_port2, from_port1; to_port3, from_port4]
%
%       connect_by_ports(crt, name, children, links)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%           links[array] - array of links like [to_port2, from_port1; to_port3, from_port4]
%
%       connect_by_ports(crt, name, children, links, N_internal)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%           links[array] - array of links like [to_port2, from_port1; to_port3, from_port4]
%           N_internal[int] - USE WITH CAUTION: number of harmonics to use when connecting
%           (external number of harmonics remains the same)
%
%
% EXAMPLE:
%           _______           _______
%       1  |       |  2   4  |       |   5
%       o--|  "A"  |--o + o--|  "B"  |---o
%          |_______|         |_______|    
%              |
%              o 3
%              +
%              o 6
%           ___|___
%          |       |
%          |  "C"  |      
%          |_______|     
%              |           
%              o 7
%
% CODE:
%   connect_by_ports(crt, 'NTWRK', {'A','B','C'}, [2,4; 3,6])
%
% ***********************************************************************

function connect_by_ports(crt, name, children, links, varargin)

add_subcrt(crt, name, children, links, varargin{:});

end % fun



