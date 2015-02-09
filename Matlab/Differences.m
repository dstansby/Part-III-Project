clear

%% Import data
file = fopen('both_differences.txt');
synth = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen('real_differences.txt');
real = fscanf(file,' %f %f', [2 inf]);
fclose(file);

synth = synth';
real = real';

% Calculate errors
realErr = 0.02*ones(size(real(:,1)));
synthErr = 0.02*ones(size(synth(:,1)));

% Set of distances common to real and synthetic data
distances = intersect(synth(:,1),real(:,1));
residuals = zeros([size(distances,1) 2]);
differr = 0.04*ones([size(residuals,1) 1]);

% Calculate residuals
for i = 1:size(distances)
	d = distances(i);
	ri = find(~(real(:,1) - d));
	si = find(~(synth(:,1) - d));
	si = si(1);
	
	dt = real(ri,2) - synth(si,2);
	residuals(i,:) = [d dt];
end

%% Find local gradients, and hence local means

meanpoints = (127:1:134)';
means = zeros([size(meanpoints,1) 1]);
for i = 1:size(meanpoints);
	% Find points in 2 degree range
	toaverage = (residuals(:,1) < meanpoints(i)+1) & (residuals(:,1) >= meanpoints(i)-1);
	toaverage = residuals(toaverage,:);
	% If we have too few points to fit a line to
	if size(toaverage,1) <= 2
		continue;
	end
	% Fit straight line to points
	p = polyfit(toaverage(:,2),toaverage(:,1),1);
	means(i) = (meanpoints(i) - p(2))/p(1);
end

%% Plot residuals
figure;
subplot(1,2,1);
scatter(residuals(:,2),residuals(:,1),'+');
scatter(means,meanpoints,'+');
ax = gca;
herrorbar(residuals(:,2),residuals(:,1),differr,ax.ColorOrder(1,:));

vline(0);

% Plot formatting
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
xlabel('\delta t /s');
ylabel('Epicentral distance /^{\circ}');
ax.FontSize = 14;

%% Plot synthetic and real data separatley
figure;
hold on;
scatter(synth(:,2),synth(:,1),'+');
scatter(real(:,2),real(:,1),'+');
ax = gca;

herrorbar(synth(:,2),synth(:,1),synthErr,ax.ColorOrder(1,:));
herrorbar(real(:,2),real(:,1),realErr,ax.ColorOrder(2,:));

% Plot formatting
legend('Synthetic', 'Real')
xlabel('Residual /s');
ylabel('Epicentral distance /^{\circ}');
ylim([126 135]);
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.FontSize = 14;