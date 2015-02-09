function verrorbar(x,y,e,colour)

if size(x) ~= size(y)
	error('The size of x and y must be the same');
end

ybottom = y-e;
ytop = y+e;

for i = 1:size(ybottom)
	line([x(i) x(i)],[ybottom(i) ytop(i)],'Color',colour);
end