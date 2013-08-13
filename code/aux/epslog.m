function r = epslog( x )
%EPSLOG Epsilon logarithm.
% 
% More precisely epslog(x) = log(x + EPSILON), where EPSILON floating point
% relative accuracy.
% 
% In:
%   x - input
% 
% Out:
%   r - result of the epsilong logarithm function.
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 03.03.2012
%

r = log(x + eps);

end

