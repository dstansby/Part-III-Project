addpath('Library');
load('ICBdepth');
folder = ('bandasea');

%% Import data
realp2p = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
ehp2p = readfile(['data/' folder '/eh_residuals.txt'],'%*s %f %f',2);
whp2p = readfile(['data/' folder '/wh_residuals.txt'],'%*s %f %f',2);
ak135p2p = readfile(['data/' folder '/PKiKP_differences.txt'],'%*s %f %f',2);
ak135stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

depths = ak135stationDetails(:,13) - ICBdepth;
times = ak135stationDetails(:,15) - ak135stationDetails(:,14);

%% Calculate residuals
realResid = realp2p(:,2) - ak135p2p(:,2);
ehResid = ehp2p(:,2) - ak135p2p(:,2);
whResid = whp2p(:,2) - ak135p2p(:,2);

realVelChange = realResid./(times - realResid);
ehVelChange = ehResid./(times - ehResid);
whVelChange = whResid./(times - whResid);

%% Plot residuals
figure;
hold on;
scatter(realResid,depths,'+');
scatter(ehResid,depths,'+');
scatter(whResid,depths,'+');
l = legend('Real', 'EH (11.1 km/s)', 'WH (11.0 km/s)');

ax = gca;
% Plot formatting
l.Location = 'SouthEast';
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
xlabel('Residual /s');
ylabel('Depth below ICB /km');
ax.FontSize = 14;
title(folder);
vline(0);

%% Plot fractional changes
figure;
hold on;
scatter(realVelChange,depths,'+');
scatter(ehVelChange,depths,'+');
scatter(whVelChange,depths,'+');
l = legend('Real', 'EH (11.1 km/s)', 'WH (11.0 km/s)');

ax = gca;
% Plot formatting
l.Location = 'SouthEast';
ax.YDir = 'reverse';
ax.YLim = [2 16];
ax.XAxisLocation = 'top';
xlabel('Residual /s');
ylabel('Depth below ICB /km');
ax.FontSize = 14;
title(folder);
vline(0);