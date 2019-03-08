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


function set_input_voltage(crt, compid, port, V_in, duration)
% Applies the finite-length temporal voltage signal to a
% specified port of component comp_id
%
powerwave_in = V_in/(2*sqrt(crt.Z0)); % power wave
set_input_signal(crt, compid, port, powerwave_in, duration);
end % fun