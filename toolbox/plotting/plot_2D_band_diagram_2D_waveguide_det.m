function plot_2D_band_diagram_2D_waveguide_det(crt, name, links2, phi1, phi2)

N = crt.N_orders;
M = 2*N+1;

SS = crt.compid(name).sparam_sweep;

N_ports = size(SS,1)/M;

all_ports = [1:N_ports];
all_ports_num = max(all_ports);
all_FLoquet_ports = [1:M*all_ports_num];
all_Floquet_ports_as_matrix = reshape(all_FLoquet_ports, M, all_ports_num);

ports2 = sort(reshape(links2, numel(unique(links2)),1));

Floquet_ports2_as_matrix = all_Floquet_ports_as_matrix(:,ports2);

Floquet_ports2 = reshape(Floquet_ports2_as_matrix, numel(Floquet_ports2_as_matrix),1);

I = eye(M,M);
O = zeros(M,M);

detM = zeros(numel(phi1), numel(phi2), numel(crt.freq));
dots = zeros(numel(phi1), numel(phi2), 10);

for i_phi1 = 1:numel(phi1)
    for i_phi2 = 1:numel(phi2)
        
        BB = zeros(size(SS,1), size(SS,2));  
       
        for i_link2 = 1:size(links2,1)
            from_port2 = links2(i_link2,1);
            to_port2 = links2(i_link2,2);            
            from_Floquet_ports2 = all_Floquet_ports_as_matrix(:,from_port2);
            to_Floquet_ports2 = all_Floquet_ports_as_matrix(:,to_port2);
            % Establishing in-out mode correspondence
            BB(to_Floquet_ports2,from_Floquet_ports2) = I*exp(-1j*phi2(i_phi2));
            BB(from_Floquet_ports2,to_Floquet_ports2) = I*exp(1j*phi2(i_phi2));
        end % for
        
        for i_freq = 1:numel(crt.freq)
            detM(i_phi1,i_phi2,i_freq) = -log(abs(det(SS(:,:,i_freq)-BB)));
        end % for
        [~,locs] = findpeaks(squeeze(detM(i_phi1,i_phi2,:)));
        dots(i_phi1,i_phi2,1:numel(locs)) = crt.freq(locs);

    end % for
end % for


figure('Color','w','Position',[360 120 560 500])
contourf(phi2/(2*pi), crt.freq/1e9, -squeeze(detM(1,:,:)).', 99, 'LineStyle','none')
xlabel('{\itk_ya_y}/{2\pi}')
ylabel('Frequency, {\itf} (GHz)')
title('Band diagram')
ax = gca;
ax.LineWidth = 1;
ax.FontSize = 14;
ax.Position = [0.1500 0.1500 0.75 0.770];
ax.XTick = [-0.5:0.25:0.5];
axis([-0.5 0.5 min(crt.freq)/1e9 max(crt.freq)/1e9])

