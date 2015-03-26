clear
folder = 'bandasea';
addpath('Library');

%% Import data
ak135stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
ehstationDetails = readfile(['data/' folder '/stationdetails_eh.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Remove data above 130 deg
ak135stationDetails = ak135stationDetails(ak135stationDetails(:,1) < 130,:);
ehstationDetails = ehstationDetails(ehstationDetails(:,1) < 130,:);

% Sort data
ak135stationDetails = sortrows(ak135stationDetails);
ehstationDetails = sortrows(ehstationDetails);

% Change depth into depth below ICB
ak135stationDetails(:,13) = ak135stationDetails(:,13) - 5153;
ehstationDetails(:,13) = ehstationDetails(:,13) - 5153;

% Calculate time spend in inner core
ak135innerCoreTimes = ak135stationDetails(:,15) - ak135stationDetails(:,14);
ehinnerCoreTimes = ehstationDetails(:,15) - ehstationDetails(:,14);


%% Plot depth vs. epicentral distance
figure;
hold on;
ax = gca;

plot(ak135stationDetails(:,13),ak135stationDetails(:,1));
plot(ehstationDetails(:,13),ehstationDetails(:,1));

legend('AK135', 'AK135 with vp = 11km/s layer at top of ICB');

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
legend('AK135', 'AK135 with vp = 11km/s layer at top of ICB');

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
legend('AK135', 'AK135 with vp = 11km/s layer at top of ICB');

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Time spent in inner core /s');
ylabel('Depth below ICB /km');