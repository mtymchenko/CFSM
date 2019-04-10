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
% Connects network A as:
%
%      
%     1 o---.---o 2
%           | 
%          [A]
%           |
%         GROUND
%
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       children_names [string] (required) - name of component A
%

function make_shunt_T(crt, name, children_names)

if numel(children_names)~=1
    error('Only 1 networks can be connected in pi')
end

add_joint(crt, 'JNT3', 3);

connect_by_ports(crt, name, [{'JNT3'}, children_names(:)], {[3,4], [5,0]});

end
