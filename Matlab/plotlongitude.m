clear
folder = 'mozambique';
addpath('Library');
%close all
load('redblue.mat');

%% Import data
realData = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
synthData = readfile(['data/' folder '/PKiKP_differences.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Sanity check peak to peak distances
if min(realData(:,2)) < 0 || min(synthData(:,2)) < 0
	error('At least one peak to peak distance is negative');
end

% Make lattitude span 0 --> 360 deg if we span both sides of 180/-180
if min(stationDetails(:,12)) < 90 && max(stationDetails(:,12)) > 90
	stationDetails(stationDetails(:,12) < 0,12) = stationDetails(stationDetails(:,12) < 0,12) + 360;
end

% Calculate depth below ICB
depths = stationDetails(:,13) - 5153;

%% Calculate residuals
resid(:,1) = realData(:,1);
resid(:,2) = realData(:,2) - synthData(:,2);

% Sort the residuals
[resid,indexes] = sortrows(resid,2);

%% Plot 3D
figure;
colormap(col);
scatter3(stationDetails(indexes,12),stationDetails(indexes,11),depths(indexes),150,resid(:,2),'filled');
ax = gca;

cbar = colorbar;
if abs(min(resid(:,2))) > max(resid(:,2))
	caxis([min(resid(:,2)) abs(min(resid(:,2)))]);
else
	caxis([-max(resid(:,2)) max(resid(:,2))])
end
cbar.Label.String = 'Residual /s';
xlabel('Turning Longitude');
ylabel('Turning Lattitude');
zlabel('Depth below ICB /km');
ax.FontSize = 14;
%ax.ZLim = [0 40];

%% Plot 2D Longitude vs. depth
figure;
colormap(col);
points = scatter(stationDetails(indexes,12),depths(indexes),150,resid(:,2),'filled');

% Add lines to compare with Waszek 2011
%hline(15);
%hline(30);

% Plot formatting
title(folder);

cbar = colorbar;
clim = 0.6;
caxis([-clim clim]);
cbar.Label.String = 'Residual /s';

points.MarkerEdgeColor = 'k';
points.LineWidth = 0.1;

ax = gca;
ax.FontSize = 14;
%ax.YLim = [0 80];
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Turning Longitude');
ylabel('Depth below ICB /km');

%vline(180);