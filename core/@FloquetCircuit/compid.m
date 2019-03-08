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

function out = compid(self, querry_id)
% Returns the object self.comp{querry_id}
%
if isnumeric(querry_id)
    comp_id = querry_id;
else
    comp_id = self.get_compid_by_name(querry_id);
end
    
try
    out = self.comp{comp_id};
catch
    error(['Component "',num2str(comp_id),'" does not exist'])
end