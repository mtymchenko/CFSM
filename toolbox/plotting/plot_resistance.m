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
%
%
% **********************************************************************
% Plots resistance of the element as a function of time
%
%   Args:
%       crt [handle] (required) - circuit handle
%
%       id [string] (required) -  name of the element the inductance of
%       	which to plot
%
%       time [array] (optional) - time over which to plot L(t). Default 
%       	is one period
%
%   Params:
%
%       'XUnits': 'as'|'fs'|'ps'|'ns'|'us'|'ms'|'s' (default) 
%
%       'YUnits': 'aOhm'|'fOhm'|'pOhm'|'nOhm'|'uOhm'|'mOhm'|'Ohm' (default)|'kOhm'|'MOhm'|'GOhm'|'TOhm'
%
%       'Mode': 'complex' (default)|'Re'|'Im'
%

function plot_resistance(crt, varargin)
% Plots resistance of the element <id>
%

narginchk(2,7);

p = inputParser;
addRequired(p, 'id', @(x) ischar(x) || @(x) isnumeric(x) )
addOptional(p, 'time', linspace(0,1/crt.freq_mod,1000), @(x) isnumeric(x));
addOptional(p, 'XUnits', 's', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})) )
addOptional(p, 'YUnits', 'Ohm', @(x) any(validatestring(x, {'aOhm','fOhm','pOhm','nOhm','uOhm','mOhm','Ohm','kOhm','MOhm','GOhm','TOhm'})) )
addOptional(p, 'Mode', 'real', @(x) any(validatestring(x, {'complex','real','imag'})) )
parse(p, varargin{:})

id = p.Results.id;
cmp = crt.get_comp(id);
t = p.Results.time;
x_units = p.Results.XUnits;
y_units = p.Results.YUnits;
mode = p.Results.Mode;

if ~strcmp(cmp.type, 'resistor')
    error(['Component ', cmp.name, ' is not a resistor']);
end 

x_unit_factor = get_unit_factor(x_units);
y_unit_factor = get_unit_factor(y_units);

R = cmp.get_resistance(t);

X = t;
Y = [];
legend_entries = {};
if strcmp(mode,'real') || strcmp(mode,'complex')
    Y = [Y; real(R)];
    legend_entries = [legend_entries(:), {'Re'}];
end
if strcmp(mode,'imag') || strcmp(mode,'complex')
    Y = [Y; imag(R)];
    legend_entries = [legend_entries(:), {'Im'}];
end

plot(X/x_unit_factor, Y/y_unit_factor,'LineWidth',1.5);
xlabel(['Time, t (',x_units,')'])
ylabel(['Resistance, R (',y_units,')'])
legend(legend_entries);
axis tight
grid on
end