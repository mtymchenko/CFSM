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


function plot_input_voltage(varargin)

x_unit = 1;
y_unit = 1;

x_unit_label = 's';
y_unit_label = 'V';

narginchk(3,9);

crt = varargin{1};
compid = varargin{2};
port = varargin{3};

if nargin >=4
    t = varargin{4};
else
    t = linspace(0,1./crt.freq_mod, 1000);
end

if nargin >= 5
    freq_id = varargin{5};
else
    freq_id = 1;
end

if nargin >= 6
    for iarg = 6:1:nargin
        if strcmp(varargin{iarg}, 'XUnits')
            [x_unit, x_unit_label] = get_SI_unit(varargin{iarg+1});
        elseif strcmp(varargin{iarg}, 'YUnits')
            [y_unit, y_unit_label] = get_SI_unit(varargin{iarg+1});
        end
    end    
end % switch

voltage = get_voltage(crt, compid, port, t);

if freq_id>size(voltage,1)
    error(['There is only ',num2str(size(voltage,1)),' solutions for element "',crt.compid(compid).name,'"'])
end % if


plot(t/x_unit, [real(voltage(freq_id,:)); imag(voltage(freq_id,:))]/y_unit, 'LineWidth', 1.5);
xlabel(['Time, {\itt} (',x_unit_label,')'])
ylabel(y_unit_label)
title(['Voltage, v_{',num2str(port),'}(t)'])
legend('Re','Im')

end % fun