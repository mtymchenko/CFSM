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


function plt = plot_input_spectrum(crt, compid, port, varargin)

p = inputParser;
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'Hz','kHz','MHz','GHz','THz','PHz'})))
addOptional(p, 'YUnits', 'auto', @(x) any(validatestring(x, {'auto','normalized'})))
addOptional(p, 'PlotType', 'plot', @(x) any(validatestring(x, {'plot','stem'})))
parse(p, varargin{:})

N = crt.N_orders;

x_unit_factor = get_unit_factor(p.Results.XUnits);
X = crt.freq/x_unit_factor;

input_spectrum = get_input_spectrum(crt, compid, port);
Y = abs(input_spectrum(N+1,:));

if strcmp(p.Results.PlotType, 'stem')
    plt = stem(X, Y, 'LineWidth',1.5);
elseif strcmp(p.Results.PlotType, 'plot')
    plt = plot(X, Y, 'LineWidth',1.5);
end
axis([min(X) max(X) 0 inf]);

xlabel(['Frequency, f (', p.Results.XUnits ,')'])
ylabel('Amplitude')
title(['Input spectrum a_{',num2str(port),'n}(f)'])

end