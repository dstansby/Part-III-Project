clear
load('redblue.mat');
addpath('Library');

toplot = [];
%% Loop through each folder
folders = dir('data');
for i = 1:3
	% Skip . and ..
	if (i == 1) || (i == 2)
		continue;
	end
	folder = folders(i).name;
	
	realData = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
	synthData = readfile(['data/' folder '/both_differences.txt'],'%*s %f %f',2);
	stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
	stationDetails(:,13) = stationDetails(:,13) - 5153;
	
	resid = realData(:,2) - synthData(:,2);
	
	% Store longitude, depth, residual
	toplot = vertcat(toplot,horzcat(stationDetails(:,12),stationDetails(:,13),resid));
	clear resid realData synthData stationDetails
end

%% Plot data
figure;
colormap(col);
points = scatter(toplot(:,1),toplot(:,2),150,toplot(:,3),'filled');

% Add lines to compare with Waszek 2011
hline(15);
hline(30);

% Plot formatting
cbar = colorbar;
clim = 1.2;
caxis([-clim clim]);
cbar.Label.String = 'Residual /s';

points.MarkerEdgeColor = 'k';
points.LineWidth = 0.1;

ax = gca;
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.XLim = [-180 180];
ax.YDir = 'reverse';
xlabel('Turning Longitude');
ylabel('Depth below ICB /km');