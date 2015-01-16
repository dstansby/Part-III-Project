clear;

%% Fetch Data
% (network, station, location, channel)
mytraceZ = irisFetch.Traces('II','AAK','10','BHZ','2009-09-05 04:17:00', '2009-09-05 04:20:00');
t = 60*3;	% Length of trace in seconds

% Create sample titmes
sampletimes = linspace(mytraceZ.startTime,mytraceZ.endTime,mytraceZ.sampleCount)';

% Create data
dataZ(:,1) = sampletimes;
dataZ(:,2) = mytraceZ.data;

dt = t/size(sampletimes,1);	% Sampling rate
fNyq = 1/(2*dt);	% Maximum frequency for wavelet transform
fMin = 100/(2*t);		% Minimum frequency for wavelet transform

%clear sampletimes secondtimes mytraceZ;
%% Band pass data
x = [0.7 2];    % Filter between 0.7Hz and 2Hz

% Filter parameters
%   Frequencies specified in normalised units, given by
%   dividing the acutal frequency by the Nyquist frequency
Fp1 = min(x)/fNyq;   % Left hand side of band pass
Fp2 = max(x)/fNyq;   % Right hand side of band pass
Fst1 = Fp1/1.1; % Start of left hand transition region
Fst2 = 1.1*Fp2; % End of right hand transition region
Ast1 = 50;      % Attenuation below left hand transition region
Ap = 1;         % Amount of ripple (I have no idea what this means...)
Ast2 = 50;      % Attenuation above right hand transition region

% Design filter
d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2);
fd = design(d);

% Filter data
FilterdataZ(:,1) = dataZ(:,1);
FilterdataZ(:,2) = filter(fd,dataZ(:,2));

clear d fd Fp1 Fp2 Fst1 Fst2 Ast1 Ap Ast2;
%% Calculate and plot wavelet transform
Freqs = logspace(log10(fMin),log10(fNyq),100)';

WavCoefs = WavCoef(dataZ(:,2),Freqs,'morlet',dt);
WavPower = WavCoefs.*conj(WavCoefs);

figure;
imagesc(dataZ(:,1), log10(Freqs),log10(WavPower));
colorbar;
colormap jet;
xlabel('Time /s')
ylabel('log10(Frequency /Hz')

%% Plot seismogram
figure;
subplot(2,1,1);
plot(FilterdataZ(:,1),FilterdataZ(:,2));
title('Filtered data');
datetick;

subplot(2,1,2);
plot(dataZ(:,1),dataZ(:,2));
title('Original data');
datetick;
%% Plot power spectra
power = psdchc(dataZ, 1, 1);
figure;
plot(log10(power(:,1)),log10(power(:,2)));
xlabel('log10(Freq /Hz)');
ylabel('Power');
datetick;