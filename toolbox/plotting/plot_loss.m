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


function plot_loss(crt, name, m, n)


S11 = crt.sparam(name,1,1);
S12 = crt.sparam(name,1,2);
S21 = crt.sparam(name,2,1);
S22 = crt.sparam(name,2,2);

% PLOTTING

N = crt.N_orders;

GHz = 1e9;

A21 = 1-abs(squeeze(S11(N+1+m,N+1+n,:))).^2-abs(squeeze(S21(N+1+m,N+1+n,:))).^2;
A12 = 1-abs(squeeze(S22(N+1+m,N+1+n,:))).^2-abs(squeeze(S12(N+1+m,N+1+n,:))).^2;

% A21
plot(crt.freq/GHz,A21,...
    'Color','k',...FFmn
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none'); hold on
% S12
plot(crt.freq/GHz,A12,...
    'Color','k',...
    'LineWidth',2,...
    'LineStyle','--',...
    'Marker','none');

axis([min(crt.freq)/GHz max(crt.freq)/GHz 0 1])

ax = gca;
ax.LineWidth = 1;
ax.FontSize = 14;
ax.LineWidth = 1;
ax.Position = [0.1200 0.1500 0.78 0.770];

title('Losses')
xlabel('Frequency, {\itf} (GHz)')

l = legend('A_{21}','A_{12}');
l.Location = 'SouthEast';
l.FontSize = 12;
l.Box = 'on';

hold off
grid off