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


function ax = plot_band_diagram(crt,name,m,n)

GHz = 1e9;

[ka_bands_p, ka_bands_m, ~, ~] = analyze_periodic(crt, name, m, n);
hold on
plot(real(ka_bands_p)/2/pi,crt.freq/GHz,'-r','MarkerSize',2,'LineWidth',2);
plot(real(ka_bands_m)/2/pi,crt.freq/GHz,'-r','MarkerSize',2,'LineWidth',2);
hold off
title('Band diagram')
xlabel('{\itka}/2\pi')
ylabel('Frequency, {\it f} (GHz)')
ax = gca;
ax.FontSize = 14;
ax.LineWidth = 1;
ax.XTick = [-5:0.25:0.5];
box on
colormap copper
axis([-0.5 0.5 min(crt.freq/GHz) max(crt.freq/GHz)])
plot_style