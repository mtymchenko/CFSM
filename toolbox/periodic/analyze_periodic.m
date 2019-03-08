function [ka_bands_p, ka_bands_m, Z_Bloch_p, Z_Bloch_m] = analyze_periodic(crt, name, m, n)

N = crt.N_orders;
M1 = numel(m);

S11 = crt.compid(name).sparam(1,1);
S12 = crt.compid(name).sparam(1,2);
S21 = crt.compid(name).sparam(2,1);
S22 = crt.compid(name).sparam(2,2);

S11 = S11(N+1+m,N+1+n,:);
S12 = S12(N+1+m,N+1+n,:);
S21 = S21(N+1+m,N+1+n,:);
S22 = S22(N+1+m,N+1+n,:);

O = zeros(size(S11,1));
I = eye(size(O));

ka_bands = zeros(2*M1,numel(crt.freq));
ka_bands_p = NaN(size(ka_bands));
ka_bands_m = NaN(size(ka_bands));

V_bands_p = zeros(M1,2*M1,numel(crt.freq));
I_bands_p = zeros(M1,2*M1,numel(crt.freq));
V_bands_m = zeros(M1,2*M1,numel(crt.freq));
I_bands_m = zeros(M1,2*M1,numel(crt.freq));

Z_Bloch_p = V_bands_p;
Z_Bloch_m = V_bands_m;

for ifreq = 1:numel(crt.freq)
    MM = [S12(:,:,ifreq), O; S22(:,:,ifreq), -I]\...
        [I, -S11(:,:,ifreq); O, -S21(:,:,ifreq)];
    [W,D] = eig(MM);
    
    ka = 1j*log(diag(D));
    
%     ka.'
%     ka
%     ka(abs(imag(ka))<1e-3)
%     ka_angle = round(rad2deg(angle(ka))*1e3)/1e3;
    
%     ka(abs(ka_angle)==90) = NaN;
%     ka(abs(ka)>pi) = NaN;
%     ka(abs(ka)<pi) = real(ka(abs(ka)<pi));

    
   
%     ka1 = zeros(size(ka));
%     for i_ka=1:numel(ka)
%         if abs(imag(ka(i_ka)))>abs(real(ka(i_ka)))
%             ka1(i_ka) = 0;
%         else
%             ka1(i_ka) = ka(i_ka);
%         end
%     end
        
%     ka(abs(real(ka))==pi) = NaN;
    
    ka(abs(imag(ka))>abs(real(ka))) = NaN;
    ka(real(ka)==pi) = NaN;
    
%     for ika = 1:numel(ka)
%         if real(ka(ika))>0
%             ka_bands_p(ika,ifreq) = ka(ika);
%         elseif real(ka(ika))<0
%             ka_bands_m(ika,ifreq) = ka(ika);
%             ka_bands_m(ika,ifreq)
%         else
%             ka_bands_p(ika,ifreq) = NaN;
%             ka_bands_m(ika,ifreq) = NaN;
%         end
%     end
    ka_bands_p(imag(ka)<0,ifreq) = ka(imag(ka)<0);
    ka_bands_m(imag(ka)>0,ifreq) = ka(imag(ka)>0);
    
%     ka_bands_p.'
    
    W_bands_p = W*diag(real(ka_bands_p(:,ifreq))>0); 
    W_bands_m = W*diag(real(ka_bands_m(:,ifreq))<0);

    b_bands_p = W_bands_p(1:M1,:);
    a_bands_p = W_bands_p(M1+[1:M1],:);
    b_bands_m = W_bands_m(1:M1,:);
    a_bands_m = W_bands_m(M1+[1:M1],:); 
    
    V_bands_p(:,:,ifreq) = (a_bands_p+b_bands_p)*sqrt(crt.Z0);
    I_bands_p(:,:,ifreq) = (a_bands_p-b_bands_p)/sqrt(crt.Z0);
    V_bands_m(:,:,ifreq) = (a_bands_m+b_bands_m)*sqrt(crt.Z0);
    I_bands_m(:,:,ifreq) = (a_bands_m-b_bands_m)/sqrt(crt.Z0);
    
    Z_Bloch_p(:,:,ifreq) =  V_bands_p(:,:,ifreq)./I_bands_p(:,:,ifreq);
    Z_Bloch_m(:,:,ifreq) =  V_bands_m(:,:,ifreq)./I_bands_m(:,:,ifreq);
end

% ka_bands_p(real(ka_bands_p)==0) = NaN;
% ka_bands_m(real(ka_bands_m)==0) = NaN;

% ka_bands_p(abs(imag(ka_bands_p))>0.1) = NaN;
% ka_bands_m(abs(imag(ka_bands_m))>0.1) = NaN;