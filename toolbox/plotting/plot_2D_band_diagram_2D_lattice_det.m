function plot_2D_band_diagram_2D_lattice_det(crt, name, links1, links2, phi1, phi2)

N = crt.N_orders;
M = 2*N+1;

SS = crt.compid(name).sparam_sweep;

N_ports = size(SS,1)/M;

all_ports = [1:N_ports];
all_ports_num = max(all_ports);
all_FLoquet_ports = [1:M*all_ports_num];
all_Floquet_ports_as_matrix = reshape(all_FLoquet_ports, M, all_ports_num);


I = eye(M,M);
O = zeros(M,M);

detM = zeros(numel(phi1), numel(phi2), numel(crt.freq));
bands = zeros(numel(phi1), numel(phi2), 100);

for i_phi1 = 1:numel(phi1)
    for i_phi2 = 1:numel(phi2)
        
        BB = zeros(size(SS,1), size(SS,2));  
        
        if isempty(links1)==0
            ports1 = sort(reshape(links1, numel(unique(links1)),1));
            Floquet_ports1_as_matrix = all_Floquet_ports_as_matrix(:,ports1);
            for i_link1 = 1:size(links1,1)
                from_port1 = links1(i_link1,1);
                to_port1 = links1(i_link1,2);
                from_Floquet_ports1 = all_Floquet_ports_as_matrix(:,from_port1);
                to_Floquet_ports1 = all_Floquet_ports_as_matrix(:,to_port1);
                % Establishing in-out mode correspondence
                BB(to_Floquet_ports1,from_Floquet_ports1) = I*exp(-1j*phi1(i_phi1));
                BB(from_Floquet_ports1,to_Floquet_ports1) = I*exp(1j*phi1(i_phi1));
            end % for
        end
        
        if isempty(links2)==0
            ports2 = sort(reshape(links2, numel(unique(links2)),1));
            Floquet_ports2_as_matrix = all_Floquet_ports_as_matrix(:,ports2);
            for i_link2 = 1:size(links2,1)
                from_port2 = links2(i_link2,1);
                to_port2 = links2(i_link2,2);            
                from_Floquet_ports2 = all_Floquet_ports_as_matrix(:,from_port2);
                to_Floquet_ports2 = all_Floquet_ports_as_matrix(:,to_port2);
                % Establishing in-out mode correspondence
                BB(to_Floquet_ports2,from_Floquet_ports2) = I*exp(-1j*phi2(i_phi2));
                BB(from_Floquet_ports2,to_Floquet_ports2) = I*exp(1j*phi2(i_phi2));
            end % for
        end
        
        
        for i_freq = 1:numel(crt.freq)
            detM(i_phi1,i_phi2,i_freq) = -log(abs(det(SS(:,:,i_freq)-BB)));
        end % for
        [~,locs] = findpeaks(squeeze(detM(i_phi1,i_phi2,:)));
        bands(i_phi1,i_phi2,1:numel(locs)) = crt.freq(locs);

    end % for
end % for


X = zeros(numel(bands),1);
Y = zeros(numel(bands),1);
Z = zeros(numel(bands),1);
i = 1;
for i_band = 1:size(bands,3)
    for i_phi1 = 1:numel(phi1)
        for i_phi2 = 1:numel(phi2)
            X(i) = phi1(i_phi1);
            Y(i) = phi2(i_phi2);
            Z(i) = bands(i_phi1,i_phi2,i_band);
            i = i+1;
        end % for
    end
end

figure('Color','w','Position',[360 120 560 500])
scatter3(X/(2*pi),Y/(2*pi),Z/1e9,6,Z/1e9,'filled');
xlabel('{\itk_xa_x}/{2\pi}')
ylabel('{\itk_ya_y}/{2\pi}')
zlabel('Frequency, {\itf} (GHz)')
title('Band diagram')
ax = gca;
ax.LineWidth = 1;
ax.FontSize = 14;
ax.Position = [0.1500 0.1500 0.75 0.770];
ax.XTick = [-0.5:0.25:0.5];
ax.YTick = [-0.5:0.25:0.5];
axis([-0.5 0.5 -0.5 0.5 min(crt.freq)/1e9 max(crt.freq)/1e9])
colormap jet
caxis([min(crt.freq)/1e9 max(crt.freq)/1e9])
view([-90 0])



figure('Color','w','Position',[360 120 560 500])
contourf(phi2/(2*pi), crt.freq/1e9, -squeeze(detM(1,:,:)).', 99, 'LineStyle','none')
colormap bone
xlabel('{\itk_ya_y}/{2\pi}')
ylabel('Frequency, {\itf} (GHz)')
title('Band diagram')
ax = gca;
ax.LineWidth = 1;
ax.FontSize = 14;
ax.Position = [0.1500 0.1500 0.75 0.770];
ax.XTick = [-0.5:0.25:0.5];
axis([-0.5 0.5 min(crt.freq)/1e9 max(crt.freq)/1e9])


% figure
% surf(dots(:,:,1));  hold on
% surf(dots(:,:,2));
% surf(dots(:,:,3));
% hold off

