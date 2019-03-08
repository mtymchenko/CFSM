

clear
SI_system


C_max = 10*pF;
C_min = 5*pF;

crt = FloquetCircuit();
crt.freq = linspace(0.001,3,301)*GHz;   % frequency range
crt.freq_mod = 10*GHz;    % modulation frequency
crt.N_orders = 1;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,pow2(10));
add_capacitor(crt, 'CAP', C_min + (C_max-C_min)*rectangularPulse(0,0.5,crt.freq_mod*t))
% add_capacitor(crt, 'CAP', C_max);

crt.analyze();

figure
plot_sparam_mag_db(crt,'CAP');

figure
plot_sparam_phase_deg(crt,'CAP')
