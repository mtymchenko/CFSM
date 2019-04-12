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


function [plt, l] = plot_voltage(crt, varargin)

p = inputParser;
addRequired(p, 'id', @(x) ischar(x) || @(x) isnumeric(x) )
addRequired(p, 'port', @(x) isnumeric(x) )
addOptional(p, 'time', linspace(0,1./crt.freq_mod, 1000), @(x) isnumeric(x) )
addOptional(p, 'XUnits', 's', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})))
addOptional(p, 'YUnits', 'V', @(x) any(validatestring(x, {'aV','fV','pV','nV','uV','mV','V','kV','MV','GV'})))
addOptional(p, 'Mode', 'real', @(x) any(validatestring(x, {'real','imag','complex'})))
parse(p, varargin{:})


id = p.Results.id;
port = p.Results.port;
t = p.Results.time;
x_units = p.Results.XUnits;
y_units = p.Results.YUnits;
mode = p.Results.Mode;

x_unit_factor = get_unit_factor(x_units);
y_unit_factor = get_unit_factor(y_units);

voltage = get_voltage(crt, id, port, t);

X = t;
Y = [];
legend_entries = {};

if strcmp(mode, 'real') || strcmp(mode, 'complex')
    Y = [Y; real(voltage)];
    legend_entries = [legend_entries(:)', {'Re'}];
end
if strcmp(mode, 'imag') || strcmp(mode, 'complex')
    Y = [Y; imag(voltage)];
    legend_entries = [legend_entries(:)', {'Im'}];
end

plt = plot(X/x_unit_factor, Y/y_unit_factor, 'LineWidth', 1.5);
l = legend(legend_entries{:});
xlabel(['Time, t (', x_units ,')'])
ylabel(['Voltage, v_{',num2str(port),'}(t) (', y_units ,')'])

end % fun