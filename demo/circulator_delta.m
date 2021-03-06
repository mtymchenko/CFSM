

clear
SI_units


C0 = 14.3*pF;
C1 = 0.56*C0;
L = 3.3*nH;
R = 777*ohm;


% Creating circuit and setting params
crt = FloquetCircuit();
crt.freq = linspace(0.6,0.9,301)*GHz;
crt.freq_mod = 0.230*GHz;
crt.N_orders = 1;


t = linspace(0, 1/crt.freq_mod, pow2(12)); % length(t) should be the power of 2

add_capacitor(crt,'VCAP1', C0+C1*cos(2*pi*crt.freq_mod*t));
add_capacitor(crt,'VCAP2', C0+C1*cos(2*pi*crt.freq_mod*t-2*pi/3));
add_capacitor(crt,'VCAP3', C0+C1*cos(2*pi*crt.freq_mod*t-4*pi/3));

add_inductor(crt,'IND', L);
add_resistor(crt,'RES', R);

connect_in_parallel(crt, 'BRANCH1', {'VCAP1','IND','RES'})
connect_in_parallel(crt, 'BRANCH2', {'VCAP2','IND','RES'})
connect_in_parallel(crt, 'BRANCH3', {'VCAP3','IND','RES'})

connect_as_delta(crt, 'CIRCULATOR', {'BRANCH1','BRANCH2','BRANCH3'})

crt.analyze();


figure
plot_sparam_mag(crt,'CIRCULATOR', {'S(2,1)','S(3,2)','S(1,3)','S(1,2)','S(2,3)','S(3,1)'},...
    'XUnits','GHz',...
    'YUnits','dB');


