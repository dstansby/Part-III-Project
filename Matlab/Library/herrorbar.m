function herrorbar(x,y,e,colour)

if ~exist('colour', 'var')
	colour = [0.8 0.8 0.8];
end

if size(x) ~= size(y)
	error('The size of x and y must be the same');
end

xleft = x-e;
xright = x+e;

for i = 1:size(xleft)
	line([xleft(i) xright(i)],[y(i) y(i)],'Color',colour);
end