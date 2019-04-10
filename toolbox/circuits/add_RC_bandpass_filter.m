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
%       o---[C1]--.--[R2]--.----o
%       1         |        |    2
%                [R1]    [C2]
%                 |        |
%              GROUND    GROUND
%
%   Args:
%       crt [object] (required) - circuit object
%
%       name [string] (required) -  name of the resistor
%
%       R1 [array of [double]] (required) - resistance R1(t) over one period
%
%       C1 [array of [double]] (required) - capacitance C1(t) over one period
%
%       R2 [array of [double]] (required) - resistance R2(t) over one period
%
%       C2 [array of [double]] (required) - capacitance C2(t) over one period
%

function add_RC_bandpass_filter(crt, name, R1, C1, R2, C2)

add_RC_highpass_filter(crt,['HIGHPASS_',name],R1,C1);
add_RC_lowpass_filter(crt,['LOWPASS_',name],R2,C2);

connect_in_series(crt, name, {['HIGHPASS_',name], ['LOWPASS_',name]})
