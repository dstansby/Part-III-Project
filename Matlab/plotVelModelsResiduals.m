addpath('Library');
load('ICBdepth');
folder = ('bandasea');
ak135vel = 11.0427;

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

realVelChange = ak135vel*((realResid./(times - realResid)) + 1);
ehVelChange = ak135vel*((ehResid./(times - ehResid)) + 1);
whVelChange = ak135vel*((whResid./(times - whResid)) + 1);

realVelErr = ak135vel*times*0.17./((times - realResid).^2);
ehVelErr = ak135vel*times*0.17./((times - ehResid).^2);
whVelErr = ak135vel*times*0.17./((times - whResid).^2);


%% Plot residuals
figure;
hold on;
scatter(realResid,depths,'+');
scatter(whResid,depths,'+');
scatter(ehResid,depths,'+');
l = legend('Real', 'WH (11.0 km/s)', 'EH (11.1 km/s)');

ax = gca;
% Plot formatting
l.Location = 'SouthEast';
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
xlabel('Residual /s');
ylabel('Depth below ICB /km');
ax.FontSize = 14;
vline(0);

%% Plot fractional changes
figure;
hold on;
ax = gca;

scatter(realVelChange,depths,'+');
%herrorbar(realVelChange,depths,realVelErr,ax.ColorOrder(1,:));

scatter(whVelChange,depths,'+');
%herrorbar(whVelChange,depths,whVelErr,ax.ColorOrder(3,:));

scatter(ehVelChange,depths,'+');
%herrorbar(ehVelChange,depths,ehVelErr,ax.ColorOrder(2,:));

l = legend('Real', 'WH (11.0 km/s)', 'EH (11.1 km/s)');

% Plot formatting
l.Location = 'SouthEast';
ax.YDir = 'reverse';
ax.YLim = [2 16];
ax.XAxisLocation = 'top';
xlabel('Measured velocity / km/s');
ylabel('Depth below ICB /km');
ax.FontSize = 14;
vline(11);
vline(11.1);