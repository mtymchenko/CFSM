% Composite Floquet Scattering Matrix (CFSM) Circuit Simulator
%
% Copyright (C) 2019  Mykhailo Tymchenko
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


function out = get_inductance(crt, name, t)
if strcmp(crt.compid(name).type,'inductor')
    out = crt.compid(name).get_inductance(t);
else
    error(['Component "',crt.compid(name),'" is not an inductor'])
end