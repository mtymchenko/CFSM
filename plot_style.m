% Composite Floquet Scattering Matrix (CFSM) Circuit Simulator
%
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


% Setting styles for plots
try
    ax = gca;
%     ax.Position = [0.17 0.17 0.70 0.73];
    ax.LineWidth = 1;
    ax.FontSize = 16;
    ax.FontName = 'Arial';
    ax.XMinorTick = 'on';
    ax.YMinorTick = 'on';
catch
    % do nothing
end


try
    f = gcf;
	f.Color = 'w';
% %     f.Position = [260 120 540 340];
    f.FontName = 'Arial';
catch
end

% Setting styles for legend
try
    l = legend;
    l.FontSize = 14;
    l.FontName = 'Arial';
catch
    % do nothing
end
