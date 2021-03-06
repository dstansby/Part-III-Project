clear
folder = 'bandasea';
addpath('Library');
load('ICBdepth.mat');

t0 = 0.68;	% Minimum resolvable difference

%% Import data
data = readfile(['data/' folder '/PKiKP_differences.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
stationDetails(:,13) = stationDetails(:,13) - ICBdepth;	% Calculate depth below ICB

data(:,1) = stationDetails(:,13);
data(:,2) = t0 - data(:,2);
data(:,2) = data(:,2)./(stationDetails(:,15)-stationDetails(:,14));

%% Find line of best fit
p = polyfit(data(:,2),data(:,1),1);

min = min(data(:,2));
max = max(data(:,2));
step = (max - min)/100;	% x sampling points

line(:,1) = min:step:max;
line(:,2) = polyval(p,line(:,1));

clear min max step;

%% Plot data
figure;
hold on;
scatter(data(:,2),data(:,1),'filled');
%plot(line(:,1),line(:,2));

ax = gca;
ax.FontSize = 14;
xlabel('\delta v / v');
ylabel('Depth below ICB /km')
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';