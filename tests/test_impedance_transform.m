

clear
SI_units

Z0 = 50*ohm;
Z0_new = 10*ohm;

N_paths = 4;
delay = 0.25;



crt = FloquetCircuit();
crt.freq = linspace(0.5, 1.5, 50)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 32;  % number of Floquet orders [-N..+N]
crt.Z0 = Z0;
add_Npath_filter(crt, 'NPF1', 50*pF, N_paths, delay);
crt.analyze();


crt2 = FloquetCircuit();
crt2.freq = linspace(0.5, 1.5, 50)*GHz;   % frequency range
crt2.freq_mod = 1*GHz;    % modulation frequency
crt2.N_orders = 32;  % number of Floquet orders [-N..+N]
crt2.Z0 = Z0_new;
add_Npath_filter(crt2, 'NPF2', 50*pF, N_paths, delay);
crt2.analyze();



%%
N = crt.N_orders;
M = 2*N+1;

% recompute S-matrix for Z0_new reference impedance at both ports
SS = crt.get_scattering_matrix('NPF1', [Z0_new,Z0_new]*ohm);

SS11dB = mag2db(squeeze(abs(SS(N+1, N+1, :))));
SS21dB = mag2db(squeeze(abs(SS(M+N+1, N+1, :))));

% Compare with results for Z0
figure
plot_sparam_mag(crt2, 'NPF2','XUnits','GHz'); hold on
plot(crt.freq/GHz, SS11dB); 
plot(crt.freq/GHz, SS21dB); hold off
axis([min(crt.freq)/GHz max(crt.freq)/GHz -40 0])





