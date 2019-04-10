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
% *********************************************************************
%   Adds the following circuit:
%
%       o--[C]--.---o
%       1       |   2
%              [R]
%               |
%             GROUND
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       R [array of [double]] (required) - resistance R(t) over one period
%
%       C [array of [double]] (required) - capacitance C(t) over one period
%       

function add_RC_highpass_filter(crt, name, R, C)

add_resistor(crt, ['RES_',name], R);
add_capacitor(crt, ['CAP_',name], C);

make_shunt_T(crt, ['SHUNT_RES_',name], {['RES_',name]});
connect_in_series(crt, name, {['CAP_',name], ['SHUNT_RES_',name]})
end