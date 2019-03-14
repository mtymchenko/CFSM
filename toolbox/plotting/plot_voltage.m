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


function [plt, l] = plot_voltage(crt, id, port, t, varargin)

p = inputParser;
addOptional(p, 'XUnits', 's', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})))
addOptional(p, 'YUnits', 'V', @(x) any(validatestring(x, {'aV','fV','pV','nV','uV','mV','V','kV','MV','GV'})))
addOptional(p, 'Mode', 'real', @(x) any(validatestring(x, {'real','imag','complex'})))
parse(p, varargin{:});

x_unit_factor = get_unit_factor(p.Results.XUnits);
y_unit_factor = get_unit_factor(p.Results.YUnits);

voltage = get_voltage(crt, id, port, t);

if strcmp(p.Results.Mode, 'real') 
    plt = plot(t/x_unit_factor, real(voltage)/y_unit_factor, 'LineWidth', 1.5);
elseif strcmp(p.Results.Mode, 'imag')
    plt = plot(t/x_unit_factor, imag(voltage)/y_unit_factor, 'LineWidth', 1.5);
    l = legend('Im');
elseif strcmp(p.Results.Mode, 'complex')
    plt = plot(t/x_unit_factor, [real(voltage); imag(voltage)]/y_unit_factor, 'LineWidth', 1.5);
    l = legend('Re','Im');
end
xlabel(['Time, {\itt} (', p.Results.XUnits ,')'])
ylabel(p.Results.YUnits)
title(['Voltage, v_{',num2str(port),'}(t)'])

end % fun