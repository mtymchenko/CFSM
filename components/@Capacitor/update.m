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

function update(self)
N = self.N_orders;
M = 2*N+1;
self.omega = 2*pi*self.freq;
self.omega_mod = 2*pi*self.freq_mod;
self.T_mod = 1/self.freq_mod;
self.Z01 = self.Z0;
self.Z02 = self.Z0;
self.ports = [1:self.N_ports];
self.N_Fports = M*self.N_ports;
self.Fports = [1:self.N_Fports];
self.sparam_sweep = zeros([self.N_Fports, self.N_Fports, numel(self.freq)]);
end