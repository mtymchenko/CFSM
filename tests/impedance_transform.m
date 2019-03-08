

clear
SI_system

crt = FloquetCircuit();
crt.freq = linspace(0.5, 1.5, 50)*GHz;   % frequency range
crt.freq_mod = 1*GHz;    % modulation frequency
crt.N_orders = 32;  % number of Floquet orders [-N..+N]


add_Npath_filter(crt, 'NPF', 15*pF, 8, pi);
add_Npath_filter(crt, 'NPF1', 3*pF, 8, pi);

% add_resistor(crt, 'RES', 200);
% add_capacitor(crt, 'CAP', 10*pF);
% add_pin(crt, 'PIN');

% connect_by_ports(crt, 'CRT', {'RES','RES','PIN'}, {[2,3,5], [4,0]})

crt.analyze();

%%
N = crt.N_orders;
M = 2*N+1;

figure
plot_sparam_mag_db(crt, 'NPF');
axis([min(crt.freq)/GHz max(crt.freq)/GHz -40 0])

SS = crt.get_scattering_matrix('NPF', [10,10]);

SS11 = mag2db(squeeze(abs(SS(N+1, N+1, :))));
SS21 = mag2db(squeeze(abs(SS(M+N+1, N+1, :))));

figure
plot_sparam_mag_db(crt, 'NPF1'); hold on
plot(crt.freq/GHz, SS11); 
plot(crt.freq/GHz, SS21); hold off
axis([min(crt.freq)/GHz max(crt.freq)/GHz -40 0])
% ZZ = crt.get_impedance_matrix('CRT')
% YY = crt.get_admittance_matrix('CRT')





