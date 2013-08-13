function gradient = compute_gradient( obj, u )
%COMPUTEGRADIENT Computes gradient.
%
% Params:
%   u - variable
%
% Return:
%   gradient - gradient of the expression
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 19.04.2012
%

gradient = obj.t * u;

end

