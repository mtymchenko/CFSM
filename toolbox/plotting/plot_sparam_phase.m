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
%
%
% **********************************************************************
% Plots phase of S-params of the element
%
%   Args:
%       crt [handle] (required) - circuit handle
%
%       id [string] (required) -  name of the element
%
%       SParams [cell] (optional) - which S-params to plot. 
%           Example: {'S(1,2)','S(1,1)'}
%           Plots all S-parameters by default. 
%
%       m [int array] (optional) - harmonic(s) at the destination port(s).
%           Default is 0.
%
%       n [int array] (optional) - harmonic(s) at the source port(s).
%           Default is 0.
%
%   Params:
%
%       'XUnits': 'Hz'(default) |'kHz'|'MHz'|'GHz'|'THz'|'PHz'
%
%       'YUnits': 'rad'(default)|'deg'|'pi'
%
%       'PostProcess':  'auto'(default)|'unwrap'
%

function [plt, l] = plot_sparam_phase(crt, id, varargin)


narginchk(2,9)

p = inputParser;
addRequired(p, 'crt', @(x) isobject(x) );
addRequired(p, 'id', @(x) ischar(x) || @(x) isnumeric(x) );
addOptional(p, 'SParams', [], @(x) iscell(x));
addOptional(p, 'm', 0, @(x) isnumeric(x) );
addOptional(p, 'n', 0, @(x) isnumeric(x) );
addOptional(p, 'XUnits', 'Hz', @(x) any(validatestring(x, {'Hz','kHz','MHz','GHz','THz','PHz'})) );
addOptional(p, 'YUnits', 'rad', @(x) any(validatestring(x, {'rad','deg','pi'})) );
addOptional(p, 'PostProcess', 'auto', @(x) any(validatestring(x, {'auto','unwrap'})) );
parse(p, crt, id, varargin{:})

crt = p.Results.crt;
cmp = crt.compid(p.Results.id);
sparams = p.Results.SParams;
m = p.Results.m;
n = p.Results.n;
x_units = p.Results.XUnits;
y_units = p.Results.YUnits;
postprocess = p.Results.PostProcess;

if isempty(sparams)
    sparams = cmp.list_all_sparams();
end

x_unit_factor = get_unit_factor(x_units);

X = crt.freq;
Y = zeros(numel(sparams)*numel(m)*numel(n), numel(X));

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

if strcmp(postprocess, 'unwrap')
    Y = unwrap(Y,[],2);
end

if strcmp(y_units, 'deg')
    plt = plot(X/x_unit_factor, rad2deg(Y), 'LineWidth', 1.5);
    ylabel(['Phase (deg)']);
elseif strcmp(y_units, 'rad')
    plt = plot(X/x_unit_factor, Y, 'LineWidth', 1.5);
    ylabel(['Phase (rad)']);
elseif strcmp(y_units, 'pi')
    plt = plot(X/x_unit_factor, Y/pi, 'LineWidth', 1.5);
    ylabel(['Phase (rad/\pi)']);
end
xlabel(['Frequency, f (', p.Results.XUnits ,')']);
l = legend(legend_entries{:});
l.Location = 'SouthEast';
axis tight
grid on
end



