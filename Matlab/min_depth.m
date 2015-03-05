clear
folder = 'celebessea';
file = fopen(['data/' folder '/synth_differences.txt']);
bothdata = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);

file = fopen(['data/' folder '/pkikp_differences.txt']);
idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen(['data/' folder '/KIKP_differences.txt']);
Idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);
clear file folder;

% Put all data in a single variable
data = cell(1,3);
data{1} = bothdata;
data{2} = idata;
data{3} = Idata;
clear bothdata idata Idata;

% Transpose and filter data
for i=1:numel(data)
	data{i} = data{i}';
	data{i} = data{i}((121 < data{i}(:,1)),:);
	data{i} = data{i}((data{i}(:,1) < 130),:);
end

%% Find best fit lines
bestFit = cell(1,3);
for i=1:numel(data)
		tofit = data{i}((data{i}(:,2) < 0.75) & (data{i}(:,2) > 0.67),:);
		p = polyfit(tofit(:,1),tofit(:,2),1);
		bestFit{i}(:,1) = 120:0.1:130;
		bestFit{i}(:,2) = polyval(p,bestFit{i}(:,1));
end
clear tofit
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
ax.XLim = [0.6 0.9];
ax.YLim = [121 130];
ax.FontSize = 14;
grid on;
xlabel('Peak to peak difference /s')
ylabel('Epicentral distance /^{\circ}')