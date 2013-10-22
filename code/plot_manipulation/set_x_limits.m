function set_x_limits( pathName, xLimits, outSuffixName )
% Sets limits in x-axis
%
% Params:
%   pathName - path to the image
%   xLimits - limits for x-axis
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
set(gca, 'XLim', xLimits);
hold off;
saveas(gca, outName);

clear all;
close all;

end

