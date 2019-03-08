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


function out = get_stored_energy(crt, compid, t)

if strcmp(crt.compid(compid).component_type, 'capacitor')
    C = get_capacitance(crt, compid, t);
    v = get_voltage_across(crt, compid, t);
    out = 1/2.*real(v).^2*diag(C);
elseif strcmp(crt.compid(compid).component_type, 'inductor')
    L = get_inductance(crt, compid, t);
    i = get_current(crt, compid, 1, t);
    out = 1/2.*real(i).^2*diag(L);
else
    error('The element must be either a capacitor or an inductor')
end % if

end