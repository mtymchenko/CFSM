

clear
SI_system


%% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = [1,2]*GHz;
crt.freq_mod = 1*GHz;
crt.N_orders = 32;
crt.Z0 = 50*ohm;

R_min = 0;
R_max = 1e8*ohm;

T = 1/crt.freq_mod; % time period [s]
w = T/2; % pulse width [s]
D = [-3*T:T:3*T]+w/2; % pulse shifts in a pulse train [s]
td = T/2;


t1 = linspace(0,T,pow2(9));

% resistors on branch1
add_resistor(crt, 'RES', R_min + R_max*(1-pulstran(t1,D,'rectpuls',w)) );


add_inductor(crt, 'IND', 10*nH);
add_capacitor(crt, 'CAP', 5*pF);
connect_in_series(crt, 'RLC', {'RES','IND','CAP'});


excite_port(crt, 'RLC', 1, 1*V);

eval_excitation(crt, 'CAP')

crt.analyze();



%%

t = linspace(0, 6*T, 1e3);


figure('Name','CAP current')
subplot(2,1,1)
plot_current(crt, 'CAP', 1, t, 1, ...
    'XUnits', 'ns', ...
    'YUnits', 'mA');
grid on
subplot(2,1,2)
plot_resistance(crt, 'RES', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm');
grid on


figure('Name','CAP current')
subplot(2,1,1)
plot_current(crt, 'CAP', 2, t, 1, ...
    'XUnits', 'ns', ...
    'YUnits', 'mA');
grid on
subplot(2,1,2)
plot_resistance(crt, 'RES', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm');
grid on
 

figure('Name','CAP voltage')
subplot(2,1,1)
plot_voltage(crt, 'CAP', 1, t, 1, ...
    'XUnits', 'ns', ...
    'YUnits', 'V'); hold on
grid on
subplot(2,1,2)
plot_resistance(crt, 'RES', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm');
grid on


figure('Name','CAP voltage')
subplot(2,1,1)
plot_voltage(crt, 'CAP', 2, t, 1, ...
    'XUnits', 'ns', ...
    'YUnits', 'V');
grid on
subplot(2,1,2)
plot_resistance(crt, 'RES', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm');
grid on



%%

figure('Name','CAP current spectrum')
plot_current_spectrum(crt, 'CAP', 1, 1,...
    'XUnits', 'GHz', ...
    'YUnits', 'mA', ...
    'PlotType', 'stem');
axis([-10 10 -inf inf])
grid on

figure('Name','CAP current spectrum')
plot_voltage_spectrum(crt, 'CAP', 1, 1,...
    'XUnits', 'GHz', ...
    'YUnits', 'V', ...
    'PlotType', 'stem');
grid on
axis([-10 10 -inf inf])


%%



figure
subplot(2,1,1)
plot_stored_energy(crt, 'CAP', t, 1,'XUnits', 'ns', 'YUnits', 'pJ')
grid on
subplot(2,1,2)
plot_resistance(crt, 'RES', t, 'XUnits', 'ns', 'YUnits', 'Mohm');
grid on


figure
subplot(2,1,1)
plot_stored_energy(crt, 'IND', t, 1,'XUnits', 'ns', 'YUnits', 'pJ')
grid on
subplot(2,1,2)
plot_resistance(crt, 'RES', t, 'XUnits', 'ns', 'YUnits', 'Mohm');
grid on







