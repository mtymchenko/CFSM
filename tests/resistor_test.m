

clear
SI_units


R_max = 50*ohm;
R_min = 10*ohm;

crt = FloquetCircuit();
crt.freq = linspace(0.001,3,301)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 30;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,1024);
add_resistor(crt, 'RES', R_min + (R_max-R_min)*rectangularPulse(0,0.5,crt.freq_mod*t))

crt.analyze();


figure
plot_resistance(crt,'RES')

figure
subplot(2,1,1)
plot_sparam_mag(crt,'RES','XUnits','GHz');

subplot(2,1,2)
plot_sparam_phase(crt,'RES','XUnits','GHz');
