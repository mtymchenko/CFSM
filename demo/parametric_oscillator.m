clear
SI_units

C0 = 15*pF;
L = 1.7*nH;
dC = 5*pF;

crt = FloquetCircuit();
crt.freq = linspace(0.001,3,301)*GHz;
crt.freq_mod = 2*GHz;
crt.N_orders = 1; 


t = linspace(0, 1./crt.freq_mod, 2^10);
C = C0 + dC*cos(2*pi*crt.freq_mod*t);

add_capacitor(crt, 'CAP', C)
add_inductor(crt, 'IND', L);
add_pin(crt, 'PIN');

connect_by_ports(crt, 'PARAMETRIC', {'PIN','IND','CAP'}, {[2,3,5], [4,6,0]});

crt.analyze();


figure
plot_sparam_mag(crt, 'PARAMETRIC', {'S(1,1)'}, -1:1, 0, 'XUnits', 'GHz');
