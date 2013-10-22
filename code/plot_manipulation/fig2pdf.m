function fig2pdf(name, isBlackAndWhite)
% Converts .fig to .pdf.
%
% Input:
%   name - path
%   isBlackAndWhite - true if we want to convert into black & white
%     [optional, default = true]
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 21.09.2010
% 

if exist( 'isBlackAndWhite', 'var' ) == true
  fig2eps(name, isBlackAndWhite);
else
  fig2eps(name);
end
eps2pdf(name);

system(['rm ' name '.eps']);

end