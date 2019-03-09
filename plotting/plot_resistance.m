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
% Plots resistance of the element 'compid'

p = inputParser;
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})))
addOptional(p, 'YUnits', 'dB', @(x) any(validatestring(x, {'Ohm','kOhm','MOhm','GOhm'})))
nargin1 = nargin-2;

x_unit = 1;
y_unit = 1;

x_unit_label = 's';
y_unit_label = 'ohm';

if nargin >= 3
    % Use custom time
    t = varargin{1};
else
    % Otherwise, plot over 1 peroid
	t = linspace(0, 1./crt.freq_mod, numel(crt.compid(id).R));
end
	
if strcmp(crt.compid(id).component_type, 'resistor')
    resistance = crt.compid(id).get_resistance(t);
else
    error(['Component "',id,'" is not a resistor']);
end

if nargin >= 4
    for iarg = 4:1:nargin
        if strcmp(varargin{iarg}, 'XUnits')
            [x_unit, x_unit_label] = get_SI_unit(varargin{iarg+1});
        elseif strcmp(varargin{iarg}, 'YUnits')
            [y_unit, y_unit_label] = get_SI_unit(varargin{iarg+1});
        end
    end    
end % switch

X = t/x_unit;
Y1 = [real(resistance); imag(resistance)]/y_unit;
Y2 = crt.compid(id).R/y_unit;

plot(X, Y1,'LineWidth',1.5);
if size(Y1,2)==numel(Y2)
    hold on
    plot(X, Y2, 'color', [0.5 0.5 0.5], 'LineWidth',1); 
    hold off
end
xlabel(['Time, {\itt} (',x_unit_label,')'])
ylabel(y_unit_label)
title('Resistance, R(t) ')
legend('Re','Im');
end