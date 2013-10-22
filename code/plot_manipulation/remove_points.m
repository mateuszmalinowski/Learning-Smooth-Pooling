function remove_points(name, solverName)
% Remove points from plot and adapted in names.
%
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 21.09.2010
% 

name = [name '.fig'];
fighandler = openfig( name );
set(get(get(fighandler,'Children'), 'Children'), 'Marker', 'None');
set(get(get(fighandler,'Children'), 'Children'), 'LineStyle', '-');
title(solverName)
saveas(get(fighandler, 'Children'), name);


clear all;
close all;
