

clear
SI_units

crt = FloquetCircuit();
crt.freq = linspace(0.001,5,301)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 0;  % number of Floquet orders [-N..+N]
crt.Z0 = 50*ohm;

v_phase_handle = @(om) c0/3;
length = 50*mm;

add_tline(crt, 'TLINE', length, v_phase_handle, 200*ohm);


crt.analyze();


figure
subplot(2,1,1)
plot_sparam_mag(crt,'TLINE','XUnits','GHz');

subplot(2,1,2)
plot_sparam_phase(crt,'TLINE','XUnits','GHz');
