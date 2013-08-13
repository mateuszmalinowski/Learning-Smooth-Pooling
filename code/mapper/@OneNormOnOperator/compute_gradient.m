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
% Created: 05.02.2013
%

% gradient = obj.t * ( obj.Xt * (obj.X * u) );

tmp = sqrt((obj.X * u).^2 + obj.epsilon);
tmp = (obj.X * u) ./ tmp;
gradient = obj.t * (obj.Xt * tmp);

end

