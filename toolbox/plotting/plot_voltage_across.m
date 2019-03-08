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


function plot_voltage_across(varargin)
global ns V
crt = varargin{1};
compid = varargin{2};
t = varargin{3};
switch nargin
    case 3
        freq_id = 1;
    case 4
        freq_id = varargin{5};
    otherwise
        error('Wrong number of input parameters');
end % switch

voltage = get_voltage_across(crt, compid, t);

if freq_id>size(voltage,1)
    error(['There is only ',num2str(size(voltage,1)),' solutions for element "',crt.compid(compid).name,'"'])
end % if

plot(t/ns, real(voltage(freq_id,:))/V, 'LineWidth', 1.5);
xlabel('Time, {\itt} (ns)')
ylabel('Voltage, v({\itt}) (V)')
plot_style
end % fun