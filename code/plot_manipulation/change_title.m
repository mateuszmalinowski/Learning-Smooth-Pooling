function change_title( pathName, newTitle, titleFontSize )
%CHANGE_TITTLE Changes the title of the image.
% 
% Params:
%   pathName - path to the image
%   newTitle - new tittle for the image
%   titleFontSize - font size for the title
%     [optional, default = stay the same]
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 23.03.2011
% 

inName = [pathName '.fig'];
outName = [pathName '.fig'];

openfig( inName );
hold on
if nargin == 2
  title(newTitle)
else
  title(newTitle, 'FontSize', titleFontSize);
end
hold off
saveas(gca, outName);

clear all;
close all;

end

