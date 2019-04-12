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

classdef FloquetCircuitComponent < FTCore & matlab.mixin.Copyable
    
    properties
        type
        id % [int] unique component id in the circuit
        is_ready % 0 (default) or 1
        Z0 % reference impedance
        freq % frequency
        omega % Angular frequency
        freq_mod % Modulation frequency
        omega_mod % Angular modulation frequency
        T_mod % Periodicity
        N_orders % number of Floquet orders
        N_ports % Number of physical ports
        N_Fports % Number of Floquet ports
        ports % [array] external ports' indexes
        Fports % [array] external Floquet ports
        name % Component name
        description % Component description
        input_spectrum 
        output_spectrum
        nodes
        parents
    end % properties
    
    
    
    methods
        
        
        function self = FloquetCircuitComponent()
            % Class constructor
            %
            self.Z0 = 50; % [ohm] default reference impedance
            self.freq_mod = 1e6; % [Hz] default modulation frequency
            self.omega_mod = 2*pi*self.freq_mod; % [rad/s] default angular modulation frequency
            self.is_ready = 0;
        end % fun
        
        
                
        function out = get_sparam(self,varargin)
        
            narginchk(1,5);
                        
            N = self.N_orders;
            M = 2*N+1;
            
            if nargin == 1
                out = self.sparam_sweep;
                
            elseif nargin == 3
                port_to = varargin{1};
                port_from = varargin{2};
                if self.is_valid_port(port_to) && self.is_valid_port(port_from)
                    Fports_to = M*(port_to-1)+[1:M];
                    Fports_from = M*(port_from-1)+[1:M];
                    out = self.sparam_sweep(Fports_to, Fports_from, :);
                end % if
                
            elseif nargin == 5
                port_to = varargin{1};
                port_from = varargin{2};
                if self.is_valid_port(port_to) && self.is_valid_port(port_from)        
                    m = varargin{3};
                    n = varargin{4};
                    if self.is_valid_order(m) && self.is_valid_order(n)
                        Fports_to = M*(port_to-1)+N+1+m;
                        Fports_from = M*(port_from-1)+N+1+n;
                        if self.is_valid_Floquet_port(Fports_to) && self.is_valid_Floquet_port(Fports_from)
                            out = self.sparam_sweep(Fports_to, Fports_from, :);
                        else
                            error('Invalid Floquet port')
                        end % if
                    else
                        error('Invalid harmonic number')
                    end % if 
                end % if           
            else
                error('Wrong number of input parameters')     
            end % if

        end % fun
        
        
        
        function out = list_all_sparams(self)
            % Returns the cell list {S(1,1),S(1,2),...} containing all 
            % s-params
            %
            out = cell(1, self.N_ports^2);
            i_sparam = 1;
            for to_port = 1:self.N_ports
                for from_port = 1:self.N_ports
                    out{i_sparam} = sprintf('S(%d,%d)', to_port, from_port);
                    i_sparam = i_sparam+1;
                end % for
            end % for
        end % fun

        
    end % public methods
   
    
    
    
    methods (Access = protected)
        
        function out = is_valid_port(self, port)
            if isnumeric(port)
                if ismember(port, self.ports)
                    out = 1;
                else
                    out = 0;
                end % if
            else
                error('Port number must be an integer')
            end % if 
        end % fun
        
        
        
        function out = is_valid_Floquet_port(self, Fport)
            if isnumeric(Fport)
                if ismember(Fport, self.Fports)
                    out = 1;
                else
                    out = 0;
                end % if
            else
                error('Floquet port number must be an integer')
            end % if
        end % fun
        
        
        
        function out = is_valid_order(self, order)
            % Checks if 'order' is a valid Floquet order
            %
            if isnumeric(order)
                if ismember(order, [-self.N_orders:self.N_orders])
                    out = 1;
                else
                    out = 0;
                end % if
            else
                error('Floquet order must be an integer')
            end % if
        end % fun
        
    end % protected methods
    
    
end % classdef

