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

function excite_wideband(crt, compid, port, voltage)
    if numel(voltage)==numel(crt.freq) 
        input_spectrum = voltage/(2*sqrt(real(crt.Z0)));
        crt.set_input_spectrum(compid, port, input_spectrum);
        crt.input_is_pulse = 1;
    else
        error('Wrong size of input spectrum');
    end 
end % fun