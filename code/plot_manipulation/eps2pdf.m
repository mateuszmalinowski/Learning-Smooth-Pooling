function eps2pdf(name)
% Converts .eps to .pdf.
%
% Note:
%   It executes system command 'epstopdf'!
%
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 21.09.2010
% 

system([ 'epstopdf ' name '.eps' ]);

end