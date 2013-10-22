function increase_fonts( pathName, fontSize )
%INCREASE_FONTS Increases fonts of axes.
%
% Params:
%   pathName - path to the image
%   fontSize - font size
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 21.09.2010
% 
inName = [pathName '.fig'];
outName = [pathName '.fig'];

% fighandler = openfig( inName );
% set(get(fighandler,'Children'), 'FontSize', fontSize);
openfig( inName );
set(gca, 'FontSize', fontSize);
saveas(gca, outName);

% clear all;
close all;


end

