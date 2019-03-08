

clear
addpath(genpath('../../../CFSM_v0.8'))
SI_system

crt = FloquetCircuit();
crt.freq = linspace(0.001,5,301)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 0;  % number of Floquet orders [-N..+N]
crt.Z0 = 50*ohm;

v_phase_handle = @(om) c0/3;
length = 50*mm;

add_tline(crt, 'TLINE', length, v_phase_handle, 100*ohm);


crt.analyze();

figure
plot_sparam_mag_db(crt, 'TLINE');
