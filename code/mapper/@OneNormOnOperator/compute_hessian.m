function hessian = compute_hessian( obj, ~ )
%COMPUTE_HESSIAN Computes Hessian.
%   
% Return:
%   hessian - Hessian as a function of vector
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 19.04.2012
%

error('Not implemented yet!');

s = numel(u);
hessian = @( v ) obj.t * s;

end

