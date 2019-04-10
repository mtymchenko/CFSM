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

classdef Inductor < FloquetCircuitComponent
    
    properties  
        L % Inductance L(t) [H], t=[0..T]
        L_toeplitz % Toeplitz matrix of C(t) Fourier coeffs
        sparam_sweep
    end
    
    methods
        
        function self = Inductor(varargin)
        % Constructor function
             
            p = inputParser;
            addRequired(p, 'Name', @(x) ischar(x) );
            addRequired(p, 'L', @(x) isnumeric(x) );
            addOptional(p, 'Description', '', @(x) ischar(x));
            parse(p, varargin{:})
            
            self.type = 'inductor';
            self.N_ports = 2;
            self.name = p.Results.Name;
            self.L = p.Results.L;
            self.description = p.Results.Description;
        
        end % fun
        
        
          
        function update(self)
            N = self.N_orders;
            M = 2*N+1;
            self.omega = 2*pi*self.freq;
            self.omega_mod = 2*pi*self.freq_mod;
            self.T_mod = 1/self.freq_mod;
            self.ports = [1:self.N_ports];
            self.N_Fports = M*self.N_ports;
            self.Fports = [1:self.N_Fports];
            self.sparam_sweep = zeros([self.N_Fports, self.N_Fports, numel(self.freq)]);
        end
        
        
        function precompute(self)
            self.update();
            self.compute_sparam_sweep();
        end
                      
        
        function out = get_inductance_spectrum(self)
            L_toeplitz = self.get_L_toeplitz(); %#ok<PROP>
            out = L_toeplitz(:,self.N_orders+1); %#ok<PROP>
        end % fun
        
        
        function out = get_inductance(self, t)
            out = self.compute_IFT(self.get_inductance_spectrum(), t);
        end % fun
              
        
        function compute_sparam_sweep(self)
            M = 2*self.N_orders+1;
            I = eye(M);
            n = [-self.N_orders:self.N_orders];
            
            Z01 = self.Z0*I;
            Z02 = self.Z0*I;
            
            for iomega = 1:numel(self.omega)
                Om = diag(self.omega(iomega)+n*self.omega_mod);
                U = I/((Z01+Z02) + 1j*Om*self.get_L_toeplitz());
                H11 = I - Z01*U;
                H12 = Z01*U;
                H21 = Z02*U;
                H22 = I-Z02*U;
                HH = [H11,H12;H21,H22];
                II = blkdiag(I,I);
                self.sparam_sweep(:,:,iomega) = 2*HH - II;
            end
            
            self.is_ready = 1;
        end     
        
        
       
        function self = compute_L_toeplitz(self)
            self.L_toeplitz = self.compute_FT_toeplitz(self.L);
        end % fun
        
        
        function out = get_L_toeplitz(self)
            if isempty(self.L_toeplitz)==1
                self.compute_L_toeplitz();
            end
            out = self.L_toeplitz;
        end % fun
        
        
    end % methods
    
end % classdef

