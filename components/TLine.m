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

classdef TLine < FloquetCircuitComponent
    
    properties
        length % [m] t-line length
        vp_handle  % v_p(omega) - phase velocity dispersion
        sparam_sweep
        Z
        Z01
        Z02
    end % properties
    
    methods
        
        
        function self = TLine(varargin)
            % Class constructor
        
            p = inputParser;
            addRequired(p, 'Name', @(x) ischar(x) );
            addRequired(p, 'Length', @(x) isnumeric(x) );
            addRequired(p, 'PhaseVelocityHandle', @(x) isa(x,'function_handle'));
            addRequired(p, 'CharacteristicImpedance', @(x) isnumeric(x));
            addOptional(p, 'Description', '', @(x) ischar(x));
            parse(p, varargin{:})
            
            self.type = 'tline';
            self.N_ports = 2;
            self.name = p.Results.Name;
            self.length = p.Results.Length;
            self.vp_handle = p.Results.PhaseVelocityHandle;
            self.Z = p.Results.CharacteristicImpedance;
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

        
        function self = precompute(self)
            self.update();
            self.compute_sparam_sweep();
        end % fun
        
        
        function compute_S11_sweep(self)
            M = 2*self.N_orders+1;
            n = [-self.N_orders:self.N_orders];
            S11_handle = self.get_S11_handle();
            for iomega = 1:numel(self.omega)
                self.sparam_sweep([1:M],[1:M],iomega) = diag(S11_handle(n,self.omega(iomega)));
            end % for
        end % fun
        
        
        function compute_S12_sweep(self)
            M = 2*self.N_orders+1;
            n = [-self.N_orders:self.N_orders];
            S12_handle = self.get_S12_handle();
            for iomega = 1:numel(self.omega)
                self.sparam_sweep([1:M],M+[1:M],iomega) = diag(S12_handle(n,self.omega(iomega)));
            end % for
        end % fun
        
        
        function compute_S21_sweep(self)
            M = 2*self.N_orders+1;
            n = [-self.N_orders:self.N_orders];
            S21_handle = self.get_S21_handle();
            for iomega = 1:numel(self.omega)
                self.sparam_sweep(M+[1:M],[1:M],iomega) = diag(S21_handle(n,self.omega(iomega)));
            end % for
        end % fun
        
        
        function compute_S22_sweep(self)
            M = 2*self.N_orders+1;
            n = [-self.N_orders:self.N_orders];
            S22_handle = self.get_S22_handle();
            for iomega = 1:numel(self.omega)
                self.sparam_sweep(M+[1:M],M+[1:M],iomega) = diag(S22_handle(n,self.omega(iomega)));
            end % for
        end % fun
        
        
        function out = get_S11_handle(self)
            beta = @(n,om) (om+n*self.omega_mod)./self.vp_handle(om+n*self.omega_mod);
            if isnumeric(self.Z)==1
                out = @(n,om) (self.Z/self.Z0-self.Z0/self.Z).*sinh(1j*beta(n,om).*self.length)./...
                    (2*cosh(1j*beta(n,om).*self.length) + (self.Z/self.Z0+self.Z0/self.Z).*sinh(1j*beta(n,om).*self.length));
            else
                out = @(n,om) (self.Z(om)/self.Z0-self.Z0/self.Z(om)).*sinh(1j*beta(n,om).*self.length)./...
                    (2*cosh(1j*beta(n,om).*self.length) + (self.Z(om)/self.Z0+self.Z0./self.Z(om)).*sinh(1j*beta(n,om).*self.length));
            end % if
        end % fun
        
        
        function out = get_S21_handle(self)
            beta = @(n,om) (om+n*self.omega_mod)./self.vp_handle(om+n*self.omega_mod);
            if isnumeric(self.Z)==1
                out = @(n,om) 2./(2*cosh(1j*beta(n,om).*self.length) + (self.Z/self.Z0+self.Z0/self.Z).*sinh(1j*beta(n,om).*self.length));
            else
                out = @(n,om) 2./(2*cosh(1j*beta(n,om).*self.length) + (self.Z(om)/self.Z0+self.Z0./self.Z(om)).*sinh(1j*beta(n,om).*self.length));
            end % if
        end % fun
        
        
        function out = get_S12_handle(self)
            beta = @(n,om) (om+n*self.omega_mod)./self.vp_handle(om+n*self.omega_mod);
            if isnumeric(self.Z)==1
                out = @(n,om) 2./(2*cosh(1j*beta(n,om).*self.length) + (self.Z/self.Z0+self.Z0/self.Z).*sinh(1j*beta(n,om).*self.length));
            else
                out = @(n,om) 2./(2*cosh(1j*beta(n,om).*self.length) + (self.Z(om)/self.Z0+self.Z0./self.Z(om)).*sinh(1j*beta(n,om).*self.length));
            end % if
        end % fun
        
        
        function out = get_S22_handle(self)
            beta = @(n,om) (om+n*self.omega_mod)./self.vp_handle(om+n*self.omega_mod);
            if isnumeric(self.Z)==1
                out = @(n,om) (self.Z/self.Z0-self.Z0/self.Z).*sinh(1j*beta(n,om).*self.length)./...
                    (2*cosh(1j*beta(n,om).*self.length) + (self.Z/self.Z0+self.Z0/self.Z).*sinh(1j*beta(n,om).*self.length));
            else
                out = @(n,om) (self.Z(om)/self.Z0-self.Z0./self.Z(om)).*sinh(1j*beta(n,om).*self.length)./...
                    (2*cosh(1j*beta(n,om).*self.length) + (self.Z(om)/self.Z0+self.Z0./self.Z(om)).*sinh(1j*beta(n,om).*self.length));
            end % if
        end % fun
        
        
       
        function compute_sparam_sweep(self)
            self.compute_S11_sweep();
            self.compute_S12_sweep();
            self.compute_S21_sweep();
            self.compute_S22_sweep();
            self.is_ready = 1;
        end % fun
        
        
    end % methods
    
end % class