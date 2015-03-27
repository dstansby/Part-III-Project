clear
folder = 'bandasea';
addpath('Library');
load('ICBdepth.mat');

%% Import data
ak135stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
ehstationDetails = readfile(['data/' folder '/stationdetails_eh.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
whstationDetails = readfile(['data/' folder '/stationdetails_wh.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Remove data above 130 deg
ak135stationDetails = ak135stationDetails(ak135stationDetails(:,1) < 130,:);
ehstationDetails = ehstationDetails(ehstationDetails(:,1) < 130,:);
whstationDetails = whstationDetails(whstationDetails(:,1) < 130,:);

% Remove bad wh data
whstationDetails = whstationDetails(whstationDetails(:,1) > 116.2,:);

% Sort data
ak135stationDetails = sortrows(ak135stationDetails);
ehstationDetails = sortrows(ehstationDetails);
whstationDetails = sortrows(whstationDetails);

% Change depth into depth below ICB
ak135stationDetails(:,13) = ak135stationDetails(:,13) - ICBdepth;
ehstationDetails(:,13) = ehstationDetails(:,13) - ICBdepth;
whstationDetails(:,13) = whstationDetails(:,13) - ICBdepth;

% Calculate time spend in inner core
ak135innerCoreTimes = ak135stationDetails(:,15) - ak135stationDetails(:,14);
ehinnerCoreTimes = ehstationDetails(:,15) - ehstationDetails(:,14);
whinnerCoreTimes = whstationDetails(:,15) - whstationDetails(:,14);

%% Plot depth vs. epicentral distance
figure;
hold on;
ax = gca;

plot(ak135stationDetails(:,13),ak135stationDetails(:,1));
plot(ehstationDetails(:,13),ehstationDetails(:,1));
plot(whstationDetails(:,13),whstationDetails(:,1));

legend('AK135', 'AK135 with vp = 11.1km/s layer below ICB', 'AK135 with vp = 11.0km/s layer below ICB');

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Depth below ICB /km');
ylabel('Epicentral distance /deg');


%% Plot time vs. epicentral distance
figure;
hold on;
ax = gca;

plot(ak135innerCoreTimes,ak135stationDetails(:,1));
plot(ehinnerCoreTimes,ehstationDetails(:,1));
plot(whinnerCoreTimes,whstationDetails(:,1));

legend('AK135', 'AK135 with vp = 11.1km/s layer below ICB', 'AK135 with vp = 11.0km/s layer below ICB');

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Time spent in inner core /s');
ylabel('Epicentral distance /deg');

%% Plot time vs. depth
figure;
hold on;
ax = gca;

plot(ak135innerCoreTimes,ak135stationDetails(:,13));
plot(ehinnerCoreTimes,ehstationDetails(:,13));
plot(whinnerCoreTimes,whstationDetails(:,13));

legend('AK135', 'AK135 with vp = 11.1km/s layer below ICB', 'AK135 with vp = 11.0km/s layer below ICB');

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Time spent in inner core /s');
ylabel('Depth below ICB /km');