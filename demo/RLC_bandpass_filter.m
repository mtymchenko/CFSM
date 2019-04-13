clear
SI_units % Load SI units system
  
R = 1*ohm;
C = 50*pF;
L = 3*nH;
 
crt = FloquetCircuit();
crt.freq = linspace(0.001,1,300)*GHz;
 
add_resistor(crt, 'RES', R); 
add_inductor(crt, 'IND', L);
add_capacitor(crt, 'CAP', C);
add_pin(crt, 'PIN');
 
connect_by_ports(crt, 'RLC_BANDPASS', {'RES','IND','CAP','PIN'}, {[2,3,7,5], [4,6,0]});

crt.analyze();

figure
subplot(2,1,1)
plot_sparam_mag(crt, 'RLC_BANDPASS', {'S(1,1)','S(2,1)'}, 'XUnits', 'GHz');
subplot(2,1,2)
plot_sparam_phase(crt, 'RLC_BANDPASS', {'S(1,1)','S(2,1)'}, 'XUnits', 'GHz');