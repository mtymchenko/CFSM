

clear
SI_units


C = 50*pF;
N_paths = 4;


crt = FloquetCircuit();
crt.freq = linspace(0.001,4,200)*GHz;
crt.freq_mod = 1*GHz;
crt.N_orders = 16;


add_Npath_filter(crt,'NPFILTER', C, N_paths, 1/N_paths);


crt.analyze();

%%
figure
subplot(2,1,1)
plot_sparam_mag(crt, 'NPFILTER', 'XUnits','GHz', 'YUnits','dB');

subplot(2,1,2)
plot_sparam_phase(crt, 'NPFILTER', 'XUnits','GHz', 'YUnits', 'deg');