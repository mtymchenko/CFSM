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

classdef FloquetCircuitComponent < FTCore & matlab.mixin.Copyable
    
    properties
        component_type
        id % [int] unique component id in the circuit
        is_ready % 0 (default) or 1
        Z0 % reference impedance
        freq, omega
        freq_mod, omega_mod, T_mod
        N_orders % number of Floquet orders
        N_ports
        N_Fports
        ports % [array] external ports' indexes
        Fports % [array] external Floquet ports
        matrix_size
        empty_sweep_size
        name
        description
        input_spectrum
        output_spectrum
    end % properties
    
    methods
        
        function self = FloquetCircuitComponent()
            % Class constructor
            % Setting default values:
            self.Z0 = 50; % [ohm]
            % modulation angular frequency
            self.freq_mod = 1; % Hz
            self.omega_mod = 2*pi*self.freq_mod; % [rad/s]
            self.is_ready = 0;
        end % fun
        
        out = get_number_of_ports(self)
        out = get_sparam(varargin)
        out = list_all_sparams(self)
        
        
    end % methods
    
end % classdef

