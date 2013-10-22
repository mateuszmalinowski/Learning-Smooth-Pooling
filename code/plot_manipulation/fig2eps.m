function fig2eps(name, isBlackAndWhite)
% Converts .fig to .eps.
%
% Params:
%   name - path
%   isBlackAndWhite - true if the output image should be black and white
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 21.09.2010
% 

% check if given name has already extension, if not add extension
[~,~,fileExtension] = fileparts(name);

if isempty(fileExtension)
  open( [ name '.fig' ] );
else
  open( name );
end

if isBlackAndWhite == true
  
  print( '-deps', [name '.eps'] );  % b-w
  
else
  
  print( '-depsc', [name '.eps'] ); % color
  
end

close gcf;
% clear all;

end