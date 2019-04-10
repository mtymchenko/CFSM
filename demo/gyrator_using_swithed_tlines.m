

clear
SI_units

% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = linspace(0.001,4,100)*GHz; % frequency range [Hz]
crt.freq_mod = 1*GHz; % modulation frequency [Hz]
crt.N_orders = 32; % number of Fourier harmonics [1]
crt.Z0 = 50*ohm; % reference impedance [ohm]


R_min = 0;
R_max = 1e6*ohm;

T = 1/crt.freq_mod; % time period [s]
w = T/2; % pulse width [s]
D = [-3*T:T:3*T]+w/2; % pulse shifts in a pulse train [s]
td = T/2;


t = linspace(0,T,pow2(12));

% Switches on branch1
add_resistor(crt, 'SWITCH_A1', R_min + R_max*(1-pulstran(t,D,'rectpuls',w)) );
add_resistor(crt, 'SWITCH_B1', R_min + R_max*(1-pulstran(t+T/4,D,'rectpuls',w)) );

% Switches on branch2
add_resistor(crt, 'SWITCH_A2', R_min + R_max*(1-pulstran(t+T/2,D,'rectpuls',w)) );
add_resistor(crt, 'SWITCH_B2', R_min + R_max*(1-pulstran(t+3*T/4,D,'rectpuls',w)) );


vp_handle = @(om) c0/sqrt(3); % phase velocity vp(omega) handle 
length = vp_handle(2*pi*crt.freq_mod)/crt.freq_mod/4; % quarter-wavelength section

add_tline(crt, 'TLINE', length, vp_handle, 100*ohm)


connect_in_series(crt, 'BRANCH1', {'SWITCH_A1','TLINE','SWITCH_B1'});
connect_in_series(crt, 'BRANCH2', {'SWITCH_A2','TLINE','SWITCH_B2'});

add_pin(crt,'PIN');

connect_by_ports(crt, 'GYRATOR', {'PIN','BRANCH1','BRANCH2','PIN'},...
    {[2,3,5], [4,6,7]});

crt.analyze();


%%
figure
subplot(2,1,1)
plot_sparam_mag(crt,'GYRATOR',{'S(1,1)','S(2,1)','S(1,2)','S(2,2)'},...
    'XUnits', 'GHz',...
    'YUnits', 'dB');

subplot(2,1,2)
plot_sparam_phase(crt,'GYRATOR',{'S(1,1)','S(2,1)','S(1,2)','S(2,2)'},...
    'XUnits', 'GHz',...
    'YUnits', 'rad',...
    'PostProcess','unwrap');




