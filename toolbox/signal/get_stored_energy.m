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


function out = get_stored_energy(crt, id, t)
cmp = crt.get_comp(id);
if strcmp(cmp.type, 'capacitor')
    C = cmp.get_capacitance(t);
    v = get_voltage_across(crt, id, t);
    out = 1/2.*real(v).^2.*real(C);
    
elseif strcmp(cmp.type, 'inductor')
    L = cmp.get_inductance(t);
    i = get_current(crt, id, 1, t);
    out = 1/2.*real(i).^2.*real(L);
else
    error('The element must be either a capacitor or an inductor')
end % if

end