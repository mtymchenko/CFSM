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

classdef Joint < FloquetCircuitComponent
    
    properties
        sparam_sweep
    end %
    
    methods
        
        function self = Joint(varargin)
            % Constructor function 
        
            p = inputParser;
            addRequired(p, 'Name', @(x) ischar(x) );
            addRequired(p, 'NumPorts', @(x) isnumeric(x) );
            addOptional(p, 'Description', '', @(x) ischar(x));
            parse(p, varargin{:})
            
            self.type = 'joint';
            self.name = p.Results.Name;
            self.N_ports = p.Results.NumPorts;
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
        
        
        function compute_sparam_sweep(self)  
            M = 2*self.N_orders+1;
            G = inv(self.Z0*eye(self.N_ports-1) + self.Z0*ones(self.N_ports-1));
            for port_to = 1:self.N_ports
                for port_from = 1:self.N_ports
                    if port_to == port_from                
                        self.sparam_sweep(M*(port_to-1)+[1:M], M*(port_from-1)+[1:M],:) ...
                            = repmat(eye(M)*(1-2*self.Z0*sum(sum(G,2),1)), 1, 1, numel(self.freq));
                    else
                        SS = 2*self.Z0*sum(G,1);
                        self.sparam_sweep(M*(port_to-1)+[1:M], M*(port_from-1)+[1:M],:) ...
                            = repmat(eye(M)*SS(1), 1, 1, numel(self.freq));
                    end % if
                end % for
            end % for
            self.is_ready = 1;
        end % fun  
                
    end % methods
    
end % classdef