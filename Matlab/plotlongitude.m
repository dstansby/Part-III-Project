clear
folder = 'celebessea';
addpath('Library');
%close all
load('redblue.mat');

%% Import data
realData = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
synthData = readfile(['data/' folder '/both_differences.txt'],'%*s %f %f',2);
stationdeatils = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f',13);

% Make longitude span 0 --> 360 deg
% stationdetails(stationdetails(:,12) < 0,12) = stationdetails(stationdetails(:,12) < 0,12) + 360;
% Calculate depth below ICB
stationdetails(:,14) = stationdetails(:,13) - 5153;

%% Calculate residuals
resid(:,1) = realData(:,1);
resid(:,2) = realData(:,2) - synthData(:,2);

% Sort the residuals
[resid,indexes]= sortrows(resid,2);

%% Plot 3D
figure;
colormap(col);
scatter3(stationdetails(indexes,12),stationdetails(indexes,11),stationdetails(indexes,14),150,resid(:,2),'filled');
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
%ax.XDir = 'reverse';
%ax.ZDir = 'reverse';

%% Plot 2D Longitude vs. depth
figure;
colormap(col);
scatter(stationdetails(indexes,12),stationdetails(indexes,14),150,resid(:,2),'filled');

% Add lines to compare with Waszek 2011
%hline(15);
%hline(30);

% Plot formatting
title(folder);
cbar = colorbar;
% if abs(min(resid(:,2))) > max(resid(:,2))
% 	caxis([min(resid(:,2)) abs(min(resid(:,2)))]);
% else
% 	caxis([-max(resid(:,2)) max(resid(:,2))])
% end
caxis([-1.2 1.2]);
cbar.Label.String = 'Residual /s';

ax = gca;
ax.FontSize = 14;
%ax.YLim = [0 80];
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
xlabel('Turning Longitude');
ylabel('Depth below ICB /km');

%vline(180);

%% Plot Longitude vs residual
% figure
% scatter(stationdetails(indexes,12),resid(:,2));
% hline(0);
% 
% ax = gca;
% ax.FontSize = 14;
% ax.YLim = [-0.8 0.8];
% title(folder);
% xlabel('Turning Longitude');
% ylabel('Residual /s');