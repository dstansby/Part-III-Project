function plotAllLongitude
clear
addpath('Library');
load('redblue.mat','col');
load('ICBdepth.mat','ICBdepth');

toplot = [];
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
	
	resid(:,3) = realData(:,2) - synthData(:,2);
	resid(:,1) = stationDetails(:,12);
	resid(:,2) = stationDetails(:,13);
	
	% Remove shallower than 10km
	resid = resid(resid(:,2) > 10,:);
	
	% Store longitude, depth, residual
	toplot = vertcat(toplot,horzcat(resid(:,1),resid(:,2),resid(:,3)));
	clear resid realData synthData stationDetails;
end
nopoints = size(toplot,1);
disp(['Plotting ' num2str(nopoints) ' points']);

%% Plot longitude/depth data
figure;
colormap(col);
points = scatter(toplot(:,1),toplot(:,2),75,toplot(:,3),'filled');

% Add lines to compare with Waszek 2011
hline([10 15 30]);

% Add lines to split up data
vline([150 -170]);	% Celebes sea etc.
vline([-90 -75]);		% South Sandwich Islands
vline([-30 0]);
vline([0 60]);

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
%% Plot residual vs. longitude, with depth control
longToPlot = toplot(:,1);
depthToPlot = toplot(:,3);

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
		indexesToPlot = toplot(:,2) < minDepth;
		longToPlot = toplot(indexesToPlot,1);
		depthToPlot = toplot(indexesToPlot,3);
		
		delete(points);
		hold on;
		points = scatter(longToPlot, depthToPlot,'+');
		points.MarkerEdgeColor = color;
		hline(0);
		ax.XLim = [-180 180];
		ax.YLim = [-2 2];
	end
end