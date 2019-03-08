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


function plot_stored_energy(varargin)

x_unit = 1;
y_unit = 1;

x_unit_label = 'Hz';
y_unit_label = 'J';

narginchk(2,11);

crt = varargin{1};
compid = varargin{2};

if nargin >=3
    t = varargin{3};
else
    t = linspace(0,1./crt.freq_mod, 1000);
end % if

if nargin >= 4
    freq_id = varargin{4}; 
else
    freq_id = 1;
end % if

if nargin >= 5
    for iarg = 5:1:nargin
        if strcmp(varargin{iarg}, 'XUnits')
            [x_unit, x_unit_label] = get_SI_unit(varargin{iarg+1});
        elseif strcmp(varargin{iarg}, 'YUnits')
            [y_unit, y_unit_label] = get_SI_unit(varargin{iarg+1});
        end
    end    
end % if

energy = get_stored_energy(crt, compid, t);

if freq_id>size(energy,1)
    error(['There is only ',num2str(size(energy,1)),' solutions for element "',crt.compid(compid).name,'"'])
end % if


plot(t/x_unit, energy(freq_id,:)/y_unit, 'LineWidth', 1.5);
xlabel(['Time, {\itt} (',x_unit_label,')'])
ylabel(y_unit_label)
if strcmp(crt.compid(compid).component_type, 'capacitor')
    title('Stored electric energy, w_e(t)')
elseif strcmp(crt.compid(compid).component_type, 'inductor')
    title('Stored magnetic, w_m(t)')
else
    title('Stored energy, w(t)')
end
end % fun