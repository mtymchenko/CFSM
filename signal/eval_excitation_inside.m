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


function eval_excitation_inside(varargin)
crt = varargin{1};
parent_id = varargin{2};
flag = varargin{3};
if strcmp(crt.compid(parent_id).component_type,'circuit')
    switch flag
        case 0
            crt.compid(parent_id).is_blackbox = 1;
        case 1
            crt.compid(parent_id).is_blackbox = 0;
        otherwise
            error('Value can be 0 or 1')
    end
    for arg = 4:nargin
        if ischar(varargin{arg})
            switch varargin{arg}
                case 'propagate'
                    value = varargin{arg+1};
                    switch value
                        case 1
                            if strcmp(crt.compid(parent_id).component_type,'circuit')
                                for ichild = 1:numel(crt.compid(parent_id).children)
                                    child_id = crt.compid(parent_id).children(ichild);
                                    eval_excitation_inside(crt, child_id, flag, 'propagate', value);
                                end % for
                            end % if
                        case 0
                            %
                        otherwise
                            error('Wrong value for "propagate" parameter. Can be 0 or 1')
                    end % switch
            end % switch
        end % if
    end % for
end
end