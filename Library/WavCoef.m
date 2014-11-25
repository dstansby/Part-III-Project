function Coef=WavCoef(data,f,WaveletToUse,dt)

% Coef=WavCoef(data,f,WaveletToUse,dt)
%
% Calculates the continuous Wavelet transform of data, at a set of
% frequencies f, using the Wavelet specified by WaveletToUse.
% Possible Wavelets are:  'morlet', 'mexican hat'
%
% Christopher Chen 2012 (based on cwt by T Horbury)
%
% Updated by David Stansby 2014
%   - Added clear statements to free up memory

% Lengths
N=size(data,1);
NCols=size(data,2);
NFreqs=length(f);

% Construct output array
Coef=zeros(NFreqs,N,NCols).*NaN;

% Loop over scales, from small to large
disp('Calculating wavelet coefficients')
fprintf('Loop');
for s=1:NFreqs
 
 % Frequencies to use
 k=(0:N-1)';
 w=(2*pi).*k./N;
 w(k>N/2)=-w(k>N/2);
 clear k;
 
 % Wavelet for this scale
 WavHere=MakeWavelet(WaveletToUse,(f(s)*dt),w);
 WaveletLength=size(WavHere,1);
 clear w;
 
 % Make up additional columns
 if NCols>1
  WavHere(:,2:NCols)=zeros(WaveletLength,NCols-1).*NaN;
  for j=2:NCols
   WavHere(:,j)=WavHere(:,1);
  end
 end
 
 % Debug
 fprintf(' %d',s);
 %disp(['Loop ',int2str(s),': frequency=',num2str(f(s)*dt),' (',num2str(f(s)),'Hz)'])
 
 % FFT of data for this scale
 xhat=fft(data(:,:),N,1);
 
 % Wavelet coefficients for this scale
 Coef(s,:,:)=ifft(xhat.*conj(WavHere),N,1);
 clear WavHere xhat;
 
end
fprintf('\n');

function Wavelet=MakeWavelet(WaveletToUse,f,w)
% Construct Fourier transformed Wavelet at Fourier frequency f as a function of frequencies w to
% be used in FFT calculation of Wavelet transform
switch WaveletToUse
 case 'mexican hat'
  lambda=(2*pi)/sqrt(2.5);
  s=(1/f)*lambda;
  Wavelet=((i^2)/gamma(2.5))*((s.*w).^2).*exp(-((s.*w).^2)./2);
 case 'morlet'
  w0=6;
  lambda=(4*pi)/(w0+sqrt(2+w0^2));
  s=(1/f)*lambda;
  Wavelet=(pi^(-1/4)).*heaviside(w).*exp(0.5.*(-((s.*w-w0).^2)));
 otherwise,
  error('Unknown Wavelet type')
end

function h=heaviside(x)
% Heaviside function: heaviside(x)=1 if x>0, heaviside(x)=0 otherwise
h=x>0;