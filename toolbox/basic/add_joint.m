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
% **********************************************************************
% Adds a N-port joint to the circuit
%
%   Args:
%       crt [handle] (required) - circuit handle
%
%       name [string] (required) -  name of the joint element
%
%       N_ports [int] (required) - number of ports
%

function add_joint(crt, name, N_ports, varargin)

if isobject(crt)
    crt.add(Joint(name, N_ports, varargin{:}));
else
    error('"crt" must be a handle to FloquetCircuit object')
end

end

