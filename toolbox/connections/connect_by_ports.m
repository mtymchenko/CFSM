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
%     1       2   5       6
%     o--[A]--*   *--[C]--o
%
%             3 *
%               |
%              [B]
%               |
%             4 o
%               
%   Example: connect_by_ports(crt, 'NTWRK', {'A','B','C'}, {[2,3,5]})
%
%

function connect_by_ports(crt, name, children_names, links, varargin)

add_subcrt(crt, name, children_names, links, varargin{:});

end



