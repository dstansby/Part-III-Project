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

distances = intersect(synth(:,1),real(:,1));
diff = zeros([size(distances,1) 2]);
differr = 0.04*ones([size(diff,1) 1]);

for i = 1:size(distances)
	d = distances(i);
	ri = find(~(real(:,1) - d));
	si = find(~(synth(:,1) - d));
	si = si(1);
	
	dt = real(ri,2) - synth(si,2);
	diff(i,:) = [d dt];
end

figure;
scatter(diff(:,2),diff(:,1),'+');
ax = gca;

herrorbar(diff(:,2),diff(:,1),differr,ax.ColorOrder(1,:))
vline(0);

ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
xlabel('\delta t /s');
ylabel('Epicentral distance /^{\circ}');

figure;
hold on;
scatter(synth(:,2),synth(:,1),'+');
herrorbar(synth(:,2),synth(:,1),synthErr,'b');
scatter(real(:,2),real(:,1),'+');
herrorbar(real(:,2),real(:,1),realErr,'r');

ylabel('Epicentral distance /degrees');
xlabel('Residual /s');
ylim([126 135]);
