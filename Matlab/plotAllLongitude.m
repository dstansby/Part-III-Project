function plotAllLongitude
clear
addpath('Library');
load('redblue.mat','col');
load('ICBdepth.mat','ICBdepth');
AK135vel = 11.0427;

data = [];

%% Loop through each folder
folders = dir('data');
for i = 1:size(folders,1)
	% Skip ., .., and .DS_Store
	folder = folders(i).name;
	if strcmp(folder,'..') || strcmp(folder,'.') || strcmp(folder,'.DS_Store')
		continue;
	end
	
	display(['Processing ' folder]);

	realData = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
	synthData = readfile(['data/' folder '/PKiKP_differences.txt'],'%*s %f %f',2);
	stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);
	stationDetails(:,13) = stationDetails(:,13) - ICBdepth;	% Calculate depth below ICB
	
	% Sanity check peak to peak distances
	if min(realData(:,2)) < 0 || min(synthData(:,2)) < 0
		error('At least one peak to peak distance is negative');
	end
	
	% Remove shallower than 10km
	toKeep = stationDetails(:,13) > 10;
	stationDetails = stationDetails(toKeep,:);
	
	% Calculate residuals and travel times
	resid = realData(toKeep,2) - synthData(toKeep,2);
	travelTimes = stationDetails(:,15) - stationDetails(:,14);
	
	% Store longitude, depth, residual, inner core travel times
	data = vertcat(data,horzcat(stationDetails(:,12),stationDetails(:,13),resid, travelTimes));
	
	clear resid realData synthData stationDetails travelTimes;
end
noPoints = size(data,1);
disp(['Plotting ' num2str(noPoints) ' points']);

%% Plot longitude/deptgh data
figure;
colormap(col);
points = scatter(data(:,1),data(:,2),75,data(:,3),'filled');

% Add lines to compare with Waszek 2011
hline([10 15]);

% Add lines to split up data
longSplit = [[-170 150],[-90 75], [-30 0], [0 60]];
for i = 1:8
	vline(longSplit(i));
end

% Plot formatting
cbar = colorbar;
clim = 0.8;
caxis([-clim clim]);
cbar.Label.String = 'Residual /s';

points.MarkerEdgeColor = 'k';
points.LineWidth = 0.1;

ax = gca;
ax.FontSize = 14;
ax.XAxisLocation = 'top';
ax.XLim = [-180 180];
ax.YLim = [0 90];
ax.YDir = 'reverse';
xlabel('Turning Longitude');
ylabel('Depth below ICB /km');

%% Calculate and plot individual velocity models
for i = 1:4
	longMin = longSplit(2*i - 1) + 180;
	longMax = longSplit(2*i) + 180;
	toplot = data((data(:,1) + 180) < longMax,:);
	toplot = toplot((toplot(:,1) + 180) > longMin,:);
	[newVel, velErr] = calcvelmodel(toplot(:,3),toplot(:,4),AK135vel);
	display([num2str(newVel) ', ' num2str(velErr)]);
end

%% Plot residual vs. longitude, with depth control
longToPlot = data(:,1);
depthToPlot = data(:,3);

figure;
points = scatter(longToPlot, depthToPlot,'+');
hline(0);

% Plot formatting
ax = gca;
ax.FontSize = 14;
ax.XLim = [-180 180];
ax.YLim = [-2 2];
color = ax.ColorOrder(1,:);
xlabel('Longitude /deg');
ylabel('Residual /s');

% Make slider to change depth being plotted
slider = uicontrol('Style', 'slider');
slider.Callback = @updatePlot;
slider.Value = 90;
slider.Max = 90;
slider.Min = 10;

	function updatePlot(~, ~)
		minDepth = slider.Value;
		indexesToPlot = data(:,2) < minDepth;
		longToPlot = data(indexesToPlot,1);
		depthToPlot = data(indexesToPlot,3);
		
		delete(points);
		hold on;
		points = scatter(longToPlot, depthToPlot,'+');
		points.MarkerEdgeColor = color;
		hline(0);
		ax.XLim = [-180 180];
		ax.YLim = [-2 2];
	end
end