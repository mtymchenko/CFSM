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
% *********************************************************************
% Creates N-path filter with shunt capacitances C in each branch
%
%   Ideal N-path filter:
%       add_Npath_filter(crt, name, C, N_paths, delay) 
% 
%   With fine rise- and fall-time and noise:
%      add_Npath_filter(crt, name, C, N_paths, delay, ...
%          'RiseTime', 10e-12, ...
%          'FallTime', 10e-12, ...
%          'Noise', normrnd(0, 3e-12))
%

function add_Npath_filter(crt, name, C, N_paths, delay, varargin)

p = inputParser;
addOptional(p, 'MinResistance', 0, @(x) isnumeric(x) );
addOptional(p, 'MaxResistance', 1e6, @(x) isnumeric(x) );
addOptional(p, 'RiseTime', 0, @(x) isnumeric(x) );
addOptional(p, 'FallTime', 0, @(x) isnumeric(x) );
addOptional(p, 'Noise', 0, @(x) isnumeric(x) );
parse(p, varargin{:});

R_min = p.Results.MinResistance;
R_max = p.Results.MaxResistance;
w_noise = p.Results.Noise;
t_rise = p.Results.RiseTime;
t_fall = p.Results.FallTime;

T = 1/crt.freq_mod;
w = T/N_paths; 
t_delay = T*delay;

t = linspace(0,T,pow2(12));
paths_names = cell(1, N_paths);

for n = 1:N_paths
    cap_name = ['CAP',num2str(n),'_',name];
    add_capacitor(crt, cap_name, C);
    make_shunt_T(crt, ['SHUNT_',cap_name], {cap_name})
    
    switch1_name = ['SWITCH_A',num2str(n),'_',name];
    switch2_name = ['SWITCH_B',num2str(n),'_',name];
    
    f1t = 1-pulstran(t-(n-1)*w, [-1:1]*T, 'trapezoid', 0, w+w_noise, t_rise, t_fall);
    f2t = 1-pulstran(t-(n-1)*w-t_delay, [-1:1]*T, 'trapezoid', 0, w+w_noise, t_rise, t_fall);
        
    add_resistor(crt, switch1_name, R_min + R_max*f1t );
    add_resistor(crt, switch2_name, R_min + R_max*f2t );
    
    paths_names{n} = ['PATH',num2str(n),'_',name];
    connect_in_series(crt, paths_names{n}, {switch1_name, ['SHUNT_',cap_name], switch2_name});
end


% connect_in_parallel(crt, name, paths_names);


for n = [2:N_paths]
    % Combining all paths
    if N_paths == 2
        connect_in_parallel(crt, name, {['PATH1_',name], ['PATH2_',name]});
    else
        if n == 2
            % Connect first two paths
            connect_in_parallel(crt, ['PATHS1-2_',name], {['PATH1_',name], ['PATH2_',name]})
        elseif n == N_paths
            % If all paths are already connected - this is an N-path filter
            connect_in_parallel(crt, name, {['PATHS1-',num2str(n-1),'_',name], ['PATH',num2str(n),'_',name]});
        else
            % Or keep connecting
            connect_in_parallel(crt, ['PATHS1-',num2str(n),'_',name], {['PATHS1-',num2str(n-1),'_',name], ['PATH',num2str(n),'_',name]});
        end
    end
end

end


