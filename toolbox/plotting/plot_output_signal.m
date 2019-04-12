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


function [plt, l] = plot_output_signal(crt, id, port, t, varargin)

p = inputParser;
addOptional(p, 'XUnits', 's', @(x) any(validatestring(x, {'as','fs','ps','ns','us','ms','s'})))
addOptional(p, 'YUnits', 'auto', @(x) any(validatestring(x, {'auto','normalized'})))
addOptional(p, 'Mode', 'real', @(x) any(validatestring(x, {'real','imag','complex'})))
parse(p, varargin{:});

x_unit_factor = get_unit_factor(p.Results.XUnits);
X = t/x_unit_factor;

output_signal = get_output_signal(crt, id, port, t);

if strcmp(p.Results.YUnits, 'auto') 
    Y = output_signal;
elseif strcmp(p.Results.YUnits, 'normalized')
    % TODO: realize normalization
    Y = output_signal;
end

if strcmp(p.Results.Mode, 'real') 
    plt = plot(X, real(Y), 'LineWidth', 1.5);
elseif strcmp(p.Results.Mode, 'imag')
    plt = plot(X, imag(Y), 'LineWidth', 1.5);
    l = legend('Im');
elseif strcmp(p.Results.Mode, 'complex')
    plt = plot(X, [real(Y); imag(Y)], 'LineWidth', 1.5);
    l = legend('Re','Im');
end
xlabel(['Time, {\itt} (', p.Results.XUnits ,')'])
ylabel('Amplitude')
title(['Output power wave, a_{',num2str(port),'}(t)'])

end % fun