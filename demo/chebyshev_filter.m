

clear
addpath(genpath('../../CFSM_v0.8'))
SI_system

% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = linspace(0,3,300)*GHz;
crt.freq_mod = 1*GHz;
crt.N_orders = 0;

% Creating circuit elements
% and adding elements to circuit as components

add_capacitor(crt, 'CAP', 3.262*pF);
add_inductor(crt, 'IND1', 11.311*nH);
add_inductor(crt, 'IND2', 16.853*nH);

make_shunt_T(crt, 'SHUNT_CAP', {'CAP'});

connect_in_series(crt, 'CHEBFILTER', {'IND1','SHUNT_CAP','IND2','SHUNT_CAP','IND1'})


crt.analyze();


plot_sparam_mag_db(crt,'CHEBFILTER');
axis([min(crt.freq)/GHz max(crt.freq)/GHz -50 0])
