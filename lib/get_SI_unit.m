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

function [factor, label] = get_SI_unit(unit)

if ismember(unit(1), 'TGMkmunpfa')
    prefix = unit(1);
    unit = unit(2:end);
else
    prefix = [];
    factor = 1;
end % if

if ~isempty(prefix)
    if  strcmp(prefix, 'P');  factor = 1e15;
    elseif  strcmp(prefix, 'T');  factor = 1e12;
    elseif  strcmp(prefix, 'G');  factor = 1e9;
    elseif  strcmp(prefix, 'M');  factor = 1e6;
    elseif  strcmp(prefix, 'k');  factor = 1e3;
    elseif  strcmp(prefix, 'm');  factor = 1e-3;
    elseif  strcmp(prefix, 'u');  factor = 1e-6;
    elseif  strcmp(prefix, 'n');  factor = 1e-9;
    elseif  strcmp(prefix, 'p');  factor = 1e-12;
    elseif  strcmp(prefix, 'f');  factor = 1e-15;
    elseif  strcmp(prefix, 'a');  factor = 1e-18;
    else; factor = 1;
    end % if
end % if

if  strcmp(unit, 'Hz') || strcmp(unit, 'Hertzs'); label = [prefix,'Hz'];
elseif  strcmp(unit, '1') || strcmp(unit, '1'); label = [prefix,''];
elseif  strcmp(unit, 'ohm') || strcmp(unit, 'Ohms'); label = [prefix,'\Omega'];
elseif  strcmp(unit, 'V') || strcmp(unit, 'Volts'); label = [prefix,'V'];
elseif  strcmp(unit, 'F') || strcmp(unit, 'Farads'); label = [prefix,'F'];
elseif  strcmp(unit, 'H') || strcmp(unit, 'Henrys'); label = [prefix,'H'];
elseif  strcmp(unit, 'A') || strcmp(unit, 'Amperes'); label = [prefix,'A'];
elseif  strcmp(unit, 'W') || strcmp(unit, 'Watts'); label = [prefix,'W'];
elseif  strcmp(unit, 'J') || strcmp(unit, 'Joules'); label = [prefix,'J'];
elseif  strcmp(unit, 's') || strcmp(unit, 'sec') || strcmp(unit, 'seconds'); label = [prefix,'s'];
elseif  strcmp(unit, 'dB') || strcmp(unit, 'decibels'); label = [prefix,'dB'];
else
    error('Unknown units');
end % if

end