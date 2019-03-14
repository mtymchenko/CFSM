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
% Creates a network like this
%
%            R1(t)     _____     R2(t)
%            ____     |     |     ____
%    1 o----|____|----|  A  |----|____|----o 2 
%                     |_____|
% 
%
% ***********************************************************************

function add_switched_network(crt, name, comp_id, R1, R2)

add_resistor(crt, ['SWA_',name], R1 );
add_resistor(crt, ['SWB_',name], R2 );

connect_in_series(crt, name, {['SWA_',name], comp_id, ['SWB_',name]});


