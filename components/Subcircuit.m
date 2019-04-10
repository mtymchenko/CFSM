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
                                
    end % properties
    
    
    methods
        
        function self = Subcircuit(varargin)
        % Constructor function
        
            p = inputParser;
            addRequired(p, 'Name', @(x) ischar(x) );
            addRequired(p, 'Children', @(x) iscellstr(x));
            addRequired(p, 'Links', @(x) iscell(x));
            addOptional(p, 'Description', '', @(x) ischar(x));
            addOptional(p, 'IsBlackBox', 1, @(x) isnumeric(x) && ismember(x, [0,1]));
            parse(p, varargin{:})
        
            self.type = 'circuit';
            self.name = p.Results.Name;
            self.children = p.Results.Children;
            self.links = p.Results.Links;
            self.description = p.Results.Description;
            self.is_blackbox = p.Results.IsBlackBox;

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

