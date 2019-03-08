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
        if (port_to>N_ports | port_from > N_ports)
            error(['Component has only ',num2str(N_ports),' ports']);
        end % if
        out = self.sparam_sweep((port_to-1)*M+[1:M],(port_from-1)*M+[1:M],:);
    otherwise
        error('Wrong number of input parameters')
        
end % switch
