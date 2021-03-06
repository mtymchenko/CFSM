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

classdef PhaseShifter < FloquetCircuitComponent
    
    properties        
        phi21_handle % phaseshifter [pi]
        phi12_handle
        S11_sweep
        S12_sweep
        S21_sweep
        S22_sweep 
    end % properties
    
    methods
        
        function self = PhaseShifter(varargin)
            % Constructor function    
        
            p = inputParser;
            addRequired(p, 'Name', @(x) ischar(x) );
            addRequired(p, 'Phi21', @(x) isa(x,'function_handle'));
            addRequired(p, 'Phi12', @(x) isa(x,'function_handle'));
            addOptional(p, 'Description', '', @(x) ischar(x));
            parse(p, varargin{:})
            
            self.type = 'tline';
            self.N_ports = 2;
            self.name = p.Results.Name;
            self.phi21_handle = p.Results.Phi21;
            self.phi12_handle = p.Results.Phi12;
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
        end

        
        
        function self = precompute(self)
            self.update();
            self.compute_sparam_sweep();
        end
        
             
        
        function out = compute_S11_sweep(self)
            self.S11_sweep = zeros(self.empty_sweep_size);
            out = self.S11_sweep;
        end % fun
        
        
        function out = compute_S21_sweep(self)
            for iomega = 1:numel(self.omega)
                self.S21_sweep(:,:,iomega) = exp(1j*self.phi21_handle(self.omega(iomega)))*eye(self.matrix_size);
            end
            out = self.S21_sweep;
        end % fun
        
        
        function out = compute_S12_sweep(self)
            for iomega = 1:numel(self.omega)
                self.S12_sweep(:,:,iomega) = exp(1j*self.phi12_handle(self.omega(iomega)))*eye(self.matrix_size);
            end
            out = self.S12_sweep;
        end % fun
        
        
        function out = compute_S22_sweep(self)
            self.S22_sweep = zeros(self.empty_sweep_size); 
            out = self.S22_sweep;
        end % fun
        
        
        % Returns the supermatrix [S11,S12;S21,S22]
        function out = sparams_concat(self)
            % Concatenating to a supermatrix
            out = cat(1,...
                cat(2,self.get_S11_sweep(),self.get_S12_sweep()),...
                cat(2,self.get_S21_sweep(),self.get_S22_sweep));
        end % fun
                
        
        function compute_sparam_sweep(self)
            self.compute_S11_sweep();
            self.compute_S12_sweep();
            self.compute_S21_sweep();
            self.compute_S22_sweep();
            self.is_ready = 1;
        end % fun
        
    end % methods
    
end % classdef

