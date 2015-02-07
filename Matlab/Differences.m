clear

file = fopen('both_differences.txt');
bothdata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen('pkikp_differences.txt');
idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen('KIKP_differences.txt');
Idata = fscanf(file,' %f %f', [2 inf]);
fclose(file);

bothdata = bothdata';
idata = idata';
Idata = Idata';

Idata = Idata((Idata(:,1) < 128),:);

% errboth = 0.01*ones([size(bothdata,1) 1]);
% erri = 0.01*ones([size(idata,1) 1]);
% errI = 0.01*ones([size(Idata,1) 1]);
% 
% % Colours
% bcol = [0 1 1];
% icol = [1 0 0];
% Icol = [0 1 0];

figure;
hold on;
bhan = scatter(bothdata(:,2),bothdata(:,1),'+');
ihan = scatter(idata(:,2),idata(:,1),'+');
Ihan = scatter(Idata(:,2),Idata(:,1),'+');

% herrorbar(bothdata(:,2),bothdata(:,1),errboth,bcol);
% herrorbar(idata(:,2),idata(:,1),erri,icol);

leg = legend('Combined', 'PKIKP', 'PKiKP');
leg.FontSize = 12;
ax = gca;
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
ax.XLim = [0.6 0.8];
ax.YLim = [120 130];
grid on;
xlabel('Peak to peak difference /s')
ylabel('Epicentral distance /degrees')