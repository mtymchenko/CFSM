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

function eval_excitation(varargin)
crt = varargin{1};
switch nargin
    case 1
        compid = [];
        scope = 'all';
    case 2
        compid = varargin{2};
        scope = 'none';
    case 3
        compid = varargin{2};
        scope = varargin{3};
    otherwise
        error('Wrong number of input parameters');
end % switch

if isempty(compid)
    for compid = 1:numel(crt.comp)
        if ~isempty(crt.comp{compid})
            if strcmp(crt.comp{compid}.component_type, 'circuit')
                crt.comp{compid}.is_blackbox = 0;
            end % if
        end % if
    end % for
else
    cmp = crt.compid(compid);
    parent_id = crt.get_parent_id(crt.get_compid_by_name(cmp.name));
    if numel(parent_id)==1
        crt.compid(parent_id).is_blackbox = 0;
        eval_excitation(crt, crt.compid(parent_id).name);
    end % if
    switch scope
        case 'all'
            if strcmp(cmp.component_type, 'circuit')
                if ~isempty(cmp.children)
                    for ichild = 1:numel(cmp.children)
                        eval_excitation(crt, crt.compid(cmp.children(ichild)).name, 'all')
                    end % for
                end % if 
            end % if
        case 'none'
            % do nothing
        otherwise
            error(['Invalid "scope value']);
    end % switch
end % if
end % fun