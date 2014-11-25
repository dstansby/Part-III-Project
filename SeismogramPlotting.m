% Fetch Data
% (network, station, location, channel)
mytraceZ = irisFetch.Traces('II','AAK','10','BHZ','2009-09-05 04:15:00', '2009-09-05 04:20:00');

% Create sample times
sampletimes = linspace(mytraceZ.startTime,mytraceZ.endTime,mytraceZ.sampleCount)';

% Convert the time series to seconds since start of event
secondtimes = sampletimes - sampletimes(1);
secondtimes = secondtimes*(5*60/secondtimes(end));

% Create data
dataZ = mytraceZ.data;

t = secondtimes(end) - secondtimes(1);	% Sample length in seconds
dt = t/size(secondtimes,1);	% Sampling rate
fNyq = 1/(2*dt);	% Maximum frequency for wavelet transform
fMin = 10/(2*t);		% Minimum frequency for wavelet transform
%% Band pass data
x = [0.7 2];    % Filter between 0.7Hz and 2Hz
% Filter parameters
%   Frequencies specified in normalised units, given by
%   dividing the acutal frequency by the Nyquist frequency
Fp1 = min(x)/fNyq;   % Left hand side of band pass
Fp2 = max(x)/fNyq;   % Right hand side of band pass
Fst1 = Fp1/1.1; % Start of left hand transition region
Fst2 = 1.1*Fp2; % End of right hand transition region
Ast1 = 100;      % Attenuation below left hand transition region
Ap = 1;         % Amount of ripple (I have no idea what this means...)
Ast2 = 100;      % Attenuation above right hand transition region

% Design filter
d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2);
fd = design(d);

FilterdataZ = filter(fd,dataZ);


%% Calculate wavelet transform
Freqs = logspace(log10(fMin),log10(fNyq),500)';

WavCoefs = WavCoef(dataZ,Freqs,'morlet',dt);

WavPower = WavCoefs.*conj(WavCoefs);

figure;
%subplot(2,1,1);
imagesc(secondtimes, log10(Freqs),log10(WavPower));
colorbar;
colormap jet;


%% Calculate helicity values


%% Plot seismogram
%subplot(2,1,2);
figure;
plot(secondtimes,FilterdataZ);

%% Plot power spectra
power = psdchc([secondtimes dataZ], 1, 1);
figure;
plot(log10(power(:,1)),log10(power(:,2)));