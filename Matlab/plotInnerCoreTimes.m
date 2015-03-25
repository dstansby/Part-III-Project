clear
folder = 'bandasea';
addpath('Library');

%% Import data
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Change depth into depth below ICB
stationDetails(:,13) = stationDetails(:,13) - 5153;

% Calculate time spend in inner core
innerCoreTimes = stationDetails(:,15) - stationDetails(:,14);

%% Plot depth vs. epicentral distance
figure;
ax = gca;

scatter(innerCoreTimes,stationDetails(:,1));

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Time spent in inner core /s');
ylabel('Epicentral distance /deg');

%% Plot depth vs. epicentral distance
figure;
ax = gca;

scatter(innerCoreTimes,stationDetails(:,13));

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Time spent in inner core /s');
ylabel('Depth /km');