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

classdef Pin < FloquetCircuitComponent
    
    properties        
        sparam_sweep
    end % properties
    
    methods
        
        function self = Pin(varargin)
        % Constructor function    
            self.component_type = 'pin';
            self.N_ports = 2;
            % Parsing input    
            if (~isempty(varargin))
                for arg = 1:nargin
                    if ischar(varargin{arg})
                        switch varargin{arg}
                            case 'Name'
                                self.name = varargin{arg+1};
                            case 'Description'
                                self.description = varargin{arg+1};
                        end % switch
                    end % if
                end % for
            end % if
        end % fun 

          
        self = update(self)
        self = precompute(self)
        
        
        % This is a shell class only to store the parameters of the pin.
        % The actual S-parameters are computed in the main class FloquetCircuit
        
    end % methods
    
end % classdef

