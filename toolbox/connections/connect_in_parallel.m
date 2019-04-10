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
% ***********************************************************************
% Connects networks in parallel
%
%
%           .---[A]---.
%           |         |
%     1 o---'---[B]---'---o 2
%           |         |
%           '---[C]---'
%           |         |
%               ...
%
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       children_names [cell of [string]] (required) - names of component to be
%           connected. Example {'COMP1','COMP2','COMP3'}
%

function connect_in_parallel(crt, name, children_names)

add_pin(crt, ['PIN1_',name])
add_pin(crt, ['PIN2_',name])

links{1} = 2;
links{2} = 2+2*numel(children_names)+1;
for icomp = 1:numel(children_names)
    links{1} = [links{1}, 3+2*(icomp-1)];
    links{2} = [links{2}, 4+2*(icomp-1)];
end

connect_by_ports(crt, name, {['PIN1_',name], children_names{:}, ['PIN2_',name]}, links);

end



