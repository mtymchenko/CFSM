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


function process_excitation(crt, compid)

cmp = crt.get_comp(compid);
parent_id = crt.get_parent_id(crt.get_compid_by_name(cmp.name));
if numel(parent_id)==1
    crt.get_comp(parent_id).is_blackbox = 0;
    process_excitation(crt, crt.get_comp(parent_id).name);
end % if
switch scope
    case 'all'
        if strcmp(cmp.type, 'circuit')
            if ~isempty(cmp.children)
                for ichild = 1:numel(cmp.children)
                    process_excitation(crt, crt.get_comp(cmp.children(ichild)).name, 'all')
                end % for
            end % if
        end % if
    case 'none'
        % do nothing
    otherwise
        error(['Invalid "scope value']);
end % switch
end % fun