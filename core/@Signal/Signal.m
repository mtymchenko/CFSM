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

classdef Signal < FTCore
    
    properties
        input_signal
        Z0 % reference impedance
        freq
        N_orders % number of Floquet orders
        empty_sweep % prepare a zero-matrix for quick assignmnet
        matrix_size % size of the Floquet matrixes
        children
        links
        solver_mode
        name
        description
    end
    
    methods
        
        function self = Signal(varargin)
            % Class constructor
            % Setting default values:
            self.Z0 = 50; % [ohm]
            % modulation angular frequency
            self.freq_mod = 1e9;
            self.omega_mod = 2*pi*self.freq_mod; % [rad/s]
            
            if (~isempty(varargin))
                for arg = 1:nargin
                    if ischar(varargin{arg})
                        switch varargin{arg}
                            case 'Type'
                                self.length = varargin{arg+1};
                            case 'CarrierFrequency'
                                self.length = varargin{arg+1};
                            case 'Dispersion'
                                self.v_phase_handle = varargin{arg+1};
                            case 'Description'
                                self.description = varargin{arg+1};
                            case 'CharacteristicImpedance'
                                self.Z = varargin{arg+1};
                        end % switch
                    end % if
                end % for
            end % if
        end % fun
        
        
        end
        
    end
    
end

