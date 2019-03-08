

clear
addpath(genpath('../../../CFSM_v0.8'))
SI_system


C0 = 14.3*pF;    % max capacitance
C1 = 0.56*C0;    % min capacitance
L = 3.3*nH;
freq_mod = 0.230*GHz;    % modulation frequency
R = 2*pi*750e6*L*50;
freq = linspace(0.6,0.9,301)*GHz;   % frequency range
N = 1;  % number of Floquet orders [-N..+N]

% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = freq;
crt.freq_mod = freq_mod;
crt.N_orders = N;


t = linspace(0,1/freq_mod,pow2(12));

add_capacitor(crt,'VCAP1', C0+C1*cos(2*pi*freq_mod*t));
add_capacitor(crt,'VCAP2', C0+C1*cos(2*pi*freq_mod*t-2*pi/3));
add_capacitor(crt,'VCAP3', C0+C1*cos(2*pi*freq_mod*t-4*pi/3));

add_inductor(crt,'IND', L);
add_resistor(crt,'RES', R);

connect_in_parallel(crt, 'BRANCH1', {'VCAP1','IND','RES'})
connect_in_parallel(crt, 'BRANCH2', {'VCAP2','IND','RES'})
connect_in_parallel(crt, 'BRANCH3', {'VCAP3','IND','RES'})

connect_as_delta(crt, 'CIRCULATOR', {'BRANCH1','BRANCH2','BRANCH3'})

crt.analyze();


figure
plot_sparam_mag_db(crt,'CIRCULATOR', {'S(2,1)','S(3,2)','S(1,3)','S(1,2)','S(2,3)','S(3,1)'});
