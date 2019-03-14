

clear
SI_units


C_max = 10*pF;
C_min = 2*pF;

crt = FloquetCircuit();
crt.freq = linspace(0.001,3,201)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 30;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,pow2(10));
add_capacitor(crt, 'CAP', C_min + (C_max-C_min)*rectangularPulse(0,0.5,crt.freq_mod*t))

crt.analyze();

figure
plot_capacitance(crt, 'CAP', 'XUnits', 'ns', 'Mode', 'complex');

figure
subplot(2,1,1)
plot_sparam_mag(crt,'CAP','XUnits','GHz');

subplot(2,1,2)
plot_sparam_phase(crt,'CAP','XUnits','GHz','YUnits','deg','PostProcess','unwrap');
