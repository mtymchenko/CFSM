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
%           .--[R]--.
%           |       |
%       o---.--[L]--.---o
%       1   |       |   2
%           '--[C]--'
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       R [array of [double]] (required) - resistance R(t) over one period
%
%       L [array of [double]] (required) - inductance L(t) over one period
%
%       C [array of [double]] (required) - capacitance C(t) over one period
%       

function add_RLC_parallel(crt, name, R, L, C)

add_resistor(crt, ['RES_',name], R);
add_inductor(crt, ['IND_',name], L);
add_capacitor(crt, ['CAP_',name], C);

connect_in_parallel(crt, name, {['RES_',name], ['IND_',name], ['CAP_',name]})
