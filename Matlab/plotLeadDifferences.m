clear
folder = 'bandasea';
addpath('Library');

%% Import data
data = readfile(['data/' folder '/both_lead_differences.txt'],'%*s %f %f',2);
ehData = readfile(['data/' folder '/eh.txt'],'%*s %f %f',2);
pkikpData = readfile(['data/' folder '/PKiKP_lead_differences.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Change depth into depth below ICB
stationDetails(:,13) = stationDetails(:,13) - 5153;

%% Calculate errors
synthPickErr = 0.01;
errs = sqrt(2)*synthPickErr*ones(size(data(:,1)));

%% Perform moving average to smooth data
n = 1;
data = movingaverage(data,n);
ehData = movingaverage(ehData,n);

%% Plot different velocity model data
figure;
hold on;
ax = gca;

scatter(-data(:,2),data(:,1),'+');
scatter(-ehData(:,2),ehData(:,1),'+');
%herrorbar(data(:,2),stationDetails(:,13),errs,ax.ColorOrder(1,:));
%herrorbar(ehData(:,2),stationDetails(:,13),errs,ax.ColorOrder(2,:));

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('(combined downswing) - (PKIKP downswing) /s');
ylabel('Epicentral distance /deg');
l = legend('AK135', 'AK135, top layer of inner core at Vp = 11.1km/s');
l.Location = 'southeast';
vline(0);

%% Plot PKiKP swing comaprison
figure;
hold on;
ax = gca;

scatter(-data(:,2),data(:,1),'+');
scatter(-pkikpData(:,2),pkikpData(:,1),'+');

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.YLim = [115 128];
xlabel('(combined/PKiKP downswing) - (PKIKP downswing) /s');
ylabel('Epicentral distance /deg');
l = legend('Combined', 'PKiKP');
l.Location = 'southeast';
vline(0);