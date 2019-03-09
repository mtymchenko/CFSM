function plot_3D_band_diagram_2D_lattice(crt, id, links1, links2, phi2)

N = crt.N_orders;
M = 2*N+1;

phi1 = zeros(numel(phi2), 2*M*size(links1,1), numel(crt.freq));
  
for i_phi2 = 1:numel(phi2)
    phi1(i_phi2,:,:) = get_floquet_phase_2D(crt, id, links1, links2, phi2(i_phi2));
end % for

X = zeros(numel(phi1),1);
Y = zeros(numel(phi1),1);
Z = zeros(numel(phi1),1);
i = 1;
for i_freq = 1:numel(crt.freq)
    for i_phi2 = 1:numel(phi2)
        for i_band = 1:size(phi1,2)
            X(i) = phi1(i_phi2, i_band, i_freq);
            Y(i) = phi2(i_phi2);
            Z(i) = crt.freq(i_freq);
            i = i+1;
        end % for
    end
end

X(abs(imag(X))/pi>1e-7) = NaN;
Y(abs(imag(X))/pi>1e-7) = NaN;
Z(abs(imag(X))/pi>1e-7) = NaN;

scatter3(real(X)/(2*pi),Y/(2*pi),Z/1e9,6,Z/1e9,'filled');
xlabel('{\itk_xa_x}/{2\pi}')
ylabel('{\itk_ya_y}/{2\pi}')
zlabel('Frequency, {\itf} (GHz)')
title('Band diagram')
ax = gca;
ax.LineWidth = 1;
ax.FontSize = 14;
% ax.Position = [0.1500 0.1500 0.75 0.770];
% ax.XTick = [-0.5:0.25:0.5];
% ax.YTick = [-0.5:0.25:0.5];
% axis([-0.5 0.5 -0.5 0.5 min(crt.freq)/1e9 max(crt.freq)/1e9])
colormap jet
% caxis([min(crt.freq)/1e9 max(crt.freq)/1e9])
view([-90 0])