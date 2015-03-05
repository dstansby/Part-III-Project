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


%% Plot figure
figure;
hold on;
for i=1:numel(data)
	scatter(data{i}(:,2), data{i}(:,1),'+');
end
ax = gca;

leg = legend('Combined', 'PKIKP', 'PKiKP');
leg.FontSize = 12;
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
ax.XLim = [0.5 0.9];
ax.YLim = [121 127];
ax.FontSize = 16;
grid on;
xlabel('Peak to peak difference /s')
ylabel('Epicentral distance /^{\circ}')