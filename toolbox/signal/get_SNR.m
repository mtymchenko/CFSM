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


function out = get_SNR(crt, compid, port)
voltage_spectrum = get_voltage_spectrum(crt, compid, port);
current_spectrum = get_current_spectrum(crt, compid, port);
P_spectrum = real(voltage_spectrum).*real(current_spectrum);
out = 10*log10(P_spectrum(crt.N_orders+1)/sum(P_spectrum([1:crt.N_orders,crt.N_orders+2:end])));
end