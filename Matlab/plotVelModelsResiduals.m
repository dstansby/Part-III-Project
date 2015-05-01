addpath('Library');
load('ICBdepth');
folder = ('bandasea');

%% Import data
realp2p = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
ehp2p = readfile(['data/' folder '/eh_residuals.txt'],'%*s %f %f',2);
ak135p2p = readfile(['data/' folder '/PKiKP_differences.txt'],'%*s %f %f',2);
ak135stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

realResid = realp2p(:,2) - ak135p2p(:,2);
ehResid = ehp2p(:,2) - ak135p2p(:,2);

depths = ak135stationDetails(:,13) - ICBdepth;

figure;
hold on;
scatter(realResid,depths,'+');
scatter(ehResid,depths,'+');

ax1 = gca;
% Plot formatting
ax1.YDir = 'reverse';
ax1.XAxisLocation = 'top';
xlabel('Residual /s');
ylabel('Depth below ICB /km');
ax1.FontSize = 14;
title(folder);

vline(0);