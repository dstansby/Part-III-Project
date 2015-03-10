clear
folder = 'celebessea';
addpath('Library');

t0 = 0.68;

%% Import data
data = readfile(['data/' folder '/both_differences.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
data(:,2) = t0 - data(:,2);
data(:,2) = data(:,2)./(stationDetails(:,15)-stationDetails(:,14));

%% Find line of best fit
%p = polyfit(data(:,2),data(:,1),4);
%line(:,1) = -1.2:0.1:0.4;
%line(:,2) = polyval(p,line(:,1));

%% Plot data
figure;
hold on;
scatter(data(:,2),data(:,1),'filled');
%plot(line(:,1),line(:,2));

ax = gca;
ax.FontSize = 14;
xlabel('\delta t / t');
ylabel('Epicentral distance /\circ')
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';