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
% Created: 05.02.2013
%

% value = obj.t * sqrt((obj.X * u).^2 + obj.epsilon);

value = obj.t * sum(sum(sqrt((obj.X * u).^2 + obj.epsilon)));

end

