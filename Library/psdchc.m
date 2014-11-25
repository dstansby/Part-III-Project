function [PSD,Conf]=psdchc(Data,Type,NW)

% function PSD=psdchc(Data,Type,NW)
%
% Wrapper for psdtsh
%
% Christopher Chen 2013

[a,b]=size(Data);
dt=mean(diff(Data(:,1)));
[PSD(:,2:b),PSD(:,1),Conf]=psdtsh(Data(:,2:b),dt,Type,NW);