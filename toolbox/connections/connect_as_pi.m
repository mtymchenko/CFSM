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
% Connects 3 networks as
%
%
%     1 o---.--[B]--.---o 2
%           |       |     
%          [A]     [C]
%           |       |
%           '---.---'
%               |
%             GROUND
%
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       children_names [cell of [string]] (required) - names of the three
%           component to be connected. Example {'COMP1','COMP2','COMP3'}
%

function connect_as_pi(crt, name, children_names)

if numel(children_names)~=3
    error('Only 3 networks can be connected in pi')
end

name1 = ['SHUNT_',crt.compid(children_names{1}).name,'_',name];
name2 = ['SHUNT_',crt.compid(children_names{3}).name,'_',name];

make_shunt_T(crt, name1, children_names{1});
make_shunt_T(crt, name2, children_names{3});
connect_in_series(crt, name, {name1, children_names{2}, name2})
        
end




