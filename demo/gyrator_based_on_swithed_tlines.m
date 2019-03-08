

clear
addpath(genpath('../../CFSM_v0.8'))
SI_system

% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = linspace(0.01,4,50)*GHz; % frequency range [Hz]
crt.freq_mod = 1*GHz; % modulation frequency [Hz]
crt.N_orders = 32; % number of Fourier harmonics [1]
crt.Z0 = 50*ohm; % reference impedance [ohm]


R_min = 0;
R_max = 1e8*ohm;

T = 1/crt.freq_mod; % time period [s]
w = T/2; % pulse width [s]
D = [-3*T:T:3*T]+w/2; % pulse shifts in a pulse train [s]
td = T/2;


t = linspace(0,T,pow2(12));

% resistors on branch1
add_resistor(crt, 'SWA1', R_min + R_max*(1-pulstran(t,D,'rectpuls',w)) );
add_resistor(crt, 'SWB1', R_min + R_max*(1-pulstran(t+T/4,D,'rectpuls',w)) );

% resistors on branch2
add_resistor(crt, 'SWA2', R_min + R_max*(1-pulstran(t+T/2,D,'rectpuls',w)) );
add_resistor(crt, 'SWB2', R_min + R_max*(1-pulstran(t+3*T/4,D,'rectpuls',w)) );


v_phase_handle = @(om) c0/sqrt(3); 
length = v_phase_handle(2*pi*crt.freq_mod)/crt.freq_mod/4;

add_tline(crt, 'TLINE', length, v_phase_handle, 50*ohm)

connect_in_series(crt, 'BRANCH1', {'SWA1','TLINE','SWB1'});
connect_in_series(crt, 'BRANCH2', {'SWA2','TLINE','SWB2'});

add_joint(crt,'JNT3',3);

connect_by_ports(crt, 'GYRATOR', {'JNT3','BRANCH1', 'BRANCH2', 'JNT3'},...
    {[2,4], [5,8], [3,6], [7,10]});

crt.analyze();

%%
figure
plot_sparam_mag_db(crt,'GYRATOR',{'S11','S21','S12','S22'})

figure
plot_sparam_phase_deg(crt,'GYRATOR',{'S11','S21','S12','S22'})




