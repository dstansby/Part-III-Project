clear
folder = 'celebessea';
addpath('Library');
%% Import data
file = fopen([folder '/both_differences.txt']);
synthData = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen([folder '/real_differences.txt']);
realData = fscanf(file,' %f %f', [2 inf]);
fclose(file);
clear file;

synthData = synthData';
realData = realData';

% Calculate errors
realErr = 0.02*ones(size(realData(:,1)));
synthErr = 0.02*ones(size(synthData(:,1)));

% Set of distances common to real and synthetic data
distances = intersect(synthData(:,1),realData(:,1));
resid = zeros([size(distances,1) 2]);
residErr = 0.04*ones([size(resid,1) 1]);

% Calculate residuals
for i = 1:size(distances)
	d = distances(i);
	ri = find(~(realData(:,1) - d));
	si = find(~(synthData(:,1) - d));
	si = si(1);
	
	dt = realData(ri,2) - synthData(si,2);
	resid(i,:) = [d dt];
	clear d dt ri si
end

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
subplot(1,2,1);
hold on;
scatter(resid(:,2),resid(:,1),'+');

ax1 = gca;
herrorbar(resid(:,2),resid(:,1),residErr,ax1.ColorOrder(1,:));
vline(0);

% Plot formatting
ax1.YDir = 'reverse';
ax1.XAxisLocation = 'top';
xlabel('\delta t /s');
ylabel('Epicentral distance /^{\circ}');
ax1.FontSize = 14;
title('Celebes Sea Residuals');

subplot(1,2,2);
scatter(means(:,2),means(:,1),'o');
ax2 = gca;
% This is wrong
%herrorbar(means(:,2),means(:,1),means(:,3),ax2.ColorOrder(1,:));

% Plot formatting
ax2.YDir = 'reverse';
ax2.XAxisLocation = 'top';
xlabel('\delta t /s');
ylabel('Epicentral distance /^{\circ}');
ax2.YLim = ax1.YLim;
ax2.XLim = ax1.XLim;
ax2.FontSize = 14;
title('Celebes Sea residual averages');
vline(0);

%% Plot synthetic and real data separatley
figure;
hold on;
scatter(synthData(:,2),synthData(:,1),'+');
scatter(realData(:,2),realData(:,1),'+');
ax = gca;

herrorbar(synthData(:,2),synthData(:,1),synthErr,ax.ColorOrder(1,:));
herrorbar(realData(:,2),realData(:,1),realErr,ax.ColorOrder(2,:));

% Plot formatting
legend('Synthetic', 'Real')
xlabel('Peak to peak distance /s');
ylabel('Epicentral distance /^{\circ}');
ylim([126 135]);
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.FontSize = 14;
legend('Synthetic','Real');