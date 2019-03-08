function make_lattice(crt, name, id, ports1, ports2, n1, n2)

N = crt.N_orders;
M = 2*N+1;

SS = crt.compid(id).sparam_sweep;

N_ports = size(SS,1)/M;

nPorts1 = numel(ports1);
nPorts2 = numel(ports2);

nPorts = nPorts1+nPorts2;

all_ports = [1:N_ports];
all_ports_num = max(all_ports);

left_ports = ports1(1:nPorts1/2);
right_ports = ports1(nPorts1/2+[1:nPorts1/2]);
top_ports = ports2(1:nPorts2/2);
bottom_ports = ports2(nPorts2/2+[1:nPorts2/2]);
% all_FLoquet_ports = [1:M*all_ports_num];
% all_Floquet_ports_as_matrix = reshape(all_FLoquet_ports, M, all_ports_num);
% 
% Floquet_ports1_as_matrix = all_Floquet_ports_as_matrix(:,ports1);
% Floquet_ports2_as_matrix = all_Floquet_ports_as_matrix(:,ports2);
% 
% left_Floquet_as_matrix = Floquet_ports1_as_matrix(:,1:nPorts1/2);
% right_Floquet_as_matrix = Floquet_ports1_as_matrix(:,nPorts1/2+[1:nPorts1/2]);
% top_Floquet_as_matrix = Floquet_ports1_as_matrix(:,1:nPorts2/2);
% bottom_Floquet_as_matrix = Floquet_ports1_as_matrix(:,nPorts2/2+[1:nPorts2/2]);



for i2 = 1:n2
    compids1{i2} = crt.get_compid_by_name(id);
end % for

links1 = [];
links2 = [];
for i1 = 1:n1
    for i2 = 1:n2-1
        links1 = [links1;...
            (i1-1)*nPorts + [(i2-1)*nPorts+flip(right_ports); i2*nPorts+left_ports].'];
    end% for
%     connect_by_ports(crt,['LATTICE_ROW',num2str(i1)], compids1, links1)
end % for

links1
links2

% for i1 = 1:n1
%     compids2{i1} = crt.get_compid_by_name(['LATTICE_ROW',num2str(i1)]);  
% end % for
% 
% connect_by_ports(crt,['LATTICE_ROW',num2str(i1)], compids1, links1)

