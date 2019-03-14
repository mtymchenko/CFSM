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
%
%          R1(t)        R2(t)
%    1 o----/ ----.----/ .----o 2 
%                 |
%               __|__
%               _____ C
%                 |
%               __|__
%               /////  
%
%

function add_switched_capacitor_bilinear(crt, name, C, R1, R2)

add_capacitor(crt, ['CAP_',name], C);
add_joint(crt, ['JNT3_',name], 3);

add_resistor(crt, ['SWA_',name], R1 );
add_resistor(crt, ['SWB_',name], R2 );

connect_by_ports(crt, ['SIDE1_',name], {['SWA_',name], ['JNT3_',name], ['SWB_',name]}, [2,3; 4,6]);
connect_by_ports(crt, ['SIDE2_',name], {['SWB_',name], ['JNT3_',name], ['SWA_',name]}, [2,3; 4,6]);
connect_by_ports(crt, name, ...
    {['JNT3_',name], ['SIDE1_',name], ['JNT3_',name], ['SIDE2_',name], ['CAP_',name]},...
    [2,4; 6,7; 9,12; 3,10; 5,13; 11,14]);


