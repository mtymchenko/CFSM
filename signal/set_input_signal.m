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


function set_input_signal(crt, compid, port, signal, time)

N2 = numel(signal);

if mod(N2,2)==0
    N1 = N2/2;
else
    N1 = (N2+1)/2;
end

fs = 1/max(time);

input_spectrum = fft(signal)/N2;
pos_freq_spectrum = input_spectrum(2:N1);
neg_freq_spectrum = input_spectrum(N1+1:end);

freqs = [0, 1:numel(pos_freq_spectrum), -numel(neg_freq_spectrum):-1]*fs;
crt.set_input_spectrum(compid, port, input_spectrum, freqs);

end