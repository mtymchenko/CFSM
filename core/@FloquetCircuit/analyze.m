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

function analyze(self)

time_start = datetime(); % Record the start time of the analysis
fprintf(['Simulation started...\n']);

% WORKAROUND: adding 1Hz to all frequencies to stabilize calculations
self.freq = self.freq + 1;

% COMPUTING S-PARAMS          
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


% COMPUTING EXCITATION
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


% DONE!
fprintf(['Computation successful!\n']);
time_finish = datetime();
[h,m,s] = hms(time_finish-time_start);
elapsed_time = [num2str(s),'s'];
if m~=0, elapsed_time = [num2str(m),'m ',elapsed_time]; end
if h~=0, elapsed_time = [num2str(h),'hr ',elapsed_time]; end
fprintf(['Elapsed time: ',elapsed_time,'\n\n'],s);

end