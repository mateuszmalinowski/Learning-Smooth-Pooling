function takenTitle = get_title( figureName )
%GET_TITLE Gets title from the image.
% 
% Params:
%   figureName - path 
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 24.03.2011
% 

inName = [figureName '.fig'];
openfig( inName );
takenTitle = get( get( gca, 'title' ), 'string' );

close all;

end

