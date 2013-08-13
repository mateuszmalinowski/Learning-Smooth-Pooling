function value = eval( obj, u )
%EVAL Evaluates the expression.
%
% Params:
%   u - variable
%
% Return:
%   value - value of the expression (real valued)
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 19.04.2012
%

value = obj.t * 0.5 * norm(obj.X * u, 'fro')^2;

end

