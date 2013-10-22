function zoom_plot( pathName, xLimits, yLimits, outSuffixName )
% Blows up the image.
%
% Params:
%   pathName - path to the image
%   xLimits - limits for x-axis
%   yLimits - limits for y-axis 
%   outSuffixName - suffix of the output name; the whole output name is
%     [pathName outSuffixName '.fig']
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 23.03.2011
% 

inName = [pathName '.fig'];
outName = [pathName outSuffixName '.fig'];

fighandler = openfig( inName );
set(get(fighandler,'Children'), 'XLim', xLimits);
set(get(fighandler,'Children'), 'YLim', yLimits);
saveas(gca, outName);

clear all;
close all;

end
