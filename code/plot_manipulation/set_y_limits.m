function set_y_limits( pathName, yLimits, outSuffixName )
% Sets limits in y-axis
%
% Params:
%   pathName - path to the image
%   yLimits - limits for y-axis
%   outSuffixName - suffix of the output name; the whole output name is
%     [pathName outSuffixName '.fig']
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 15.04.2011
% 

inName = [pathName '.fig'];
outName = [pathName outSuffixName '.fig'];

openfig( inName );
hold on;
set(gca, 'YLim', yLimits);
hold off;
saveas(gca, outName);

clear all;
close all;

end

