function [dataout,F,Conf]=psdtsh(datain,dt,ffttype,nw)
% [dataout,F,Conf]=PSDTSH(datain,dt,ffttype,nw)
% Power spectral density estimator, with a variety of methods
%
% datain should be one or more columns of data, equally spaced in time
% dt is the time between data points
% ffttype (optional) selects the FFT method used:
%    1: Matlab FFT used, with no taper
%    2: Matlab multitaper, using bandwith product NW
%    3: Internal FFT used, no tapering
%
% dataout holds one or more columns of power spectral density estimates
% F is of the same length as dataout and holds corresponding frequencies
% Conf holds a 95% confidence interval: Conf(:,:,1) is the lower limit,
% Conf(:,:,2) is the upper limit. Conf may be NaN (not calculated)
% for some FFT methods
%
% PSDTSH subtracts means from the input data, but does not detrend
%
% Version 0.2, T S Horbury, 25.06.99

% Revision history:
% 15.05.98: V0.1, writing
% 18.05.98: factor of 2 for home-brewed DFT, normalised Matalb FFT,
%           extension to multiple columns,
%           writing interface for Matlab multitaper
% 20.05.98: multitaper is probably right. Adding multiple column support
%           Complete for methods 1 and 3, but not for 2
% 25.06.98: Altered multitaper to check for and load E,V tapers to speed
%           up calculations
% 13.07.98; Quieter unless UDebug variable exists
% 09.09.98: extra debug
% 25.06.99, V0.2: returns confidence interval for multitaper
% 27.05.03: V0.3: corrected multitaper normalisation, to allow for new version of pmtm which uses
%           different normalisation (commented .*(2*dt) )
% 31.07.03: not verbose any more

%disp('PSDTSH v0.3 T S Horbury 1998, 1999')

% Check that we've got everything
if nargin<2
 error('PSDTSH: Not enough input arguments')
end

if nargin>2
 if ffttype==2
  if nargin<4
   error('PSDTSH: multitaper PSD needs a bandwith product as 4th parameter')
  end
 end
else
 ffttype=1;
end

N=size(datain,1);
W=size(datain,2);

% Subtract the mean from each column
for j=1:W
 datain(:,j)=datain(:,j)-mean(datain(:,j));
end
 
% We only want a single-sided PSD: this is the number of frequencies we use
NumUniquePts = ceil((N+1)/2);

% Calculate the frequency resolution
df=1/(N*dt);

% Calculate the frequencies
F=df.*(0:NumUniquePts-1)';

switch ffttype
case 1,
 % Use Matlab's built-in FFT, suitably normalised
 % Output array
 dataout=fft(datain,N);
 % fft is symmetric, throw away second half
 dataout=dataout(1:NumUniquePts,:);
 
 % Just the amplitudes, and square to get power
 dataout=(abs(dataout)).^2;
 
 % Remove data set length and sampling period dependence
 dataout=dataout.*(dt/N);
 
 % Multiply by 2 to take into account the fact that we
 % threw out second half of FFT above
 dataout=dataout*2;
 dataout(1,:)=dataout(1,:)./2;   % Account for endpoint uniqueness
 if ~rem(N,2),
  dataout(length(dataout),:)=dataout(length(dataout),:)./2;
 end
 % We don't calculate a confidence limit
 if W>1
  Conf=zeros(N,2).*NaN;
 else
  Conf=zeros(N,W,2).*NaN;
 end

case 2,
 % Use Matlab's built-in multitaper, suitably normalised
 % Output array
 dataout=zeros(NumUniquePts,W);
 % Check to see if the E and V arrays are available
 index=dpssdir(N,nw);
 if (isempty(index) | sum(index.wlist.NW==nw)==0)
  % They don't exist. Make them
  if exist('UDebug')==1;disp('Tapers for this N,NW combination DO NOT exist: making them');end
  [E,V]=dpss(N,nw);
 else
  % They exist
  if exist('UDebug')==1;disp('Tapers for this N,NW combination exist: loading');end
  [E,V]=dpssload(N,nw);
 end
 % pmtm only does one column at a time, so loop over components
 for c=1:W
  [dataout(:,c),Conf(:,c,1:2),F]=pmtm(datain(:,c),E,V,N,1/dt,'adapt',0.9);
 end
%  % Empirical normalisation
%  dataout=dataout.*(2*dt);

case 3,
 % Use home-brewed DFT
 % Output array
 dataout=zeros(NumUniquePts,W);
 % Cop out: loop over components
 for c=1:W
  % Loop over frequencies
  for j=1:NumUniquePts
   dataout(j,c)=2*(dt/N)*abs(sum(datain(:,c).*(exp(-(i*2*pi*F(j)*dt).*(1:N))'),1)).^2;
  end
 end
 if W>1
  Conf=zeros(N,2).*NaN;
 else
  Conf=zeros(N,W,2).*NaN;
 end

otherwise,
 error('PSDTSH: Unsupported PSD type selected')
end

