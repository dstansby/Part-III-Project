function data = readfile(location, spec, columns)

file = fopen(location);
data = fscanf(file,spec,[columns inf]);
data = data';

% Clean up
fclose(file);
clear file;