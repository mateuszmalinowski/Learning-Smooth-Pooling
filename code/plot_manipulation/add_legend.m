function add_legend( figurePath, legendNamesCellArray )
%ADD_LEGEND Adds legend to the figure.
% 
% Params:
%   figurePath - path of the figure
%   legendNamesCellArray - cell array of the names in the legend
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 24.03.2011
% 

inName = [ figurePath '.fig' ];

outName = [ figurePath '.fig' ];

openfig( inName );

legend( gca, legendNamesCellArray{:} );

saveas( gca, outName ); 

end

