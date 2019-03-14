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
%
%
% ***********************************************************************
% Connects networks in parallel
%                _______
%               |       |
%           .---|   1   |---.
%           |   |_______|   |
%     1 o---|    _______    |---o 2
%           |   |       |   |
%           .---|   2   |---.
%           |   |_______|   | 
%           :               :
%                  ...
%
%
%       connect_in_parallel(crt, name, children)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%
%       connect_in_parallel(crt, name, children, N_internal)
%           crt[obj] - circuit object
%           name[string] - name of a subcircuit
%           children[cell of [string]] - circuits comprising this subcircuit
%           N_internal[int] - USE WITH CAUTION: number of harmonics to use when connecting
%           (external number of harmonics remains the same)
%
% ***********************************************************************

% function connect_in_parallel(crt, name, compids)
% 
% N_comps = numel(compids);
% 
% if N_comps>2
%     
%     if mod(N_comps,2)==0
%         branch_names = {};
%         i_branch = 1;
%         for i_comp = 1:2:N_comps
%             branch_names{i_branch} = [name,'_PATHS',num2str(i_comp),'-',num2str(i_comp+1)];
%             connect_in_parallel(crt, branch_names{i_branch}, {compids{i_comp}, compids{i_comp+1}});
%             i_branch = i_branch +1;
%         end
%         compids.'
%         branch_names.'
%         [name,'_PATHS1-',num2str(N_comps)]
%         connect_in_parallel(crt, [name,'_PATHS1-',num2str(N_comps)], branch_names);
%         
%     elseif mod(N_comps,2)==1
% 
%         branch_names = {};
%         i_branch = 1;
%         for i_comp = 1:2:N_comps-1
%             branch_names{i_branch} = [name,'_PATHS',num2str(i_comp),'-',num2str(i_comp+1)];
%             connect_in_parallel(crt, branch_names{i_branch}, {compids{i_comp}, compids{i_comp+1}});
%             i_branch = i_branch +1;
%         end
%         connect_in_parallel(crt, [name,'_PATHS1-',num2str(N_comps)], {branch_names{:}, compids{end}});
%     end
% 
% elseif N_comps==2
%     
%     add_pin(crt, [name,'_PIN1'])
%     add_pin(crt, [name,'_PIN2'])
% 
%     links{1} = [2,3,5];
%     links{2} = [4,6,7];
%     
%     connect_by_ports(crt, name, {[name,'_PIN1'], compids{:}, [name,'_PIN2']}, links);
% 
% else
%     error('Connecting only 1 element')
% end

function connect_in_parallel(varargin)

crt = varargin{1};
name = varargin{2};
compids = varargin{3};

add_pin(crt, ['PIN1_',name])
add_pin(crt, ['PIN2_',name])

links{1} = 2;
links{2} = 2+2*numel(compids)+1;
for icomp = 1:numel(compids)
    links{1} = [links{1}, 3+2*(icomp-1)];
    links{2} = [links{2}, 4+2*(icomp-1)];
end

switch nargin
    case 3
        connect_by_ports(crt, name, {['PIN1_',name], compids{:}, ['PIN2_',name]}, links);
    case 4
         connect_by_ports(crt, name, {['PIN1_',name], compids{:}, ['PIN2_',name]}, links, varargin{4});
    otherwise
        error('Wrong number of input parameters');
end



