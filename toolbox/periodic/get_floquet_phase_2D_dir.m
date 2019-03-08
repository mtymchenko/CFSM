function phi_out = get_floquet_phase_2D_dir (crt, id, links1, links2, phi_in, direction)


N = crt.N_orders;
M = 2*N+1;

SS = crt.compid(id).sparam_sweep;

N_ports = size(SS,1)/M;

all_ports = [1:N_ports];
all_ports_num = numel(all_ports);
all_FLoquet_ports = [1:M*all_ports_num];
all_Floquet_ports_as_matrix = reshape(all_FLoquet_ports, M, all_ports_num);

ports1 = sort(reshape(links1, numel(unique(links1)),1));
ports2 = sort(reshape(links2, numel(unique(links2)),1));

Floquet_ports1_as_matrix = all_Floquet_ports_as_matrix(:,ports1);
Floquet_ports2_as_matrix = all_Floquet_ports_as_matrix(:,ports2);

Floquet_ports1 = reshape(Floquet_ports1_as_matrix, numel(Floquet_ports1_as_matrix),1);
Floquet_ports2 = reshape(Floquet_ports2_as_matrix, numel(Floquet_ports2_as_matrix),1);

II = eye(M,M);

if direction == 1

    phi_out = zeros(2*M*size(links1,1), numel(crt.freq));

    for i_freq = 1:numel(crt.freq)

        BB = zeros(size(SS,1),size(SS,2));

        for i_link2 = 1:size(links2,1)
            from_port2 = links2(i_link2,1);
            to_port2 = links2(i_link2,2);
            from_Floquet_ports2 = all_Floquet_ports_as_matrix(:,from_port2);
            to_Floquet_ports2 = all_Floquet_ports_as_matrix(:,to_port2);
            % Establishing in and out mode correspondence
            BB(to_Floquet_ports2, from_Floquet_ports2) = II*exp(-1j*phi_in);
            BB(from_Floquet_ports2, to_Floquet_ports2) = II*exp(1j*phi_in);
        end % for

        % Computing CFSM
        SS11 = SS(Floquet_ports1, Floquet_ports1, i_freq);
        SS12 = SS(Floquet_ports1, Floquet_ports2, i_freq);
        SS21 = SS(Floquet_ports2, Floquet_ports1, i_freq);
        SS22 = SS(Floquet_ports2, Floquet_ports2, i_freq);
        BB22 = BB(Floquet_ports2, Floquet_ports2);

        DD = SS11 + SS12*((BB22-SS22)\SS21);

        all_ports1 = setdiff(all_ports, links2(:));
        all_ports1_num = numel(all_ports1);
        all_FLoquet_ports1 = [1:M*all_ports1_num];
        all_Floquet_ports1_as_matrix = reshape(all_FLoquet_ports1, M, all_ports1_num);

        to_ports1 = [];
        from_ports1 = [];
        for i_link1 = 1:size(links1,1)
            to_ports1 = [to_ports1, find(links1(i_link1,1)==all_ports1)];
            from_ports1 = [from_ports1, find(links1(i_link1,2)==all_ports1)];
        end


        from_Floquet_ports1 = all_Floquet_ports1_as_matrix(:,from_ports1);
        to_Floquet_ports1 = all_Floquet_ports1_as_matrix(:,to_ports1);

        II1 = eye(size(DD));


        MM1 = [];
        for i_from_port1 = 1:size(from_Floquet_ports1,2)
            MM1 = [MM1, DD(:,from_Floquet_ports1(:,i_from_port1)), -II1(:,from_Floquet_ports1(:,i_from_port1))];
        end 


        MM2 = [];
        for i_to_port1 = 1:size(to_Floquet_ports1,2)
            MM2 = [MM2, II1(:,to_Floquet_ports1(:,i_to_port1)), -DD(:,to_Floquet_ports1(:,i_to_port1))];
        end


        MM = MM1\MM2;

        phi_out(:,i_freq) = 1j*log(eig(MM));

    end
    
elseif direction == 2
    
    phi_out = zeros(2*M*size(links2,1), numel(crt.freq));

    for i_freq = 1:numel(crt.freq)
    
        BB = zeros(size(SS,1),size(SS,2));

        for i_link1 = 1:size(links1,1)
            from_port1 = links1(i_link1,1);
            to_port1 = links1(i_link1,2);
            from_Floquet_ports1 = all_Floquet_ports_as_matrix(:,from_port1);
            to_Floquet_ports1 = all_Floquet_ports_as_matrix(:,to_port1);
            % Establishing in and out mode correspondence
            BB(to_Floquet_ports1, from_Floquet_ports1) = II*exp(-1j*phi_in);
            BB(from_Floquet_ports1, to_Floquet_ports1) = II*exp(1j*phi_in);
        end % for

        % Computing CFSM
        SS11 = SS(Floquet_ports1, Floquet_ports1, i_freq);
        SS12 = SS(Floquet_ports1, Floquet_ports2, i_freq);
        SS21 = SS(Floquet_ports2, Floquet_ports1, i_freq);
        SS22 = SS(Floquet_ports2, Floquet_ports2, i_freq);
        BB11 = BB(Floquet_ports1, Floquet_ports1);

        DD = SS22 + SS21*((BB11-SS11)\SS12);

        all_ports2 = setdiff(all_ports, links1(:));
        all_ports2_num = numel(all_ports2);
        all_FLoquet_ports2 = [1:M*all_ports2_num];
        all_Floquet_ports2_as_matrix = reshape(all_FLoquet_ports2, M, all_ports2_num);

        to_ports2 = [];
        from_ports2 = [];
        for i_link2 = 1:size(links2,1)
            to_ports2 = [to_ports2, find(links2(i_link2,1)==all_ports2)];
            from_ports2 = [from_ports2, find(links2(i_link2,2)==all_ports2)];
        end


        from_Floquet_ports2 = all_Floquet_ports2_as_matrix(:,from_ports2);
        to_Floquet_ports2 = all_Floquet_ports2_as_matrix(:,to_ports2);

        II1 = eye(size(DD));


        MM1 = [];
        for i_from_port2 = 1:size(from_Floquet_ports2,2)
            MM1 = [MM1, DD(:,from_Floquet_ports2(:,i_from_port2)), -II1(:,from_Floquet_ports2(:,i_from_port2))];
        end


        MM2 = [];
        for i_to_port2 = 1:size(to_Floquet_ports2,2)
            MM2 = [MM2, II1(:,to_Floquet_ports2(:,i_to_port2)), -DD(:,to_Floquet_ports2(:,i_to_port2))];
        end


        MM = MM1\MM2;

        phi_out(:,i_freq) = 1j*log(eig(MM));

    end % for
    
end % if
    
    
end % fun


