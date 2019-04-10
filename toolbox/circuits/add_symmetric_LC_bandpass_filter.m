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
% Adds a symmetric LC bandpath filter
%
%           o--[L/2]--.--[L/2]--o
%           1         |         2
%                    [C]
%                     |
%                   GROUND 
%                     
%
%   Args:
%       crt [handle] (required) - circuit handle
%
%       name [string] (required) -  name of the filter
%
%       L [double, array] (required) - inductance L(t)
%
%       C [double, array] (required) - capacitance C(t)
%

function add_symmetric_LC_bandpass_filter(crt, name, L, C)

add_inductor(crt, ['IND_',name],L/2);
add_capacitor(crt, ['CAP_',name], C);
add_joint(crt, ['JNT3_',name], 3);
add_ground(crt, ['GRND_',name]);

make_shunt_T(crt, ['SHUNT_CAP_',name], {['CAP_',name]});
connect_in_series(crt,name, {['IND_',name], ['SHUNT_CAP_',name], ['IND_',name]})
