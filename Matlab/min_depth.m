clear
folder = 'celebessea';

file = fopen(['data/' folder '/both_differences.txt']);
bothdata = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);

file = fopen(['data/' folder '/pkikp_differences.txt']);
idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen(['data/' folder '/KIKP_differences.txt']);
Idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

% Put all data in a single variable
data = cell(1,3);
data{1} = bothdata;
data{2} = idata;
data{3} = Idata;

for i=1:numel(data)
	data{i} = data{i}';
	data{i} = data{i}((121 < data{i}(:,1)),:);
	data{i} = data{i}((data{i}(:,1) < 127),:);
end

%% Find best fit lines
bestFit = cell(1,3);
for i=1:numel(data)
		p = polyfit(data{i}(:,1),data{i}(:,2),1);
		bestFit{i}(:,1) = 121:0.2:127;
		bestFit{i}(:,2) = polyval(p,bestFit{i}(:,1));
end

%% Plot figure
figure;
hold on;
ax = gca;

% Scatter plot data
for i=1:numel(data)
	scatter(data{i}(:,2), data{i}(:,1),'filled','MarkerFaceColor',ax.ColorOrder(i,:));
end
legend('Combined', 'PKIKP', 'PKiKP');

% Plot lines of best fit
for i=1:numel(data)
	plot(bestFit{i}(:,2), bestFit{i}(:,1),'Color',ax.ColorOrder(i,:));
end

% Plot formatting
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
ax.XLim = [0.5 0.9];
ax.YLim = [121 127];
ax.FontSize = 14;
grid on;
xlabel('Peak to peak difference /s')
ylabel('Epicentral distance /^{\circ}')