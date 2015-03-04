clear
%close all
folder = 'celebessea';
addpath('Library');
%% Import data
file = fopen([folder '/both_differences.txt']);
file = fopen(['data/' folder '/both_differences.txt']);
synthData = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);

file = fopen(['data/' folder '/real_differences.txt']);
realData = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);
clear file;

file = fopen(['data/' folder '/stationdetails.txt']);
stationdetails = fscanf(file,'%f %*s %f %f %f %f %f %f %f %f %f %f %f %f', [13 inf]);
fclose(file);
clear file;

synthData = synthData';
realData = realData';
stationdetails = stationdetails';

synthData = sortrows(synthData);
realData = sortrows(realData);
stationdetails = sortrows(stationdetails);

% Make lattitude span 0 --> 360 deg
stationdetails(stationdetails(:,12) < 0,12) = stationdetails(stationdetails(:,12) < 0,12) + 360;
% Change depth into depth below ICB
stationdetails(:,13) = stationdetails(:,13) - 5153;

% Calculate residuals
resid(:,1) = realData(:,1);
resid(:,2) = realData(:,2) - synthData(:,2);

% Calculate errors
realErr = 0.02*ones(size(realData(:,1)));
synthErr = 0.02*ones(size(synthData(:,1)));
residErr = 0.04*ones(size(resid(:,1)));

%% Find local gradients, and hence local means

% Means stores Distance;Residual;Error in residual
means(:,1) = [127.5 ; 132.5];
means(:,2:3) = zeros([size(means,1) 2]);
for i = 1:size(means);
	x = means(i,1);
	% Find points in 2 degree range
	toaverage = (resid(:,1) < x+2.5) & (resid(:,1) >= x-2.5);
	toaverage = resid(toaverage,:);
	% If we have too few points to fit a line to
	if size(toaverage,1) <= 2
		continue;
	end
	% Fit straight line to points
	[p,S] = polyfit(toaverage(:,1),toaverage(:,2),1);
	means(i,2) = p(1)*x + p(2);
	[y,delta] = polyval(p,x,S);
	% This is wrong
	means(i,3) = delta;
	clear y delta p S
end

%% Plot residuals
figure;
%subplot(1,2,1);
hold on;
scatter(resid(:,2),stationdetails(:,13),'+');

ax1 = gca;
herrorbar(resid(:,2),stationdetails(:,13),residErr,ax1.ColorOrder(1,:));
vline(0);

% Plot formatting
ax1.YDir = 'reverse';
ax1.XAxisLocation = 'top';
xlabel('\delta t /s');
ylabel('Depth below ICB /km');
ax1.FontSize = 14;
title('Celebes Sea Residuals');

% subplot(1,2,2);
% scatter(means(:,2),stationdetails(:,1),'o');
% ax2 = gca;
% % This is wrong
% %herrorbar(means(:,2),means(:,1),means(:,3),ax2.ColorOrder(1,:));
% 
% % Plot formatting
% ax2.YDir = 'reverse';
% ax2.XAxisLocation = 'top';
% xlabel('\delta t /s');
% ylabel('Epicentral distance /^{\circ}');
% ax2.YLim = ax1.YLim;
% ax2.XLim = ax1.XLim;
% ax2.FontSize = 14;
% title(folder);
% vline(0);

%% Plot synthetic and real data separatley
figure;
hold on;
scatter(synthData(:,2),stationdetails(:,13),'+');
scatter(realData(:,2),stationdetails(:,13),'+');
ax = gca;

herrorbar(synthData(:,2),stationdetails(:,13),synthErr,ax.ColorOrder(1,:));
herrorbar(realData(:,2),stationdetails(:,13),realErr,ax.ColorOrder(2,:));

% Plot formatting
legend('Synthetic', 'Real')
title(folder);
xlabel('Peak to peak distance /s');
ylabel('Depth below ICB /km');
ax.YLim = [0 40];
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.FontSize = 14;
legend('Synthetic','Real');