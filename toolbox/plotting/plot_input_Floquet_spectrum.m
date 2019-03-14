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


function plt = plot_input_Floquet_spectrum(crt, compid, port, freq, varargin)

p = inputParser;
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'Hz','kHz','MHz','GHz','THz','PHz','harmonics'})))
addOptional(p, 'YUnits', 'auto', @(x) any(validatestring(x, {'auto','normalized'})))
addOptional(p, 'PlotType', 'stem', @(x) any(validatestring(x, {'stem','plot'})))
parse(p, varargin{:})

freq_id = crt.get_frequency_id(freq);

if strcmp(p.Results.XUnits, 'harmonics')
    X = [-crt.N_orders:crt.N_orders];
else
    x_unit_factor = get_unit_factor(p.Results.XUnits);
    X = (crt.freq(freq_id) + [-crt.N_orders:crt.N_orders]*crt.freq_mod)/x_unit_factor;
end

input_spectrum = get_input_spectrum(crt, compid, port);
Y = abs(input_spectrum(:,freq_id));

if strcmp(p.Results.PlotType, 'stem')
    plt = stem(X, Y, 'LineWidth',1.5);
elseif strcmp(p.Results.PlotType, 'default')
    plt = plot(X, Y, 'LineWidth',1.5);
end
axis([min(X) max(X) 0 inf]);

if strcmp(p.Results.XUnits, 'harmonics')
    xlabel(['Harmonics, n'])
else
    xlabel(['Frequency, f (', p.Results.XUnits ,')'])
end
ylabel('Amplitude')
title(['Input Floquet spectrum, a_{',num2str(port),'n}'])

end