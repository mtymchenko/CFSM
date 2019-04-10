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


function plt = plot_output_spectrum(crt, compid, port, m, varargin)

p = inputParser;
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'Hz','kHz','MHz','GHz','THz','PHz'})))
addOptional(p, 'YUnits', 'auto', @(x) any(validatestring(x, {'auto','normalized'})))
addOptional(p, 'PlotType', 'plot', @(x) any(validatestring(x, {'plot','step'})))
parse(p, varargin{:})

N = crt.N_orders;

x_unit_factor = get_unit_factor(p.Results.XUnits);


output_spectrum = get_output_spectrum(crt, compid, port);

X = zeros(numel(m),numel(crt.freq));
Y = zeros(numel(m),numel(crt.freq));
legend_entries = cell(1, numel(m));
for im = 1:numel(m)
    X(im,:) = (crt.freq + m(im)*crt.freq_mod)/x_unit_factor;
    Y(im,:) = abs(output_spectrum(N+1+m(im),:));
    legend_entries{im} = ['n=',num2str(m(im))]; 
    
    hold on
    if strcmp(p.Results.PlotType, 'stem')
        plt = stem(X, Y, 'LineWidth',1.5);
    elseif strcmp(p.Results.PlotType, 'plot')
        plt = plot(X(im,:), Y(im,:), 'LineWidth',1.5);
    end
    hold off
end

axis([min(min(X)) max(max(X)) 0 inf]);

xlabel(['Frequency, f (', p.Results.XUnits ,')'])
ylabel('Amplitude')
title(['Output spectrum b_{',num2str(port),'n}(f)'])

if numel(m)~=1
    legend(legend_entries{:});
end
    
    

end