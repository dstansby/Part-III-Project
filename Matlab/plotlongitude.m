clear
folder = 'celebessea';
addpath('Library');
%close all
load('redblue.mat');

%% Import data
file = fopen([folder '/real_differences.txt']);
realData = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);
clear file;

file = fopen([folder '/stationdetails.txt']);
stationdetails = fscanf(file,'%f %*s %f %f %f %f %f %f %f %f %f %f %f %f', [13 inf]);
fclose(file);
clear file;

file = fopen([folder '/both_differences.txt']);
synthData = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);

realData = realData';
synthData = synthData';
stationdetails = stationdetails';

realData = sortrows(realData);
synthData = sortrows(synthData);
stationdetails = sortrows(stationdetails);

% Make lattitude span 0 --> 360 deg
stationdetails(stationdetails(:,12) < 0,12) = stationdetails(stationdetails(:,12) < 0,12) + 360;
% Change depth into depth below ICB
stationdetails(:,13) = stationdetails(:,13) - 5153;

%% Calculate residuals
resid(:,1) = realData(:,1);
resid(:,2) = realData(:,2) - synthData(:,2);
[resid,indexes]= sortrows(resid,2);

%% Plot 3D
% 
figure;
colormap(col);
scatter3(stationdetails(indexes,12),stationdetails(indexes,11),stationdetails(indexes,13),[],resid(:,2),'filled');
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
%ax.XLim = [150 180];
ax.FontSize = 14;
%ax.ZLim = [0 40];
%ax.XDir = 'reverse';
%ax.ZDir = 'reverse';

%% Plot 2D
figure;
colormap(col);
scatter(stationdetails(indexes,12),stationdetails(indexes,13),100,resid(:,2),'filled');

% Plot formatting
title(folder);
cbar = colorbar;
if abs(min(resid(:,2))) > max(resid(:,2))
	caxis([min(resid(:,2)) abs(min(resid(:,2)))]);
else
	caxis([-max(resid(:,2)) max(resid(:,2))])
end
cbar.Label.String = 'Residual /s';
ax = gca;
ax.FontSize = 14;
ax.YLim = [0 40];
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Turning Longitude');
ylabel('Depth below ICB /km');