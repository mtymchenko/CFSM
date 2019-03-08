function out = get_sparam(varargin)

self = varargin{1};
    
narginchk(1,6);

N = self.N_orders;
M = 2*N+1;

if nargin == 1
    out = self.sparam_sweep;
elseif nargin == 3 || nargin == 5
    
    if nargin >= 2
        port_to = varargin{2};
        port_from = varargin{3};
        Fports_to = M*(port_to-1)+[1:M];
        Fports_from = M*(port_from-1)+[1:M];
    end

    if nargin >= 4
        m = varargin{4};
        n = varargin{5};
        Fports_to = M*(port_to-1)+N+1+m;
        Fports_from = M*(port_from-1)+N+1+n;
    end
    out = self.sparam_sweep(Fports_to, Fports_from, :);
else
    error('Wrong number of input parameters')
end

end % fun