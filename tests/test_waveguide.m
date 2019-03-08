

clear
SI_system

GHz = 1e9;
nH = 1e-9;
ohm = 1;
c0 = 2.998e8;
mm = 1e-3;
wp=10e10;
wmod=.1*GHz;
lambdap=2*pi*c0/wp;
lambdamod=2*pi*c0/wmod;
lenz=lambdap*2;
lout=.8*lambdamod/4;
lengthout=lambdap;
cap0=3*10^-14;
deltacap=.9*cap0;

eps=@(om) 8.85e-12*(1-omp^2/om^2);

crt = FloquetCircuit();
crt.freq = linspace(9,11,301)*GHz;   % frequency range
crt.freq_mod = wmod;    % modulation frequency
crt.N_orders = 5;  % number of Floquet orders [-N..+N]
crt.Z0 = 50*ohm;

v_phase_handle = @(om) c0./sqrt(1-wp^2./om.^2);
Z= @(om) 50*ohm./sqrt(1-wp^2./om.^2);

t = linspace(0,1./crt.freq_mod,1024);
add_tline(crt, 'TLINEenz', lenz/2, v_phase_handle, Z)
add_tline(crt, 'TLINEout', lengthout, @(om) c0, 60*ohm)
add_capacitor(crt, 'CAP1', cap0 + deltacap*cos(crt.freq_mod*t))
add_capacitor(crt, 'CAP2', cap0 + deltacap*cos(crt.freq_mod*t+pi/2))

connect_in_series(crt, 'enzCAP', {'TLINEenz','CAP1','TLINEenz','TLINEout','TLINEenz','CAP2','TLINEenz'})

crt.analyze();

figure
plot_sparam_mag_db(crt, 'enzCAP');