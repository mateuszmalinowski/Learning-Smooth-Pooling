function blow_up( pathName, xLimits, yLimits )
% Blows up the image.
%
% Params:
%   pathName - path to the image
%   xLimits - limits for x-axis
%   yLimits - limits for y-axis
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 21.09.2010
% 

inName = [pathName '.fig'];
outName = [pathName '_zoom.fig'];

fighandler = openfig( inName );
set(get(fighandler,'Children'), 'XLim', xLimits);
set(get(fighandler,'Children'), 'YLim', yLimits);
saveas(get(fighandler, 'Children'), outName);

clear all;
close all;

end
