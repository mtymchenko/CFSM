% Composite Floquet Scattering Matrix (CFSM) Circuit Simulator
%
% Copyright (C) 2019  Mykhailo Tymchenko
% Email: mtymchenko@utexas.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

classdef FloquetCircuit < FTCore
    
    properties (Constant)
        version = '0.82'
    end % properties
    
    
    properties
        comp % {cell-array} containing circuit components as objects
        freq % [array] frequency sweep [Hz]
        freq_mod % modulation frequency [Hz]
        N_orders % [int] how many Floquet orders to take into account [-N..N]
        Z0 % reference impedance [ohm]
        input_is_pulse
        compnames_list = {};
        compids_list = [];
        
        use_sparse_matrices = 0
        warnings_on = 0
    end % properties
    
    
    
    methods
        
        
        function self = FloquetCircuit()
            % Class constructor
            %
            fprintf('\n--- CFSM Circuit Simulator ---\n')
            fprintf(['     Version ',self.version,'\n'])
            self.comp = {}; % No components yet
            self.N_orders = 0;
            self.freq_mod = 1e6;
            self.Z0 = 50;
            
            config
            self.use_sparse_matrices = USE_SPARSE_MATRICES;
            self.warnings_on = WARNINGS_ON;
            
        end % fun
        
       
        function add(self, comp)
                       
            if ~isobject(comp)
                error('"comp" must be an object')
            end
            
            if ~self.is_unique_name(comp.name)
                if self.warnings_on
                    disp(['WARNING: Component "',comp.name,'" already exists. Overwritten.'])
                end
                comp.id = self.get_compid_by_name(comp.name);
            else
                comp.id = numel(self.comp)+1;
                self.compnames_list = [self.compnames_list(:)', {comp.name}];
                self.compids_list = [self.compids_list, comp.id];
            end
            
            comp.freq = self.freq;
            comp.omega = 2*pi*self.freq;
            comp.N_orders = self.N_orders;
            
            % Adding new component to the circuit
            self.comp{comp.id} = comp; 
            
            if strcmp(self.comp{comp.id}.type,'circuit')~=1
                % if is not circuit, run update()
                self.comp{comp.id}.update();
            else
                
                self.sort_ports(comp.name);
            end % if

        end % fun

        
        
        function out = compid(self, querry_id)
            % Returns the object self.comp{querry_id}
            %
            if isnumeric(querry_id)
                comp_id = querry_id;
            else
                comp_id = self.get_compid_by_name(querry_id);
            end % if
            
            try
                out = self.comp{comp_id};
            catch
                error(['Component "',num2str(comp_id),'" does not exist'])
            end % try
        end % fun
        
        
        
        
        function copies_names = multcopy(varargin)
            self = varargin{1};
            compid = varargin{2};
            switch nargin
                case 2
                    N_copies = 1;
                    suffix = '_COPY';
                case 3
                    N_copies = varargin{3};
                    suffix = '_COPY';
                case 4
                    N_copies = varargin{3};
                    suffix = varargin{4};
                otherwise
                    error('Wrong number of input parameters');
            end
            
            copies_names = cell(1,N_copies);
            
            for icopy = 1:N_copies
                isuffix = [suffix, num2str(icopy)];
                copies_names{icopy} = self.copycomp(self.compid(compid).name, isuffix);
            end % for

        end % fun
                 
        
        
        function analyze(self)
            % Initiates the main computation routine
            %
            
            time_start = datetime(); % Record the start time of the analysis
            fprintf(['Simulation started...\n']);
            
            % WORKAROUND: adding 1Hz to all frequencies to stabilize calculations
            self.freq = self.freq + 1;
            
            % Computing S-params
            time_freqsweep_start = datetime();
            fprintf(['Computing S-params frequency sweep...']);
            persentage_old = 0;
            persentage_new = 0;
            fprintf('%3.0f%%', persentage_old) 
            for icomp = 1:numel(self.comp)
                if ~isempty(self.comp{icomp})
                    % Initiate the component analysis
                    self.compute_sparam(icomp);
                end % if
                % Update persantage complete (increment 1%)
                persentage_old = floor(icomp/numel(self.comp)*100);
                if (persentage_old-persentage_new)>=1
                    fprintf('\b\b\b\b%3.0f%%', persentage_old);
                end % if
                persentage_new = persentage_old;
            end % for
            % Recalculate and print the progress
            time_freqsweep_finish = datetime();
            [h,m,s] = hms(time_freqsweep_finish-time_freqsweep_start);
            time_freqsweep_elapsed = [num2str(s),'s'];
            if m~=0, time_freqsweep_elapsed = [num2str(m),'m ',time_freqsweep_elapsed]; end
            if h~=0, time_freqsweep_elapsed = [num2str(h),'hr ',time_freqsweep_elapsed]; end
            fprintf(['\b\b\b\bDone!(',time_freqsweep_elapsed,')\n'])
            
            
            % Computing excitation
            time_sigprocess_start = datetime();
            fprintf(['Performing signal processing.........']);
            persentage_old = 0;
            persentage_new = 0;
            fprintf('%3.0f%%', persentage_old)
            for icomp = 1:numel(self.comp)
                if ~isempty(self.comp{icomp}.input_spectrum)
                    % Initiate the excitation analysis
                    self.compute_excitation(icomp);
                end % if
                % Update persantage complete (increment 1%)
                persentage_old = floor(icomp/numel(self.comp)*100);
                if (persentage_old-persentage_new)>=1
                    fprintf('\b\b\b\b%3.0f%%', persentage_old);
                end % if
                persentage_new = persentage_old;
            end % for
            % Recalculate and print the progress
            time_sigprocess_finish = datetime();
            [h,m,s] = hms(time_sigprocess_finish-time_sigprocess_start);
            time_sigprocess_elapsed = [num2str(s),'s'];
            if m~=0, time_sigprocess_elapsed = [num2str(m),'min ',time_sigprocess_elapsed]; end
            if h~=0, time_sigprocess_elapsed = [num2str(h),'hr ',time_sigprocess_elapsed]; end
            fprintf(['\b\b\b\bDone!(',time_sigprocess_elapsed,')\n'])
            
            
            % Done !
            fprintf(['Computation successful!\n']);
            time_finish = datetime();
            [h,m,s] = hms(time_finish-time_start);
            elapsed_time = [num2str(s),'s'];
            if m~=0, elapsed_time = [num2str(m),'m ',elapsed_time]; end
            if h~=0, elapsed_time = [num2str(h),'hr ',elapsed_time]; end
            fprintf(['Elapsed time: ',elapsed_time,'\n\n'],s);
            
        end
        
        
        
        function copy_name = copycomp(varargin)
            self = varargin{1};
            name = varargin{2};
            switch nargin
                case 2
                    suffix = '_COPY';
                case 3
                    suffix = varargin{3};
                otherwise
                    error('Wrong number of input parameters');
            end
            
            copy_name = [name, suffix];
            
            % IMPORTANT: copy() function makes a deep copy of an object handle
            self.add(copy_name, copy(self.compid(name)));
            %     parent_copy_name
            if strcmp(self.compid(copy_name).type, 'circuit')
                for ichild = 1:numel(self.compid(copy_name).children)
                    child_id = self.compid(copy_name).children(ichild);
                    child_name = self.compid(child_id).name;
                    child_copy_name = [child_name, suffix];
                    self.copycomp(self.compid(child_id).name, suffix);
                    % Overwrite old children IDs with copied children IDs
                    self.compid(copy_name).children(ichild) = self.compid(child_copy_name).id;
                end % for
            end % if
            
        end % fun
        
        
        
        
        function out = generate_name(self, type)
            % Generates a unique name for the component
            %
            switch type
                case 'capacitor',       prefix = 'CAP';
                case 'inductor',        prefix = 'IND';
                case 'resistor',        prefix = 'RES';
                case 'tline',           prefix = 'TLINE';
                case 'joint',           prefix = 'JNT';
                case 'ground',          prefix = 'GND';
                case 'circuit',         prefix = 'CRT';
                case 'phaseshifter',    prefix = 'PSH';
                case 'general',         prefix = 'GEN';
                case 'pin',             prefix = 'PIN';
                otherwise,              prefix = 'UNKNOWN';
            end % switch
            is_unique = 0; % Initial assumption that the name is not unique
            id = 1;
            while is_unique == 0
                test_name = [prefix,num2str(id)]; % try this name
                is_unique = self.is_unique_name(test_name);
                id = id + 1;
            end % while
            out = test_name;
        end % fun
        
        
        function out = is_unique_name(self, name)
            
            if ischar(name)
                if numel(self.compnames_list)~=0 && ismember(name, self.compnames_list)
                    out = 0;
                else
                    out = 1;
                end
            else
                error('Variable "name" is not a string')
            end
        end % fun
        
        
        function out = get_all_compnames(self)
            out = {};
            if numel(self.comp)>0
                % check if there is at least one component
                for icomp = 1:numel(self.comp)
                    if isempty(self.comp{icomp})~=1
                        out = {out{:}, self.comp{icomp}.name};
                    end % if
                end % for
            end % if
        end
                
        
        function out = get_compid_by_name(self, queried_name)
            % Returns object of component id with desired name
            %
            out = [];
            for compid = 1:numel(self.comp)
                if self.compid_exists(compid)
                    if strcmp(self.comp{compid}.name, queried_name)==1
                        out = compid;
                        return
                    end % if
                end % if
            end % for
            if isempty(out)
                error(['Component "',queried_name,'" does not exist'])
            end % if
        end % fun
        
        
        function out = get_parent_id(self, child_id)
            out = [];
            for compid = 1:numel(self.comp)
                if self.compid_exists(compid)
                    if strcmp(self.comp{compid}.type, 'circuit')==1
                        if ismember(child_id, self.comp{compid}.children)                           
                             out = [out, compid];
                        end % if
                    end % if
                end % if
            end % for
        end % fun
        
        function out = get_frequency_id(self, freq)
            [~,out] = min(abs(self.freq-freq));
        end
        
        
        function out = compid_exists(self, queried_compid)
            out = 0;
            if ~isempty(self.comp{queried_compid})
                out = 1;
            end
        end % fun
        
        
        function out = get_numeric_compids(self, compids)
            out = zeros(1, numel(compids));
            for icomp = 1:numel(compids)
                if isnumeric(compids{icomp})
                    if self.compid_exists(compids{icomp})
                        out(icomp) = compids{icomp};
                    else
                        error(['Component #',num2str(compids{icomp}),' does not exist']);
                    end % if
                else
                    out(icomp) = self.get_compid_by_name(compids{icomp});
                end % if
            end % for
        end % fun
        
        
        function out = port_exists(self, compid, port)
            ismember(port, self.compid(compid).ports)
            if ismember(port, self.compid(compid).ports)
                out = 1;
            else
                out = 0;
            end
        end
        
        
        function update_component(self, compid)
            cmp = self.compid(compid);
            cmp.freq = self.freq;
            cmp.freq_mod = self.freq_mod;
            cmp.omega = 2*pi*self.freq;
            cmp.omega_mod = 2*pi*self.freq_mod;
            cmp.T_mod  = 1/self.freq_mod;
            cmp.N_orders = self.N_orders;
            cmp.Z0 = self.Z0;
        end         
        
        
        
        function excite_port(self, compid, port, voltage)
            if numel(port)==1
                if numel(voltage)==1
                    input_spectrum = voltage/(2*sqrt(real(self.Z0)))*ones(1,numel(self.freq)); % power wave spectrum
                else
                    input_spectrum = voltage/(2*sqrt(real(self.Z0)));
                end % if
                self.set_input_spectrum(compid, port, input_spectrum);
            else
                error('Cannot excite more than 1 port');
            end % if
        end % fun
        
        
        
        function set_input_spectrum(self, compid, port, spectrum)
            % Assigns the input power wave signal's spectrum to a particular port
            %
            N = self.N_orders;
            M = 2*N+1;           
            % Preparing the empty input spectrum
            self.compid(compid).input_spectrum = zeros(M*self.compid(compid).N_ports, numel(self.freq));
            % Setting the input spectrum
            self.compid(compid).input_spectrum(M*(port-1)+N+1,:) = spectrum;
        end % fun
        
        
        function out = get_input_spectrum(self, compid, port)
            % Returns the m-th order input power wave signal's spectrum
            %
            N = self.N_orders;
            M = 2*N+1;
            if ~isempty(self.compid(compid).input_spectrum)
                out = self.compid(compid).input_spectrum(M*(port-1)+[1:M],:);
            else
                error('Input spectrum is empty')
            end % if
        end % fun
                       
        
        function out = get_output_spectrum(self, compid, port)
            % Returns the m-th order output signal spectrum
            %
            N = self.N_orders;
            M = 2*N+1;
            if ~isempty(self.compid(compid).output_spectrum)
                out = self.compid(compid).output_spectrum(M*(port-1)+[1:M],:);
            else
                error('Output spectrum is empty')
            end
        end % fun 
        
        
        function out = get_sparam_ground(self)
            out = -1*eye(2*self.N_orders+1);
        end % fun
        
        
        function out = get_sparam_node(self, N_ports)  
            M = 2*self.N_orders+1;
            G = inv(self.Z0*eye(N_ports-1) + self.Z0*ones(N_ports-1));
            out = zeros(M*N_ports);
            for port_to = 1:N_ports
                for port_from = 1:N_ports
                    if port_to == port_from                
                        out(M*(port_to-1)+[1:M], M*(port_from-1)+[1:M]) = eye(M)*(1-2*self.Z0*sum(sum(G,2),1));
                    else
                        SS = 2*self.Z0*sum(G,1);
                        out(M*(port_to-1)+[1:M], M*(port_from-1)+[1:M]) = eye(M)*SS(1);
                    end % if
                end % for
            end % for
        end % fun     
        
        
        function out = get_scattering_matrix(varargin)
            self = varargin{1};
            id = varargin{2};
            SS = self.compid(id).get_sparam();
            II = eye(size(SS(:,:,1)));
            M = 2*self.N_orders + 1;
            if nargin == 3
                ZZ0_old = II*self.Z0;
                Z0_new = varargin{3};
                if numel(Z0_new) == 1
                    ZZ0_new = II*Z0_new;
                elseif numel(Z0_new) == self.compid(id).N_ports
                    ZZ0_new = diag(reshape(repmat(Z0_new,M,1), self.compid(id).N_Fports,1));
                elseif numel(Z0_new) == self.compid(id).N_Fports
                    ZZ0_new = diag(Z0_new);
                end % if
                RR = (ZZ0_new-ZZ0_old)/(ZZ0_new+ZZ0_old);
                AA = sqrt(ZZ0_new/ZZ0_old)/(ZZ0_new+ZZ0_old);
                out = zeros(size(SS));
                for ifreq = 1:numel(self.freq)
                    out(:,:,ifreq) = AA\(SS(:,:,ifreq)-RR)/(II-RR*SS(:,:,ifreq))*AA;
                end
            else
                out = self.compid(id).get_sparam();
            end % if
            
        end % fun
        
        
        function out = get_impedance_matrix(self, id)
            SS = self.get_scattering_matrix(id);
            M = 2*self.N_orders+1;
            II = eye(size(SS(:,:,1)));
            ZZ0 = zeros(size(SS(:,:,1)));
            for iport = 1:self.compid(id).N_ports
                ZZ0(M*(iport-1)+[1:M], M*(iport-1)+[1:M]) = eye(M)*self.Z0; 
            end
            out = zeros(size(SS));
            for ifreq = 1:numel(self.freq)
                SSnorm = sqrt(real(ZZ0))*SS(:,:,ifreq)/sqrt(real(ZZ0));
                out(:,:,ifreq) = II/(II-SSnorm)*(conj(ZZ0)/ZZ0+SSnorm)*ZZ0;
            end
        end
        
        
        function out = get_admittance_matrix(self, id)
            ZZ = self.get_impedance_matrix(id);
            II = eye(size(ZZ(:,:,1)));
            out = II/ZZ;
        end
        
        
    end % public methods
    
    
    
    
    
    methods (Access = protected)
        
        
        function out = get_multiple_sparam_sweeps(self, compids)
            out = cell(numel(compids),1);
            for icomp = 1:numel(compids)
                compid = compids(icomp);
                out{icomp} = self.compid(compid).get_sparam();
            end % for
        end % fun
        
        
        function compute_sparam(self, compid)
            % Computes CFSMs of the component 'compid'. If it has children,
            % it computes CFSMs of all children as necessary
            %            
            cmp = self.compid(compid);
            if cmp.is_ready == 0
                self.update_component(compid);
                if strcmp(cmp.type,'circuit')
                    if ~isempty(cmp.children)
                        for ichild = 1:numel(cmp.children)
                            child_id = cmp.children(ichild);
                            % Recursive sparam computation
                            self.compute_sparam(self.compid(child_id).id);
                        end % for
                    end % if
                    self.compute_cfsm_sweep(compid);
                else
                    % If the component is a basic element
                    cmp.precompute();
                end % if
                cmp.is_ready = 1;
            end % if    
        end % fun
        
        
        function sort_ports(self, id)
            % Using the total number of physical ports, defines the total
            % number of FLoquet ports and splits them into inner and outer
            % port subsets
            %
            
            if self.is_circuit(id)
            
                N = self.N_orders;
                M = 2*N+1;
                cmp = self.compid(id); % Reference to a handle object

                cmp.N_all_ports = 0;
                cmp.N_all_Fports = 0;
                
                for child = cmp.children
                    cmp.N_all_ports = cmp.N_all_ports + self.compid(child).N_ports;
                end % for
                cmp.N_all_Fports = cmp.N_all_ports*M;
                
                cmp.all_ports = [1:cmp.N_all_ports];
                cmp.all_Fports = reshape([1:cmp.N_all_Fports], M, cmp.N_all_ports);
                
                % Finding input ports
                cmp.inner_ports = [];
                for i_link = 1:numel(cmp.links)
                    link_ports = cmp.links{i_link};
                    cmp.inner_ports = unique([cmp.inner_ports, link_ports]);
                end
                
                % Removing 0 (if it is there) from the list of inner ports, 
                % because it is reserved for the ground
                if ismember(0, cmp.inner_ports)
                    cmp.inner_ports = setxor(cmp.inner_ports, 0);
                end
                
                % All other ports are outer
                cmp.outer_ports = setxor(cmp.all_ports, cmp.inner_ports);
                cmp.N_ports = numel(cmp.outer_ports);
                cmp.ports = [1:cmp.N_ports];
                
                cmp.inner_Fports = cmp.all_Fports(:, cmp.inner_ports);
                cmp.outer_Fports = cmp.all_Fports(:,cmp.outer_ports);
                cmp.N_Fports = numel(cmp.outer_Fports);               
                cmp.Fports = reshape([1:cmp.N_Fports], M, cmp.N_ports);
            end
            
        end % fun
        
        
        function out = is_circuit(self, id)
            if strcmp(self.compid(id).type,'circuit')
                out = 1;
            else
                out = 1;
            end
        end
        
        
        function set_children_spectra(self, compid, children_input_spectrum, children_output_spectrum)
            child_ports_start_from = 0;
            cmp = self.compid(compid);
            for ichild = 1:numel(cmp.children)
                child = self.compid(cmp.children(ichild));
                % Obtain child ports as they enter the parent circuit
                child_ports = child_ports_start_from + [1:child.N_ports];
                % Obtain corresponding Floquet ports
                children_Fports = cmp.all_Fports(:,child_ports);
                % Assign input spectrum to each child
                child.input_spectrum = children_input_spectrum(children_Fports(:),:);
                % Assign output spectrum to each child
                child.output_spectrum = children_output_spectrum(children_Fports(:),:);
                child_ports_start_from = max(child_ports);
            end
        end % fun

        
        function compute_cfsm_sweep(self, compid)
        % Computes CFSM frequency sweep using FSMs of children
        %
            cmp = self.compid(compid); % handle to 'compid' object
            
            if numel(cmp.children)==1 && isempty(cmp.links)
                % If there is only one child, there is nothing to connect,
                % so, just using its S-params
                cmp.sparam_sweep = cmp.sparam();
            else
                % Preparing empty cell arrays to store children S-params
                children_sparam = cell(numel(cmp.children),1);           
                % Loading all children S-param sweeps
                children_sparam_sweep = self.get_multiple_sparam_sweeps(cmp.children);              
                
                % Interconnection matrix
                FF = self.construct_interconnection_matrix(compid);             
                % Pre-allocating the space for CFSM
                cmp.sparam_sweep = zeros(numel(cmp.outer_Fports), numel(cmp.outer_Fports), numel(self.freq));       
                for ifreq = 1:numel(self.freq)             
                    for ichild = 1:numel(cmp.children)
                        
                        if size(children_sparam_sweep{ichild},3) == 1
                            children_sparam{ichild} = children_sparam_sweep{ichild};
                        else
                            children_sparam{ichild} = children_sparam_sweep{ichild}(:,:,ifreq);
                        end % if
                    end % for         
                    % Using sparse matrixes saves a lot of memory at the
                    % expense of computational speed
                    
                    switch self.use_sparse_matrices
                        case 0
                            SS = blkdiag(children_sparam{:});
                        case 1
                            SS = sparse(blkdiag(children_sparam{:}));
                        otherwise
                            error('Invalid USE_SPARSE_MATRICES value. Can be 0 or 1')
                    end % switch                                 
                    % Computing CFSM for each frequency
                   cmp.sparam_sweep(:,:,ifreq) = self.compute_cfsm(compid, SS, FF);                 
                end % for        
            end % if
        end % fun
        
        
        function out = compute_cfsm(self, compid, SS, FF)
            % Computes CFSM from aggregated scattering matrix SS using the
            % interconnection matrix FF
            %  
            cmp = self.compid(compid);
            
            % Using sparse matrixes saves a lot of memory at the
            % expense of computational speed
            switch self.use_sparse_matrices
                case 0
                    SSMN = SS(cmp.outer_Fports, cmp.outer_Fports);
                    SSMn = SS(cmp.outer_Fports, cmp.inner_Fports);
                    SSmN = SS(cmp.inner_Fports, cmp.outer_Fports);
                    SSmn = SS(cmp.inner_Fports, cmp.inner_Fports);
                    FFmn = FF(cmp.inner_Fports, cmp.inner_Fports);
                case 1
                    SSMN = sparse(SS(cmp.outer_Fports, cmp.outer_Fports));
                    SSMn = sparse(SS(cmp.outer_Fports, cmp.inner_Fports));
                    SSmN = sparse(SS(cmp.inner_Fports, cmp.outer_Fports));
                    SSmn = sparse(SS(cmp.inner_Fports, cmp.inner_Fports));
                    FFmn = sparse(FF(cmp.inner_Fports, cmp.inner_Fports));
                otherwise
                    error('Invalid USE_SPARSE_MATRICES value. Can be 0 or 1')
            end % switch
            out = SSMN + SSMn*((FFmn-SSmn)\SSmN);
        end % fun
        
        
        function out = construct_interconnection_matrix(self, compid)
            % Constructs interconnection matrix FF required during
            % computation of CFSM
            %
            cmp = self.compid(compid);
            switch self.use_sparse_matrices
                case 0
                    out = zeros(cmp.N_Fports);
                case 1
                    out = sparse(cmp.N_Fports);
                otherwise
                    error('Invalid USE_SPARSE_MATRICES value. Can be 0 or 1')
            end % switch
            
            for i_link = 1:numel(cmp.links)
                link = cmp.links{i_link};
                 % If port is attached to 0, it is grounded 
                if ismember(0, link)            
                    for port = setxor(0, link)
                        out(cmp.all_Fports(:,port), cmp.all_Fports(:,port)) = self.get_sparam_ground();
                    end % for
                else
                % Otherwise, connect ports together to a node
                    out(cmp.all_Fports(:,link), cmp.all_Fports(:,link)) = self.get_sparam_node(numel(link));               
                end % if
            end % for
        end % fun    
        
        
        
    	function [an, bn, bM] = compute_inner_ports_spectra(self, compid, SS, FF, aN)
            % Using the input spectrum of the outer ports, aN, and
            % aggragated s-param matrix SS, computers the incoming and
            % outgoing spectra of internal ports, an, bn, and the outgoing
            % spectra of outer ports, bM
            %
            cmp = self.compid(compid);          
            % Computing CFSM
            SSMN = SS(cmp.outer_Fports, cmp.outer_Fports);
            SSMn = SS(cmp.outer_Fports, cmp.inner_Fports);
            SSmN = SS(cmp.inner_Fports, cmp.outer_Fports);
            SSmn = SS(cmp.inner_Fports, cmp.inner_Fports);
            FFmn = FF(cmp.inner_Fports, cmp.inner_Fports);
            % Here, we use direct solvers because iterative solvers are
            % ill-suited for frequency-domain
            an = ((FFmn-SSmn)\SSmN)*aN;
            bn = FFmn*an;
            bM = SSMN*aN+SSMn*an;    
        end % fun
        
        
        function compute_excitation(self, id)                                
            % Computes excitation applied to component 'comp_id'
            %
            cmp = self.compid(id);
            N = self.N_orders;
            M = numel([-N:N]);               
            if strcmp(cmp.type,'circuit')~=1 || cmp.is_blackbox==1
                % If there are no children, just calculate the output
                % spectrum using the S-matrix of component comp_id             
                sparam_sweep = cmp.get_sparam();             
                for ifreq = 1:numel(self.freq)
                    cmp.output_spectrum(:,ifreq) = squeeze(sparam_sweep(:,:,ifreq))*cmp.input_spectrum(:,ifreq);                  
                end % for       
            else % If the component has children                       
                % Loading S-params of all children
                children_sparam_sweep = self.get_multiple_sparam_sweeps(cmp.children);
                % Defining the input and output spectra for all ports of all children of
                % the network 'compid'
                children_input_spectra = zeros(cmp.N_all_Fports, length(self.freq));
                children_output_spectra = zeros(cmp.N_all_Fports, length(self.freq)); 
                % Assign the input spectrum of comp_id network to outer ports
                children_input_spectra(cmp.outer_Fports,:) = cmp.input_spectrum;       
                % Constructing the interconnection matrix
                FF = self.construct_interconnection_matrix(id);      
                % Variables to store S-param at one frequency
                children_sparam = cell(numel(cmp.children),1); 
                for ifreq = 1:numel(self.freq)                
                    % Loading children S-params at particular frequency
                    for ichild = 1:numel(cmp.children)
                        children_sparam{ichild} = children_sparam_sweep{ichild}(:,:,ifreq);
                    end % for               
                    % Calculating the incoming and outgoing spectra of all
                    % inner ports, as well as the outgoing spectra of outer
                    % ports
                    SS = blkdiag(children_sparam{:});       
                    % Compute the spectra of all inner ports of the network
                    % using the incoming spectra of outer portss                    
                    [an, bn, bN] = self.compute_inner_ports_spectra(id, SS, FF, children_input_spectra(self.compid(id).outer_Fports,ifreq)); 
                    % Incoming signals at inner ports
                    children_input_spectra(cmp.inner_Fports, ifreq) = an; 
                    % Outgoing signals at inner ports
                    children_output_spectra(cmp.inner_Fports, ifreq) = bn; 
                    % Outgoing signal at outer ports
                    children_output_spectra(cmp.outer_Fports, ifreq) = bN; 
                    % Defining the outgoing signals for parent network
                    cmp.output_spectrum(:,ifreq) = bN;             
                end % for           
                % Using the newly found input spectra of network's children
                % elements, assign them as input spectra for children and
                % reiterate excitation processing procedure until all spectra
                % become known
                self.set_children_spectra(id, children_input_spectra, children_output_spectra);            
                % Initiate re-iteration
                for ichild = 1:numel(cmp.children)
                    self.compute_excitation(cmp.children(ichild));
                end % for
            end % if
          
        end % fun
        
        
    end % protected methods
        
    
end % classdef

