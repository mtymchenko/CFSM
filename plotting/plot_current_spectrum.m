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


function plt = plot_current_spectrum(crt, compid, port, varargin)

p = inputParser;
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'Hz','kHz','MHz','GHz','THz','PHz','harmonics'})))
addOptional(p, 'YUnits', 'A', @(x) any(validatestring(x, {'fA','pA','nA','uA','mA','A','kA','MA','GA'})))
addOptional(p, 'PlotType', 'default', @(x) any(validatestring(x, {'default','stem'})))

N_optional_args = nargin-3;

if N_optional_args >= 1 && isnumeric(varargin{1})
    freq_id = crt.get_frequency_id(varargin{1});
    parse(p, varargin{2:end})
else
    freq_id = 1;
    parse(p, varargin{:})
end

if strcmp(p.Results.XUnits, 'harmonics')
    X = [-crt.N_orders:crt.N_orders];
else
    x_unit_factor = get_unit_factor(p.Results.XUnits);
    X = (crt.freq(freq_id) + [-crt.N_orders:crt.N_orders]*crt.freq_mod)/x_unit_factor;
end

y_unit_factor = get_unit_factor(p.Results.YUnits);
current_spectrum = get_current_spectrum(crt, compid, port);
Y = abs(current_spectrum(:,freq_id))/y_unit_factor;

if strcmp(p.Results.PlotType, 'stem')
    plt = stem(X, Y, 'LineWidth',1.5);
elseif strcmp(p.Results.PlotType, 'default')
    plt = plot(X, Y, 'LineWidth',1.5); hold on
    plot([crt.freq(freq_id) crt.freq(freq_id)]/x_unit_factor, [0 max(plt.YData)]); hold off

end
if strcmp(p.Results.XUnits, 'harmonics')
    xlabel(['Harmonics, n'])
else
    xlabel(['Frequency, f (', p.Results.XUnits ,')'])
end
ylabel( p.Results.YUnits )
title(['Current spectrum, I_{',num2str(port),'}n'])

end