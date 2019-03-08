% Composite Floquet Scattering Matrix (CFSM) Circuit Simulator 
% 
% Copyright (C) 2017  Mykhailo Tymchenko
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

classdef FTCore < handle
        
    methods
        
        function self = FTCore()
            % Empty class constructor
        end % fun
        
        
        function out = compute_FT_toeplitz(self, f)
            % *************************************************
            % Computes Toeplitz (2N+1)x(2N+1) matrix of Fourier coeffs
            %
            % *************************************************
            if numel(f)==1
                out = f*eye(2*self.N_orders+1);
            else
                if 2*(2*self.N_orders+1)>length(f)
                    error(['Insufficient resolution of a time-periodic function. ',...
                           'Increase the resolution or decrease the number of harmonics'])
                else
                    fn = self.compute_FT(f);                
                    f0 = fn(1); % n=0 harmonic
                    fnp = fn(2:2*self.N_orders+1); % n>0
                    fnm = flip(fn); fnm([2*self.N_orders+1]:end)=[]; % n<0
                    out = toeplitz([f0,fnp],[f0,fnm]);
                end % if
            end % if
        end % fun
        
        
        function out = compute_FT(self, X)
            % *************************************************
            % Returns Fourier coeffs of fun(t) for n = [-N..N]
            %
            % *************************************************
            out = fft(X)/length(X);
        end % fun
        
        
%         function out = compute_IFT(self, fn, t)
%             % *************************************************
%             % Returns fun(t), t=0..T using its spectrum
%             %  
%             % *************************************************            
%             Y = zeros(size(t));
%             fnp = fn([self.N_orders+1]:end); % n>=0
%             fnm = fn(1:self.N_orders); % n<0
%            
%             Y(1:numel(fnp)) = fnp; 
%             Y = flip(Y); 
%             Y(1:numel(fnm)) = flip(fnm); 
%             Y = flip(Y);
% 
%             out = ifft(Y*numel(Y));
%         end % fun


        function out = compute_IFT(self, fn, t)
            % *************************************************
            % Returns fun(t), t=0..T using its spectrum
            %  
            % *************************************************
            
            orders = [-self.N_orders:self.N_orders];
            out = zeros(size(t));
            for im = 1:numel(orders)
                out = out + fn(im)*exp(1j*orders(im)*2*pi*self.freq_mod*t);
            end
                
        end % fun
        
    end % methods
    
end % classdef

