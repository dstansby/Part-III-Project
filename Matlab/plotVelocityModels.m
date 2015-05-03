clear

%% Import velocity models
spec = '%f    %f    %*f    %*f';

% AK135
file = fopen('../earthModels/ak135.1.card');
for i=1:3	% Skip first 3 lines
    fgetl(file);
end
AK135 = fscanf(file,spec,[2 inf]);
AK135 = AK135';

% EH
file = fopen('../earthModels/eh.1.card');
for i=1:3
    fgetl(file);
end
EH = fscanf(file,spec,[2 inf]);
EH = EH';

% WH
file = fopen('../earthModels/wh.1.card');
for i=1:3
    fgetl(file);
end
WH = fscanf(file,spec,[2 inf]);
WH = WH';

%% Plot velocity models
figure;
ax = gca;
hold on;
plot(AK135(:,2),AK135(:,1));
plot(WH(:,2),WH(:,1));
plot(EH(:,2),EH(:,1));
l = legend('AK135', 'EH', 'WH');
l.Location = 'southwest';

% Plot formatting
ax.XLim = [10.8 11.2];
ax.YLim = [5150 5220];

xlabel('P wave velocity / km/s');
ylabel('Depth /km');
ax.XAxisLocation = 'top';
ax.YDir = 'reverse';
ax.FontSize = 14;