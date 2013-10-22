function remove_axis(pathName)
% Removes axis from the plot.
%
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 22.09.2010
% 

name = [pathName '.fig'];
openfig( name );
axis off;

% make square image
axis square;

% saveas(get(fighandler, 'Children'), name);
saveas(gca, name);

clear all;
close all;