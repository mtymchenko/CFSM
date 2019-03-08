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

classdef Capacitor < FloquetCircuitComponent
    
    properties
        Z01, Z02
        C % Capacitance C(t) [F], t=[0..T]
        C_toeplitz % Toeplitz matrix of C(t) Fourier coeffs
        sparam_sweep
    end % properties
    
    methods
        
        function self = Capacitor(varargin)
        % Constructor function    
            self.component_type = 'capacitor';
            self.N_ports = 2;
            self.Z01 = self.Z0; % default port 1 impedance [ohm]
            self.Z02 = self.Z0; % default port 2 impedance [ohm]
            
            % Parsing input
            if (~isempty(varargin))
                for arg = 1:nargin
                    if ischar(varargin{arg})
                        if strcmp(varargin{arg}, 'Name')
                        	self.name = varargin{arg+1};
                        elseif strcmp(varargin{arg}, 'Capacitance')
                        	self.C = varargin{arg+1};
                        elseif strcmp(varargin{arg}, 'Description')
                        	self.description = varargin{arg+1};
%                         else
%                             error(['Unknown parameter "',varargin{arg},'"']);
                        end % if
                    end % if
                end % for
            end % if
        end % fun
        
        
        
        % Function footprints (stored in separate files)
        
        
        update(self)
        precompute(self)
        
        % Technical functions specific to each element go here
        
        
        function out = get_capacitance_spectrum(self)
            C_toeplitz = self.get_C_toeplitz(); %#ok<PROP>
            out = C_toeplitz(:,self.N_orders+1); %#ok<PROP>
        end % fun
        
        
        function out = get_capacitance(self, t)
            out = self.compute_IFT(self.get_capacitance_spectrum(), t);
        end % fun
        
        
        function compute_S11_sweep(self)
            M = 2*self.N_orders+1;
            I = eye(M);
            n = [-self.N_orders:self.N_orders];
            for iomega = 1:numel(self.omega)
                Om = diag(self.omega(iomega)+n*self.omega_mod);
                U = I + 1j*(self.Z01+self.Z01)*Om*self.get_C_toeplitz();
                H11_matrix = self.Z02/(self.Z01+self.Z02)*I + self.Z01/(self.Z01+self.Z02)*I/U;
                self.sparam_sweep([1:M],[1:M],iomega) = 2*H11_matrix - I;
            end % for
        end % fun    
        
        
        function compute_S12_sweep(self)
            M = 2*self.N_orders+1;
            I = eye(M);
            n = [-self.N_orders:self.N_orders];
            for iomega = 1:numel(self.omega)
                Om = diag(self.omega(iomega)+n*self.omega_mod);
                U = I + 1j*(self.Z01+self.Z01)*Om*self.get_C_toeplitz();
                H12_matrix = self.Z01/(self.Z01+self.Z02)*I - self.Z01/(self.Z01+self.Z02)*I/U;
                self.sparam_sweep([1:M],M+[1:M],iomega) = 2*H12_matrix;
            end % for
        end % fun
        
        
        function compute_S21_sweep(self)
            M = 2*self.N_orders+1;
            I = eye(M);
            n = [-self.N_orders:self.N_orders];
            for iomega = 1:numel(self.omega)
                Om = diag(self.omega(iomega)+n*self.omega_mod);
                U = I + 1j*(self.Z01+self.Z01)*Om*self.get_C_toeplitz();
                H21_matrix = self.Z02/(self.Z01+self.Z02)*I - self.Z02/(self.Z01+self.Z02)*I/U;
                self.sparam_sweep(M+[1:M],[1:M],iomega) = 2*H21_matrix;
            end % for
        end % fun
        
        
        function compute_S22_sweep(self)
            M = 2*self.N_orders+1;
            I = eye(M);
            n = [-self.N_orders:self.N_orders];
            for iomega = 1:numel(self.omega)
                Om = diag(self.omega(iomega)+n*self.omega_mod);
                U = I + 1j*(self.Z01+self.Z01)*Om*self.get_C_toeplitz();
                H22_matrix = self.Z01/(self.Z01+self.Z02)*I + self.Z02/(self.Z01+self.Z02)*I/U;
                self.sparam_sweep(M+[1:M],M+[1:M],iomega) = 2*H22_matrix - I;
            end % for
        end % fun
        
               
        function compute_sparam_sweep(self)
            self.compute_S11_sweep();
            self.compute_S12_sweep();
            self.compute_S21_sweep();
            self.compute_S22_sweep();
            self.is_ready = 1;
        end        
        
        % Computes Toeplitz matrix of Cmn Fourier coefficients
        function compute_C_toeplitz(self)
            self.C_toeplitz = self.compute_FT_toeplitz(self.C);
        end % fun
        
        function out = get_C_toeplitz(self)
            if isempty(self.C_toeplitz)
                self.compute_C_toeplitz();
            end
            out = self.C_toeplitz;
        end  % fun
        
    end
    
end

