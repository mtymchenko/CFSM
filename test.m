

clear

locale

GHz = 1e9;
pF = 1e-12;


C_max = 25*pF;
C_min = 5*pF;

crt = FloquetCircuit();
crt.freq = 1*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 0;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,pow2(11));
add_capacitor(crt, 'CAP', 1*pF)

crt.analyze();

crt.compid('CAP').show_C_plot()

figure
plot_sparam_mag_db(crt,'CAP')


figure
plot_sparam_phase_deg(crt,'CAP')
