

clear
locale
SI_system


C = 25*pF;    % max capacitance


crt = FloquetCircuit();
crt.freq = linspace(0.001,4,80)*GHz;
crt.freq_mod = 1*GHz;
crt.N_orders = 32;

add_Npath_filter(crt,'NPFILTER', C, 4, 0);


crt.analyze();

%%
figure
plot_sparam_mag_db(crt, 'NPFILTER');
axis([0 4 -80 0])

figure
plot_sparam_phase(crt, 'NPFILTER');