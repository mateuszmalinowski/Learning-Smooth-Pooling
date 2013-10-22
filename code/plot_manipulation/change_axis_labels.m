function change_axis_labels( pathName, newXAxisName, newYAxisName, fontSize )
%CHANGE_AXIS_LABELS Changes labels and fonts of the axes.
%
% Params:
%   pathImage - path to the image
%   newXAxisName - new name for the X-axis
%   newYAxisName - new name for the Y-axis
%   fontSize - font size
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 23.03.2011
% 

inName = [pathName '.fig'];
outName = [pathName '.fig'];

openfig( inName );

hold on
if nargin == 3
  xlabel(gca, newXAxisName);
  ylabel(gca, newYAxisName);
else
  xlabel(gca, newXAxisName, 'FontSize', fontSize);
  ylabel(gca, newYAxisName, 'FontSize', fontSize);
end
hold off

saveas(gca, outName);

clear all;
close all;

end
