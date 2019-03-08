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


% ***********************************************************************
% Connects 3 networkds in pi configuration
%
%                      _______
%                     |       |
%     1 o-------.-----|   2   |-----.-------o 2
%            ___|___  |_______|  ___|___
%           |       |           |       |
%           |   1   |           |   3   | 
%           |_______|           |_______|
%               |                   |
%             __|__               __|__
%             /////               /////
%
%
%       connect_as_pi(crt, name, comp_ids)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           comp_ids[cell of [string]] - circuits comprising this subcircuit
%
%       connect_as_pi(crt, name, comp_ids, N_internal)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           comp_ids[cell of [string]] - circuits comprising this subcircuit
%           N_internal[int] - USE WITH CAUTION: number of harmonics to use when connecting
%           (external number of harmonics remains the same)
%
% ***********************************************************************

function connect_as_pi(varargin)

crt = varargin{1};
name = varargin{2};
compids = varargin{3};

if numel(compids)~=3
    error('Only 3 networks can be connected in pi')
end

name1 = ['SHUNT_',crt.compid(compids{1}).name,'_',name];
name2 = ['SHUNT_',crt.compid(compids{3}).name,'_',name];

switch nargin
    case 3   
        make_shunt_T(crt, name1, compids{1});
        make_shunt_T(crt, name2, compids{3});
        connect_in_series(crt, name, {name1, compids{2}, name2})
    case 4
        make_shunt_T(crt, name1, compids{1}, varargin{4});
        make_shunt_T(crt, name2, compids{3}, varargin{4});
        connect_in_series(crt, name, {name1, compids{2}, name2}, varargin{4})
    otherwise
        error('Wrong number of input arguments');
end % switch




