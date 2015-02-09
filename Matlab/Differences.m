clear

file = fopen('both_differences.txt');
synth = fscanf(file,' %f %f', [2 inf]);
fclose(file);

file = fopen('real_differences.txt');
real = fscanf(file,' %f %f', [2 inf]);
fclose(file);

synth = synth';
real = real';

realErr = 0.02*ones(size(real(:,1)));
synthErr = 0.02*ones(size(synth(:,1)));

%synth = synth((synth(:,1) > 126),:);

hold on;
scatter(synth(:,2),synth(:,1),'+');
herrorbar(synth(:,2),synth(:,1),synthErr,'b');
scatter(real(:,2),real(:,1),'+');
herrorbar(real(:,2),real(:,1),realErr,'r');

ylabel('Epicentral distance /degrees');
xlabel('Residual /s');
ylim([126 135]);
