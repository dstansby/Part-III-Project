clear
folder = 'bandasea';
addpath('Library');

%% Import data
data = readfile(['data/' folder '/both_lead_differences.txt'],'%*s %f %f',2);
ehData = readfile(['data/' folder '/eh.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Change depth into depth below ICB
stationDetails(:,13) = stationDetails(:,13) - 5153;

%% Calculate errors
synthPickErr = 0.01;
errs = sqrt(2)*synthPickErr*ones(size(data(:,1)));

%% Plot data
figure;
hold on;
ax = gca;

scatter(data(:,2),stationDetails(:,13),'+');
scatter(ehData(:,2),stationDetails(:,13),'+');
%herrorbar(data(:,2),stationDetails(:,13),errs,ax.ColorOrder(1,:));
%herrorbar(ehData(:,2),stationDetails(:,13),errs,ax.ColorOrder(2,:));

rectangle('Position',[-0.03 15 0.06 75])

% Plot formatting
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('(PKIKP downswing) - (combined downswing) /s');
ylabel('Depth below ICB /km');
vline(0);