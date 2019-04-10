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
% Connects networks in parallel
%
%
%       o---[A]--[B]--[C]-- ... ---o 2
%
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       children_names [cell of [string]] (required) - names of component 
%           to be connected. Example {'COMP1','COMP2','COMP3'}
%

function connect_in_series(crt, name, children_names)


links = {};
for ichild = 1:numel(children_names)-1
   if crt.compid(children_names(ichild)).N_ports==2
       links{ichild} = [2,3] + 2*(ichild-1);
   else
       error('Children must have 2 ports to connect in series')
   end 
end

connect_by_ports(crt, name, children_names, links);

end




