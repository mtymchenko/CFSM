

clear
SI_units


%% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = 1.4*GHz;
crt.freq_mod = 1*GHz;
crt.N_orders = 32;
crt.Z0 = 50*ohm;

R_min = 0;
R_max = 1e8*ohm;

T = 1/crt.freq_mod; % time period [s]
w = T/4; % pulse width [s]
D = [-3*T:T:3*T]+w/2; % pulse shifts in a pulse train [s]
td = T/2;


t1 = linspace(0,T,pow2(9));


add_resistor(crt, 'SWITCH1', R_min + R_max*(1-pulstran(t1, D,'rectpuls',w)) );
add_resistor(crt, 'SWITCH2', R_min + R_max*(1-pulstran(t1-td, D,'rectpuls',w)) );

add_capacitor(crt, 'CAP', 0.5*pF);
make_shunt_T(crt, 'SHUNT_CAP', {'CAP'});

connect_in_series(crt, 'SWITCHED_CAP', {'SWITCH1','SHUNT_CAP','SWITCH2'});


Vin = -1j*V;

apply_voltage_spectrum(crt, 'SWITCHED_CAP', 1, Vin);


crt.analyze();



%%

t = linspace(0, 5*T, 1e3);

v = Vin*exp(1j*2*pi*crt.freq*t);


figure('Name','CAP current')
subplot(2,1,1)
plot_current(crt, 'SWITCH1', 1, t, ...
    'XUnits', 'ns', ...
    'YUnits', 'mA');
grid on
subplot(2,1,2)
plot_resistance(crt, 'SWITCH1', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm'); hold on
plot_resistance(crt, 'SWITCH2', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm'); hold off
grid on


figure('Name','CAP voltage')
subplot(2,1,1)
plot_voltage(crt, 'CAP', 1, t, ...
    'XUnits', 'ns', ...
    'YUnits', 'V'); hold on
plot(t/ns, real(v), 'LineWidth', 1.5, 'Color','r'); hold off
grid on
subplot(2,1,2)
plot_resistance(crt, 'SWITCH1', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm'); hold on
plot_resistance(crt, 'SWITCH2', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm'); hold off
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
plot_stored_energy(crt, 'CAP', 1, t, ...
    'XUnits', 'ns', ...
    'YUnits', 'pJ')
title('CAP')
grid on
subplot(2,1,2)
plot_resistance(crt, 'SWITCH1', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm'); hold on
plot_resistance(crt, 'SWITCH2', t, ...
    'XUnits', 'ns', ...
    'YUnits', 'Mohm'); hold off
grid on




