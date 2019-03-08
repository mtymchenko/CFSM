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
% Connects a network as
%     1 o------.------o 2
%           ___|___
%          |       |
%          |   1   |
%          |_______|
%              |
%            __|__  
%            /////
%
%
%       make_shunt_T(crt, name, comp_id)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%
%       make_shunt_T(crt, name, comp_id, N_internal)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%           N_internal[int] - USE WITH CAUTION: number of harmonics to use when connecting
%           (external number of harmonics remains the same)
%
% ***********************************************************************

function make_shunt_T(varargin)

crt = varargin{1};
name = varargin{2};
compid = varargin{3};

if numel(compid)~=1
    error('Only 1 networks can be connected in pi')
end

add_joint(crt, 'JNT3', 3);

switch nargin
    case 3
        connect_by_ports(crt, name, {'JNT3', compid{:}}, {[3,4], [5,0]});
    case 4
        connect_by_ports(crt, name, {'JNT3', compid{:}}, {[3,4], [5,0]}, varargin{4});
    otherwise
        error('Wrong number of input parameters');
end
