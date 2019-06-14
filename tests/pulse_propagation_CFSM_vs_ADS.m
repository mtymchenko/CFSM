

clear
SI_units


f0 = 2*GHz; % pulse center frequency
w = 1*ns;
t0 = 4*ns;
t = linspace(0, 10*ns, pow2(12));

v = exp(-0.5*(t-t0).^2/w^2).*exp(1j*2*pi*f0*t);
Vn = fft(v)/length(v);
df = 1/max(t);
freq = [0:df:3*GHz];
Vn = Vn(1:numel(freq));


%% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = freq;
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


add_resistor(crt, 'SWITCH', R_min + R_max*(1-pulstran(t1, D,'rectpuls',w)) );

add_capacitor(crt, 'CAP1', 5*pF);
add_capacitor(crt, 'CAP2', 20*pF);

connect_in_series(crt, 'SWITCHED_CAP', {'SWITCH','CAP2'});

make_shunt_T(crt, 'SHUNT_SWITCHED_CAP', {'SWITCHED_CAP'});

connect_in_series(crt, 'NETWORK', {'CAP1','SHUNT_SWITCHED_CAP'});



apply_voltage_spectrum(crt, 'NETWORK', 1, Vn(1:numel(freq)));


crt.analyze();


%%


figure('Name','CAP current')
subplot(2,1,1)
plot_voltage(crt, 'NETWORK', 1, t, 'XUnits', 'ns', 'YUnits', 'V');
title('CAP current')
grid on
subplot(2,1,2)
plot_resistance(crt, 'SWITCH', t, 'XUnits', 'ns', 'YUnits', 'Mohm')
grid on


figure('Name','CAP voltage')
subplot(2,1,1)
plot_voltage(crt, 'NETWORK', 2, t, 'XUnits', 'ns', 'YUnits', 'V'); hold on
plot(t/ns, real(v), 'LineWidth', 1.5, 'Color','r'); hold off
grid on
subplot(2,1,2)
plot_resistance(crt, 'SWITCH', t, 'XUnits', 'ns', 'YUnits', 'Mohm')
grid on




%%

% figure('Name','CAP current spectrum')
% plot_current_spectrum(crt, 'CAP', 1, 1, 'XUnits', 'GHz', 'YUnits', 'mA', 'PlotType', 'stem');
% axis([-10 10 -inf inf])
% grid on
% 
% figure('Name','CAP current spectrum')
% plot_voltage_spectrum(crt, 'CAP', 1, 1, 'XUnits', 'GHz', 'YUnits', 'V', 'PlotType', 'stem');
% grid on
% axis([-10 10 -inf inf])
% 

%%




