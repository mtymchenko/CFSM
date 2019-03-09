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

classdef Subcircuit < FloquetCircuitComponent
    
    properties
        sparam_sweep % [array] 3D array containging S-matrix sweeps
        is_blackbox % [int] 1 (default) or 0
        N_all_ports % [int] number of all ports, external+internal
        N_all_Fports % [int] number of all ports, external+internal
        all_ports % [array] all ports' indexes, external+internal
        all_Fports
        inner_ports % [array] internal ports' indexes
        outer_ports % [array] external ports' indexes
        inner_Fports % [array] internal Floquet ports' indexes
        outer_Fports % [array] external Floquet ports' indexes
        children
        links
        solver_mode
        
        all_Fports_as_matrix    % [array] all Floquet ports' indexes. 
                                % Each column is for one physical port
        
        inner_Fports_as_matrix  % [array] internal Floquet ports' indexes
                                % Each column is for one physical port
                               
        outer_Fports_as_matrix  % [array] external Floquet ports' indexes. 
                                % Each column is for one physical port 
                                
                                
    end % properties
    
    methods
        
        function self = Subcircuit(varargin)
        % Constructor function
            self.component_type = 'circuit';
            self.solver_mode = 0;
            self.is_blackbox = 1;
            % Parsing input
            if (~isempty(varargin))
                for arg = 1:nargin
                    if ischar(varargin{arg})
                        value = varargin{arg+1};
                        if strcmp(varargin{arg}, 'Name')
                        	self.name = value;
                        elseif strcmp(varargin{arg}, 'ReferenceImpedance')
                        	self.Z0 = value;
                        elseif strcmp(varargin{arg}, 'Children')
                            self.children = value;
                        elseif strcmp(varargin{arg}, 'Links')
                            self.links = value;
                        elseif strcmp(varargin{arg}, 'Description')
                            self.description = value;
                        elseif strcmp(varargin{arg}, 'IsBlackbox')
                            if (value==0 || value==1)
                                self.is_blackbox = value;
                            else
                                error('Invalid "is_blackbox" value. Can be only 0 or 1')
                            end % if
                        end % if
                    end % if
                end % for
            end % if
        end % fun
        
               
        function out = sparam(varargin)
            self = varargin{1};
            switch nargin
                case 1
                    out = self.sparam_sweep;
                case 3
                    port_to = varargin{2};
                    port_from = varargin{3};
                    
                    M = 2*self.N_orders + 1;
                    N_ports = size(self.sparam_sweep,1)/M;
                    if (port_to>N_ports || port_from > N_ports)
                        error(['Component has only ',num2str(N_ports),' ports']);
                    end % if
                    out = self.sparam_sweep((port_to-1)*M+[1:M],(port_from-1)*M+[1:M],:);
                otherwise
                    error('Wrong number of input parameters')
                    
            end % switch
        end % fun



        function self = update(self)
            self.omega = 2*pi*self.freq;
            self.omega_mod = 2*pi*self.freq_mod;
            self.T_mod = 1/self.freq_mod;
            self.matrix_size = [2*self.N_orders+1, 2*self.N_orders+1];
            self.empty_sweep_size = [self.matrix_size, numel(self.freq)];
        end % fun
        
    end % methods
    
end % classdef
