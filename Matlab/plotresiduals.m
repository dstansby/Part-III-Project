clear
%close all
folder = 'tanzania';
addpath('Library');
%% Import data
realData = readfile(['data/' folder '/real_differences.txt'],'%*s %f %f',2);
synthData = readfile(['data/' folder '/both_differences.txt'],'%*s %f %f',2);
stationDetails = readfile(['data/' folder '/stationdetails.txt'], '%f %*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f',15);

% Make lattitude span 0 --> 360 deg
stationDetails(stationDetails(:,12) < 0,12) = stationDetails(stationDetails(:,12) < 0,12) + 360;

% Change depth into depth below ICB
stationDetails(:,13) = stationDetails(:,13) - 5153;

%% Calculate residuals and errors
resid(:,1) = realData(:,1);
resid(:,2) = realData(:,2) - synthData(:,2);

realErr = 0.02*ones(size(realData(:,1)));
synthErr = 0.02*ones(size(synthData(:,1)));
residErr = 0.04*ones(size(resid(:,1)));

%% Calculate velocity perturbations
innerCoreTimes = stationDetails(:,15) - stationDetails(:,14);

deltaV(:,1) = resid(:,1);
deltaV(:,2) = resid(:,2)./innerCoreTimes;

%% Plot residuals
figure;
subplot(1,2,2);
hold on;
scatter(resid(:,2),stationDetails(:,13),'+');

ax1 = gca;
herrorbar(resid(:,2),stationDetails(:,13),residErr,ax1.ColorOrder(1,:));
vline(0);

% Plot formatting
ax1.YDir = 'reverse';
ax1.XAxisLocation = 'top';
xlabel('Residual /s');
ylabel('Depth below ICB /km');
ax1.FontSize = 14;
title(folder);

%% Plot synthetic and real data separatley
%figure;
subplot(1,2,1)
hold on;
scatter(synthData(:,2),stationDetails(:,13),'+');
scatter(realData(:,2),stationDetails(:,13),'+');
ax = gca;

herrorbar(synthData(:,2),stationDetails(:,13),synthErr,ax.ColorOrder(1,:));
herrorbar(realData(:,2),stationDetails(:,13),realErr,ax.ColorOrder(2,:));

% Plot formatting
legend('Synthetic', 'Real')
title(folder);
xlabel('Peak to peak distance /s');
ylabel('Depth below ICB /km');
%ax.YLim = [0 40];
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.FontSize = 14;
legend('Synthetic','Real');