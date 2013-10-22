function set_thickness( figurePath, lineWidth )
%SET_THICKNESS Increases thickness of the graph.
% 
% Params:
%   figurePath - path to the figure
%   lineWidth - width of the line
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 04.04.2011
% 

inName = [figurePath '.fig'];
outName = [figurePath '.fig'];

fighandler = openfig( inName );

set( findobj( fighandler, 'type', 'line' ), 'LineWidth', lineWidth );

% save the image
saveas( gca, outName ); 

close all;

end

