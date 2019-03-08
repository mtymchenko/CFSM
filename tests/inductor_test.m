

clear
SI_system

L_max = 10*nH;
L_min = 9*nH;

crt = FloquetCircuit();
crt.freq = linspace(0.01,3,301)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 10;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,pow2(11));
add_inductor(crt, 'IND', L_min + (L_max-L_min)*rectangularPulse(0,0.5,crt.freq_mod*t))

crt.analyze();

figure
plot_sparam_mag(crt,'IND', {'S(1,1)','S(2,1)'}, 'XUnits', 'GHz');

figure
plot_sparam_phase(crt,'IND', {'S(1,1)','S(2,1)'}, 'XUnits', 'GHz','YUnits', 'deg');