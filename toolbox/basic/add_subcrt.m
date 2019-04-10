% Composite Floquet Scattering Matrix (CFSM) Circuit Simulator 
% 
% Copyright (C) 2019  Mykhailo Tymchenko
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
% Adds a new subcircuit
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       children [array of [string]] (required) - cell list of chlidrens' 
%           names, for example {'COMP1','COMP2','COMP3'}
%
%       links [cell of [double]] (required) - links among childrens' ports
%           Example: {[2,3], [4,5], [6,8]}
%

function add_subcrt(crt, name, children, links, varargin)

if isobject(crt)
    crt.add(Subcircuit(name, children, links, varargin{:}));
else
    error('"crt" must be a handle to a FloquetCircuit object')
end

end

