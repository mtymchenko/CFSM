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


classdef Units
    
    properties
        frequency
        current
        voltage
        electric_energy
        magnetic_energy
        time
    end
    
    methods
        
        function self = Units()
            self.frequency = 1e9; % [Hz]
            self.current = 1; % [A]
            self.voltage = 1; % [V]
            self.electric_energy = 1; 
            self.magnetic_energy = 1;
            self.time = 1e-9; % [s]
        end % function
        
    end % methods
    
end % class