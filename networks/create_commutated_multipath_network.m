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

function create_commutated_multipath_network(crt, name, multi_block_name, N_paths, t_delay)

global ohm

R_min = 0*ohm;
R_max = 1e6*ohm;

T = 1/crt.freq_mod; % time period [s]
w = T/N_paths; % pulse width [s]
D = [-3*T:T:3*T]+w/2; % pulse shifts in a pulse train [s]
td = T*t_delay/(2*pi);

t = linspace(0,T,pow2(12));
paths_names = cell(1, N_paths);

for i = 1:N_paths

    cap_name = ['CAP',num2str(i),'_',name];
    add_capacitor(crt, cap_name, C);
    make_shunt_T(crt, ['SHUNT_',cap_name], {cap_name})
    
    switch1_name = ['SWA',num2str(i),'_',name];
    switch2_name = ['SWB',num2str(i),'_',name];
    
    add_resistor(crt, switch1_name, R_min + R_max*(1-pulstran(t-(i-1)*w,D,'rectpuls',w)) );
    add_resistor(crt, switch2_name, R_min + R_max*(1-pulstran(t-(i-1)*w+td,D,'rectpuls',w)) );
    
    paths_names{i} = ['PATH',num2str(i),'_',name];
    connect_in_series(crt, paths_names{i}, {switch1_name, ['SHUNT_',cap_name], switch2_name});
end


% connect_in_parallel(crt, name, paths_names);


for i = [2:N_paths]
    % Combining all paths
    if N_paths == 2
        connect_in_parallel(crt, name, {['PATH1_',name], ['PATH2_',name]});
    else
        if i == 2
            % Connect first two paths
            connect_in_parallel(crt, ['PATHS1-2_',name], {['PATH1_',name], ['PATH2_',name]})
        elseif i == N_paths
            % If all paths are already connected - this is an N-path filter
            connect_in_parallel(crt, name, {['PATHS1-',num2str(i-1),'_',name], ['PATH',num2str(i),'_',name]});
        else
            % Or keep connecting
            connect_in_parallel(crt, ['PATHS1-',num2str(i),'_',name], {['PATHS1-',num2str(i-1),'_',name], ['PATH',num2str(i),'_',name]});
        end
    end
end


