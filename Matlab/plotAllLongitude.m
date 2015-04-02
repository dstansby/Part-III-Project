clear
addpath('Library');
load('redblue.mat');
load('ICBdepth.mat');

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
	clear resid realData synthData stationDetails
end
nopoints = size(toplot,1);
disp(['Plotting ' num2str(nopoints) ' points']);

%% Plot data
figure;
colormap(col);
points = scatter(toplot(:,1),toplot(:,2),75,toplot(:,3),'filled');

% Add lines to compare with Waszek 2011
hline(10);
hline(15);
hline(30);

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