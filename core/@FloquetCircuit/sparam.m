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
        comp_id = numel{self.comp}; % choose last one
        out = self.comp{comp_id}.sparam_concat();
        
    case 2
        comp_id = self.get_compid_by_name(varargin{2});
        out = self.comp{comp_id}.sparam_concat();
        
    case 4
        comp_id = self.get_compid_by_name(varargin{2});
        port_to = varargin{3};
        port_from = varargin{4};
        
        sparam_sweep = self.comp{comp_id}.sparam;
        M = 2*self.N_orders + 1;
        N_ports = size(sparam_sweep,1)/M;
        if (port_to>N_ports | port_from > N_ports)
            error(['Component has only ',num2str(N_ports),' ports']);
        end
        out = sparam_sweep((port_to-1)*M+[1:M],(port_from-1)*M+[1:M],:);
        
end
