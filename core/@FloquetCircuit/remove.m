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

function remove(self, comp_id)
% Adds a new component to the circuit and assigns a unique name
if isnumeric(comp_id)
    id = comp_id;
else
    id = [];
    try
        id = self.get_compid_by_name(comp_id);
    catch
        warning('There is no component to remove')
    end
end

if isempty(id)==0
    id
    self.comp{id} = [];
end