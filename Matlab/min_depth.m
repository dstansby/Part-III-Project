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

bothdata = bothdata';
idata = idata';
Idata = Idata';

%% Plot figure
figure;
hold on;
scatter(bothdata(:,2),bothdata(:,1),'+');
scatter(idata(:,2),idata(:,1),'+');
scatter(Idata(:,2),Idata(:,1),'+');
ax = gca;

leg = legend('Combined', 'PKIKP', 'PKiKP');
leg.FontSize = 12;
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
ax.XLim = [0.4 1.2];
ax.YLim = [120 130];
ax.FontSize = 16;
grid on;
xlabel('Peak to peak difference /s')
ylabel('Epicentral distance /^{\circ}')