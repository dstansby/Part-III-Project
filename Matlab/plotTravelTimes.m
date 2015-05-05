addpath('Library');

%% Import travel times
file = fopen('data/KiK');
PKiKP = fscanf(file,'%f %f',[2 inf]);
PKiKP = PKiKP';

file = fopen('data/PKIKP');
PKIKP = fscanf(file,'%f %f',[2 inf]);
PKIKP = PKIKP';

%% Plot travel times

figure;
hold on;
i = plot(PKiKP(:,1),PKiKP(:,2));
I = plot(PKIKP(:,1),PKIKP(:,2));
l = legend('PKiKP','PKIKP');

% Plot formatting
i.Color = [1 0 0];
I.Color = [0 0 1];

l.Location = 'SouthEast';
l.FontSize = 16;

ax = gca;
ax.FontSize = 14;
ax.XLim = [120 135];

xlabel('Epicentral Distance /deg');
ylabel('Travel time /s');