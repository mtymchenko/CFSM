

clear
SI_units

L_max = 10*nH;
L_min = 2*nH;

crt = FloquetCircuit();
crt.freq = linspace(0.01,3,301)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 20;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,pow2(11));
add_inductor(crt, 'IND', L_min + (L_max-L_min)*rectangularPulse(0,0.5,crt.freq_mod*t))

crt.analyze();

figure
plot_inductance(crt,'IND', 'XUnits', 'ns')

figure
subplot(2,1,1)
plot_sparam_mag(crt,'IND','XUnits','GHz');

subplot(2,1,2)
plot_sparam_phase(crt,'IND','XUnits','GHz');