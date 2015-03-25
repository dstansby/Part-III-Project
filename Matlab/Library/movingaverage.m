function output = movingaverage(input, n)
% MOVINGAVERAGE Create moving average of a data series
%	out = movingaverage(in, n) takes m by 2 matrix 'in' and integer 'n'
%	and outputs the moving average over 'n' points
%
%	David Stansby 2015

if size(input,2) ~= 2
	error('Please provide a m by 2 matrix as input')
end

m = n-1;	% 0 if we are taking a 1 point moving average (ie. doing nothing)

input = sortrows(input);
output = zeros(size(input,1)-m, size(input,2));

for i = 1:(size(xin,1)-m)
	for j = 0:m
		output(i,:) = output(i,:) + input(i+j,:);
	end
end
output = output./n;