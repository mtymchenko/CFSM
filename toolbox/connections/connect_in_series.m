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
% Connects networks in series
%            _______     _______
%           |       |   |       |
%     1 o---|   1   |---|   2   |-- ... --o 2
%           |_______|   |_______|
%
%
%       connect_in_series(crt, name, children)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit


function connect_in_series(varargin)

crt = varargin{1};
name = varargin{2};
children = varargin{3};

links = {};
for ichild = 1:numel(children)-1
   if crt.compid(children(ichild)).N_ports==2
       links{ichild} = [2,3] + 2*(ichild-1);
   else
       error('Children must have 2 ports to connect in series')
   end 
end

switch nargin
    case 3
        connect_by_ports(crt, name, children, links);
    case 4
        connect_by_ports(crt, name, children, links, varargin{4});
    otherwise
        error('Wrong number of input parameters');
end




