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

function out = list_all_sparams(self)
out = cell(1, self.N_ports^2);
i_sparam = 1;
for to_port = 1:self.N_ports
    for from_port = 1:self.N_ports
        out{i_sparam} = sprintf('S(%d,%d)', to_port, from_port);
        i_sparam = i_sparam+1;
    end
end