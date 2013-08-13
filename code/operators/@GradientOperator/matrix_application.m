function Au = matrix_application( A, u)
%Computes the gradient of the image vector u.
%  
% Params:
%   A - appropriate operator
%   u - image (matrix)
% 
% Return:
%   Au - gradient image; either along rows, or columns
% 
% Usage:
%   Au = A * u
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 29.01.2010
% 

du = diff(u, 1, A.dimension);

% we have to also add the boundary condition (otherwise A'Au doesn't
% preserve the size of u);
% here we mirror the boundary
if A.dimension == A.HORIZONTAL
  Au = cat( 2, du, zeros(size(u,1),1) );
elseif A.dimension == A.VERTICAL
  Au = cat( 1, du, zeros(1, size(u,2)) );
else
  error('Unknown dimension. Must be either HORIZONTAL or VERTICAL.');
end

end
