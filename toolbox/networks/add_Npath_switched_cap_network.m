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

function add_Npath_switched_cap_network(crt, name, C, N_paths, delay)


R_min = 3;
R_max = 1e6;

T = 1/crt.freq_mod; % time period [s]
w = T/N_paths; % pulse width [s]
D = [-3*T:T:3*T]; % pulse shifts in a pulse train [s]
td = T*delay/(2*pi);

t = linspace(0,T,pow2(12));
paths_names = cell(1, N_paths);


for i = 1:N_paths

    cap_name = ['CAP',num2str(i),'_',name];
    add_capacitor(crt, cap_name, C);
    make_shunt_T(crt, ['SHUNT_',cap_name], {cap_name})
    
    switch1_name = ['SWA',num2str(i),'_',name];
    switch2_name = ['SWB',num2str(i),'_',name];
    
    w_noise1 = normrnd(0, 3e-12);
    w_noise2 = normrnd(0, 3e-12);
    
    t_rise = 10e-12;
    t_fall = 10e-12;

    sw1_modfun = 1-pulstran(t-(i-1)*w, D, 'trapezoid', 0, w+w_noise1, t_rise, t_fall);
    sw2_modfun = 1-pulstran(t-(i-1)*w-td, D, 'trapezoid', 0, w+w_noise2, t_rise, t_fall);
        
    add_resistor(crt, switch1_name, R_min + R_max*sw1_modfun );
    add_resistor(crt, switch2_name, R_min + R_max*sw2_modfun );
    
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


