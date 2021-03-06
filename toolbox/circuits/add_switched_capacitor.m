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
% Adds the following circuit:
%
%      o---[R1]--.--[R2]---o 
%      1         |         2
%               [C]
%                |
%              GROUND
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       C [array of [double]] (required) - capacitance C(t) over one period
%
%       R1 [array of [double]] (required) - resistance R1(t) over one period
%
%       R2 [array of [double]] (required) - resistance R2(t) over one period       
%  

function add_switched_capacitor(crt, name, C, R1, R2)

add_capacitor(crt, ['CAP_',name], C);
add_resistor(crt, ['SWA_',name], R1 );
add_resistor(crt, ['SWB_',name], R2 );

make_shunt_T(crt, ['SHUNT_CAP_',name], {['CAP_',name]})
connect_in_series(crt, name, {['SWA_',name], ['SHUNT_CAP_',name], ['SWB_',name]});

end


