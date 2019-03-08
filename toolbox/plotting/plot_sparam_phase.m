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

function [plt, l] = plot_sparam_phase(crt, id, varargin)

p = inputParser;
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'Hz','kHz','MHz','GHz','THz','PHz'})))
addOptional(p, 'YUnits', 'rad', @(x) any(validatestring(x, {'rad','deg','pi'})))
addOptional(p, 'PostProcess', 'auto', @(x) any(validatestring(x, {'auto','unwrap'})))

N_optional_args = nargin-2;

if N_optional_args >= 1 && iscell(varargin{1})
    sparams = varargin{1};
    if  N_optional_args >= 3 && isnumeric(varargin{2}) && isnumeric(varargin{3})
        m = varargin{2};
        n = varargin{3};
        parse(p, varargin{4:end})
    else
        m = 0;
        n = 0;
        parse(p, varargin{2:end})
    end 
else
    sparams = crt.compid(id).list_all_sparams();
    m = 0;
    n = 0;
    parse(p, varargin{:})
end

x_unit_factor = get_unit_factor(p.Results.XUnits);

X = crt.freq/x_unit_factor;
Y = zeros(numel(sparams)*numel(m)*numel(n), numel(crt.freq));

legend_entries = cell(numel(sparams)*numel(m)*numel(n),1);
i_curve = 1;
for i_sparam = 1:numel(sparams)
    sparam = sparams{i_sparam};
    ports = sscanf(sparam,'S(%d,%d)');
    if numel(m)==1 && numel(n)==1 && m==0 && n==0
        legend_entries{i_curve} = sprintf('S_{%d,%d}', ports(1), ports(2));
        Y(i_curve,:) = angle(squeeze(crt.compid(id).get_sparam(ports(1),ports(2),m,n)));
        i_curve = i_curve+1;
    else
        for im = 1:numel(m)
            for in = 1:numel(n)
                legend_entries{i_curve} = sprintf('S_{%d,%d} (f_{%d}, f_{%d})', ports(1), ports(2), m(im), n(in));    
                Y(i_curve,:) = angle(squeeze(crt.compid(id).get_sparam(ports(1),ports(2),m(im),n(in))));
                i_curve = i_curve+1;
            end
        end
    end
end

if strcmp(p.Results.PostProcess, 'unwrap')
    Y = unwrap(Y,[],2);
end

if strcmp(p.Results.YUnits, 'deg')
    plt = plot(X, rad2deg(Y), 'LineWidth', 1.5);
    ylabel(['Phase (deg)']);
elseif strcmp(p.Results.YUnits, 'rad')
    plt = plot(X, Y, 'LineWidth', 1.5);
    ylabel(['Phase (rad)']);
elseif strcmp(p.Results.YUnits, 'pi')
    plt = plot(X, Y/pi, 'LineWidth', 1.5);
    ylabel(['Phase (rad/\pi)']);
end
axis([min(X) max(X) -inf inf])
title('S-parameters')
xlabel(['Frequency, f (', p.Results.XUnits ,')']);
l = legend(legend_entries{:});
l.Location = 'SouthEast';
grid on
end



