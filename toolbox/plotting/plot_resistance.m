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


function plot_resistance(crt, id, varargin)
% Plots resistance of the element <id>
%

narginchk(2,7);

p = inputParser;
addRequired(p, 'crt', @(x) isobject(x) )
addRequired(p, 'id', @(x) ischar(x) || @(x) isnumeric(x) )
addOptional(p, 'time', [], @(x) isnumeric(x));
addOptional(p, 'XUnits', 's', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})) )
addOptional(p, 'YUnits', 'Ohm', @(x) any(validatestring(x, {'aOhm','fOhm','pOhm','nOhm','uOhm','mOhm','Ohm','kOhm','MOhm','GOhm','TOhm'})) )
addOptional(p, 'Mode', 'complex', @(x) any(validatestring(x, {'complex','Re','Im'})) )
parse(p, crt, id, varargin{:})

crt = p.Results.crt;
cmp = crt.compid(p.Results.id);
t = p.Results.time;
x_units = p.Results.XUnits;
y_units = p.Results.YUnits;
mode = p.Results.Mode;

if ~strcmp(cmp.type, 'resistor')
    error(['Component ', cmp.name, ' is not a resistor']);
end 

T = 1./crt.freq_mod;
if isempty(t)
    t = linspace(0, T, numel(cmp.R));
end

x_unit_factor = get_unit_factor(x_units);
y_unit_factor = get_unit_factor(y_units);

R = cmp.get_resistance(t);

X = t;
Y = [];
legend_entries = {};
if strcmp(mode,'Re') || strcmp(mode,'complex')
    Y = [Y; real(R)];
    legend_entries = {legend_entries{:}, 'Re'};
end
if strcmp(mode,'Im') || strcmp(mode,'complex')
    Y = [Y; imag(R)];
    legend_entries = {legend_entries{:}, 'Im'};
end

plot(X/x_unit_factor, Y/y_unit_factor,'LineWidth',1.5);
xlabel(['Time, t (',x_units,')'])
ylabel(['Resistance, R (',y_units,')'])
legend(legend_entries);
axis tight
grid on
end