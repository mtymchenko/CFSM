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


function plot_current(crt, id, port, varargin)

p = inputParser;
addOptional(p, 'XUnits', 's', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})))
addOptional(p, 'YUnits', 'A', @(x) any(validatestring(x, {'aA','fA','pA','nA','uA','mA','A'})))
addOptional(p, 'Mode', 'real', @(x) any(validatestring(x, {'real','imag','complex'})))

N_optional_args = nargin-3;

if N_optional_args >= 1 && isnumeric(varargin{1})
    t = varargin{1};
    if  N_optional_args >= 2 && isnumeric(varargin{2})
        freq_id = varargin{2};
        parse(p, varargin{3:end})
    else
        parse(p, varargin{2:end})
    end 
else
    t = linspace(0,1./crt.freq_mod, 1000);
    freq_id = 1;
    parse(p, varargin{:})
end

x_unit_factor = get_unit_factor(p.Results.XUnits);
y_unit_factor = get_unit_factor(p.Results.YUnits);

current = get_current(crt, id, port, t);

if freq_id>size(current,1)
    error(['There is only ',num2str(size(current,1)),' solutions for element "',crt.compid(compid).name,'"'])
end % if

if strcmp(p.Results.Mode, 'real') 
    plt = plot(t/x_unit_factor, real(current(freq_id,:))/y_unit_factor, 'LineWidth', 1.5);
    l = legend('Re');
elseif strcmp(p.Results.Mode, 'imag')
    plt = plot(t/x_unit_factor, imag(current(freq_id,:))/y_unit_factor, 'LineWidth', 1.5);
    l = legend('Im');
elseif strcmp(p.Results.Mode, 'complex')
    plt = plot(t/x_unit_factor, [real(current(freq_id,:)); imag(current(freq_id,:))]/y_unit_factor, 'LineWidth', 1.5);
    l = legend('Re','Im');
end
xlabel(['Time, {\itt} (', p.Results.XUnits ,')'])
ylabel(p.Results.YUnits)
title(['Current, i_{',num2str(port),'}(t)'])

end % fun