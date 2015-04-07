function [newVel, stDev] = calcvelmodel(residuals, innerCoreTimes, oldVel)
% CALCVELMODEL Calculate a new velocity model
%	[newVel, stDev] = calcvelmodel(resid, times, oldVel)
%
%	David Stansby 2015
newVels = oldVel*((residuals./innerCoreTimes) + 1);

newVel = mean(newVels);
stDev = std(newVels);