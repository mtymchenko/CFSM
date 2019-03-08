

clear

locale

GHz = 1e9;
nH = 1e-9;


R_max = 5000000;
R_min = 0;

crt = FloquetCircuit();
crt.freq = linspace(0.001,3,301)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 2;  % number of Floquet orders [-N..+N]


t = linspace(0,1./crt.freq_mod,1024);
add_resistor(crt, 'RES', R_min + (R_max-R_min)*rectangularPulse(0,0.5,crt.freq_mod*t))

crt.analyze();



t2 = linspace(0,3./crt.freq_mod,1024);


figure
plot_sparam_mag_db(crt,'RES');
