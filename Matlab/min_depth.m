clear
folder = 'celebessea';

file = fopen([folder '/both_differences.txt']);
bothdata = fscanf(file,'%*s %f %f', [2 inf]);
fclose(file);

file = fopen([folder '/pkikp_differences.txt']);
idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen([folder '/KIKP_differences.txt']);
Idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

bothdata = bothdata';
idata = idata';
Idata = Idata';

%Idata = Idata((Idata(:,1) < 128),:);

errboth = 0.01*ones([size(bothdata,1) 1]);
erri = 0.01*ones([size(idata,1) 1]);
errI = 0.01*ones([size(Idata,1) 1]);
% 
% % Colours
% bcol = [0 1 1];
% icol = [1 0 0];
% Icol = [0 1 0];

%% Plot figure
figure;
hold on;
scatter(bothdata(:,2),bothdata(:,1),'+');
scatter(idata(:,2),idata(:,1),'+');
scatter(Idata(:,2),Idata(:,1),'+');
ax = gca;

herrorbar(bothdata(:,2),bothdata(:,1),errboth,ax.ColorOrder(1,:));
herrorbar(idata(:,2),idata(:,1),erri,ax.ColorOrder(2,:));
herrorbar(Idata(:,2),Idata(:,1),errI,ax.ColorOrder(3,:));

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