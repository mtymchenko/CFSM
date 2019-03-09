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
%  Connects 3 networks as
%                      _______        
%                     |       |         
%     1 o------.------|   3   |------.------o 3
%              |      |_______|      |
%           ___|___               ___|___
%          |       |             |       |
%          |   1   |             |   2   |
%          |_______|             |_______|
%              |                     |
%              |                     |
%              '----------.----------'
%                         |
%                         |
%                         o
%                         2
%
%
%       connect_as_delta(crt, name, comp_ids)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           comp_ids[cell of [string]] - circuits comprising this subcircuit
%
%       connect_as_delta(crt, name, comp_ids, N_internal)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           comp_ids[cell of [string]] - circuits comprising this subcircuit
%           N_internal[int] - USE WITH CAUTION: number of harmonics to use when connecting
%           (external number of harmonics remains the same)
%
% ***********************************************************************

function connect_as_delta(varargin)

crt = varargin{1};
name = varargin{2};
compids = varargin{3};

if numel(compids)~=3
    error('Only 3 networks can be connected in delta topology')
end

add_pin(crt, ['PIN1_',name]);
add_pin(crt, ['PIN2_',name]);
add_pin(crt, ['PIN3_',name]);

switch nargin
    case 3
        connect_by_ports(crt, name, ...
            {['PIN1_',name],compids{1},['PIN2_',name],compids{2},['PIN3_',name],compids{3}},...
            {[2,3,12], [4,5,7], [8,9,11]}) 
    case 4
        connect_by_ports(crt, name, ...
            {['PIN1_',name],compids{1},['PIN2_',name],compids{2},['PIN3_',name],compids{3}},...
            {[2,3,12], [4,5,7], [8,9,11]}, varargin{4}) 
    otherwise
        error('Wrong number of input arguments');
end % switch



