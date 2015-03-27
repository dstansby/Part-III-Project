clear
folder = 'bandasea';
addpath('Library');

%% Import data
data = readfile(['data/' folder '/both_lead_differences.txt'],'%*s %f %f',2);
ehData = readfile(['data/' folder '/eh.txt'],'%*s %f %f',2);
pkikpData = readfile(['data/' folder '/PKiKP_lead_differences.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

data(:,2) = -data(:,2);
ehData(:,2) = -ehData(:,2);
pkikpData(:,2) = -pkikpData(:,2);

% Change depth into depth below ICB
stationDetails(:,13) = stationDetails(:,13) - 5153;

data(:,1) = stationDetails(:,13);
ehData(:,1) = stationDetails(:,13);
pkikpData(:,1) = stationDetails(:,13);

%% Calculate errors
synthPickErr = 0.01;
errs = sqrt(2)*synthPickErr*ones(size(data(:,1)));

%% Perform moving average to smooth data
n = 3;
data = movingaverage(data,n);
ehData = movingaverage(ehData,n);
pkikpData = movingaverage(pkikpData,n);

% Calculate new errors
errs = errs(n:end)/sqrt(n);

%% Plot different velocity model data
figure;
hold on;
ax = gca;

scatter(data(:,2),data(:,1),'+');
scatter(ehData(:,2),ehData(:,1),'+');
herrorbar(data(:,2),data(:,1),errs,ax.ColorOrder(1,:));
herrorbar(ehData(:,2),ehData(:,1),errs,ax.ColorOrder(2,:));

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('(combined downswing) - (PKIKP downswing) /s');
ylabel('Depth below ICB /km');
l = legend('AK135', 'AK135, top layer of inner core at Vp = 11.1km/s');
l.Location = 'southeast';
vline(0);

%% Plot PKiKP swing comaprison
figure;
hold on;
ax = gca;

% Throw away depths > 14 km for pkikp data
pkikpData(pkikpData(:,1) > 14,:) = NaN;

% Plot data
scatter(data(:,2),data(:,1),'+');
scatter(pkikpData(:,2),pkikpData(:,1),'+');

% Plot error bars
herrorbar(data(:,2),data(:,1),errs,ax.ColorOrder(1,:));
pkikpErrs = errs(1:size(pkikpData,1));
herrorbar(pkikpData(:,2),pkikpData(:,1),pkikpErrs,ax.ColorOrder(2,:));

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
xlabel('Difference from PKIKP downswing /s');
ylabel('Depth below ICB /km');
l = legend('Combined', 'PKiKP');
l.Location = 'southeast';
vline(0);