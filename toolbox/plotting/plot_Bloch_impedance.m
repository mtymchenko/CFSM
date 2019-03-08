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


function ax = plot_Bloch_impedance(crt, name, m, n)

[~, ~, Z_Bloch_p, Z_Bloch_m] = analyze_periodic(crt, name, m, n);
M1 = numel(m);

hold on

GHz = 1e9;

n1 = 0;
for iband = 1:size(Z_Bloch_p,2)
    Y1 = squeeze(real(Z_Bloch_p((M1-1)/2+1+n1,iband,:)));
    Y2 = squeeze(imag(Z_Bloch_p((M1-1)/2+1+n1,iband,:)));
    Y2(isnan(real(Y1))) = NaN;
    plot(crt.freq/GHz,Y1,'-r','Linewidth',1.5);
    plot(crt.freq/GHz,Y2,':r','Linewidth',1.5);
    Y3 = squeeze(real(Z_Bloch_m((M1-1)/2+1+n1,iband,:)));
    Y4 = squeeze(imag(Z_Bloch_m((M1-1)/2+1+n1,iband,:)));
    Y4(isnan(real(Y3))) = NaN;
    plot(crt.freq/GHz,Y3,'-b','LineWidth',1.5);
    plot(crt.freq/GHz,Y4,':b','LineWidth',1.5);
end
hold off
ax = gca;
ax.LineWidth = 1;
ax.FontSize = 14;
ax.YTick = [-75:25:75];
box on
axis([min(crt.freq/GHz) max(crt.freq/GHz) -75 75])
xlabel('Frequency, {\it f} (GHz)')
ylabel('ohm')
l = legend(...
        ['{\itR}^{+}_{B,{',num2str(4*n1),'}}'],...
        ['{\itX}^{+}_{B,{',num2str(4*n1),'}}'],...
        ['{\itR}^{-}_{B,{',num2str(4*n1),'}}'],...
        ['{\itX}^{-}_{B,{',num2str(4*n1),'}}']);
l.FontSize = 12;
l.Location = 'SouthEast';
l.Box = 'off';
title('Bloch impedance, {\itZ}^{\pm}_{B,{\itn}} = {\itR}^{\pm}_{B,{\itn}}+{\itjX}^{\pm}_{B,{\itn}}')

ax = gca;


