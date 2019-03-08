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

classdef PhaseShifter < FloquetCircuitComponent
    
    properties        
        Z01, Z02
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
            self.component_type = 'phaseshifter';
            self.N_ports = 2;
            self.Z01 = self.Z0; % default port 1 impedance [ohm]
            self.Z02 = self.Z0; % default port 2 impedance [ohm]
            % Parsing input    
            if (~isempty(varargin))
                for arg = 1:nargin
                    if ischar(varargin{arg})
                        switch varargin{arg}
                            case 'Name'
                                self.name = varargin{arg+1};
                            case 'Phi21'
                                self.phi21_handle = varargin{arg+1};
                            case 'Phi12'
                                self.phi12_handle = varargin{arg+1};
                            case 'Description'
                                self.description = varargin{arg+1};
                        end % switch
                    end % if
                end % for
            end % if
        end % fun 

          
        self = update(self)
        self = precompute(self)
        
        out = sparam(varargin)
              
        % Scattering matrixes sweeps
        
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
        
        
        function out = get_S11_sweep(self)
            if (isempty(self.S11_sweep)==1 | size(self.S11_sweep)~=self.empty_sweep_size)
                self.compute_S11_sweep();
            end % end
            out = self.S11_sweep;
        end % fun
        
        function out = get_S12_sweep(self)
            if (isempty(self.S12_sweep)==1 | size(self.S12_sweep)~=self.empty_sweep_size)
                self.compute_S12_sweep();
            end % end
            out = self.S12_sweep;
        end % fun
        
        function out = get_S21_sweep(self)
            if (isempty(self.S21_sweep)==1 | size(self.S21_sweep)~=self.empty_sweep_size)
                self.compute_S21_sweep();
            end % end
            out = self.S21_sweep;
        end % fun
        
        function out = get_S22_sweep(self)
            if (isempty(self.S22_sweep)==1 | size(self.S22_sweep)~=self.empty_sweep_size)
                self.compute_S22_sweep();
            end % end
            out = self.S22_sweep;
        end % fun
        
    end % methods
    
end % classdef

