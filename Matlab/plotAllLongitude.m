% function plotAllLongitude
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
	
	display(['Processed ' folder ', ' num2str(size(resid,1)) ' points']);
	
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
longSplit = [[150 -170],[-90 -75], [-30 0], [0 60]];
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
ax.YLim = [0 70];
ax.YDir = 'reverse';
xlabel('Turning Longitude');
ylabel('Depth below ICB /km');

% saveas(gcf,'../Write Up/Figures/all_longitude','pdf')

%% Calculate and plot individual velocity models
figure;
l = line([-180 180],[AK135vel, AK135vel], 'Color', [1 0 0]);
legend(l, 'AK135', 'Location', 'East')
for i = 1:4
	longMin = longSplit(2*i - 1);
	longMax = longSplit(2*i);
	
	if longMax > longMin
		toplot = data(data(:,1) < longMax,:);
		toplot = toplot(toplot(:,1) > longMin,:);
	else
		keep = (data(:,1) < longMax | data(:,1) > longMin);
		toplot = data(keep,:);
		clear keep
	end
	
	[newVel, velErr] = calcvelmodel(toplot(:,3),toplot(:,4),AK135vel);
	display([num2str(newVel) ', ' num2str(velErr)]);
	
	hold on
	if longMax > longMin
		rectangle('Position',[longMin (newVel - velErr/2) (longMax - longMin) velErr], 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', [0.8 0.8 0.8]);
		line([longMin longMax],[newVel newVel]);
	else
		rectangle('Position',[longMin (newVel - velErr/2) (180 - longMin) velErr], 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', [0.8 0.8 0.8]);
		rectangle('Position',[-180 (newVel - velErr/2) (180 + longMax) velErr], 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', [0.8 0.8 0.8]);
		line([longMin 180],[newVel newVel]);
		line([-180 longMax],[newVel newVel]);	
	end
	
	clear longMin longMax toplot r
end

ax2 = gca;
ax2.XLim = [-180 180];
ax2.YLim = [11.02 11.12];
ax2.FontSize = 14;
xlabel('Longitude /deg')
ylabel('Velocity / km/s')

%% Plot residual vs. longitude, with depth control
longToPlot = data(:,1);
residToPlot = data(:,3);

figure;
indexesToPlot = data(:,2) < 15 & data(:,2) > 10;
points = scatter(longToPlot(indexesToPlot), residToPlot(indexesToPlot), '+');
hline(0);

% Plot formatting
ax = gca;
ax.FontSize = 14;
ax.XLim = [-180 180];
ax.YLim = [-0.6 0.6];
color = ax.ColorOrder(1,:);
xlabel('Longitude /deg');
ylabel('Residual /s');
title('Residuals measured between 10km - 15km depth')

% % Make slider to change depth being plotted
% slider = uicontrol('Style', 'slider');
% slider.Callback = @updatePlot;
% slider.Value = 15;
% slider.Max = 90;
% slider.Min = 10;
% 
% 	function updatePlot(~, ~)
% 		minDepth = slider.Value;
% 		indexesToPlot = data(:,2) < minDepth;
% 		longToPlot = data(indexesToPlot,1);
% 		depthToPlot = data(indexesToPlot,3);
% 		
% 		delete(points);
% 		hold on;
% 		points = scatter(longToPlot, depthToPlot,'+');
% 		points.MarkerEdgeColor = color;
% 		hline(0);
% 		ax.XLim = [-180 180];
% 		ax.YLim = [-0.6 0.6];
% 	end
% end