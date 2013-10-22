function set_y_ticks( figurePath, yTicks )
% Sets y-ticks in the plot.
% 
% Params:
%   figurePath - path to the figure
%   yTicks - array of ticks in y-axis
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 15.04.2011
% 

inName = [figurePath '.fig'];
outName = [figurePath '.fig'];

openfig( inName );

set( gca, 'YTick', yTicks );

% save the image
saveas( gca, outName ); 

close all;

end

