function Au = matrix_application( A, u )
%Computes transpose of the gradient w.r.t. given dimension.
% 
% More precisely, if A is a gradient matrix (diff matrix) then A^T is its
% transpose.
% 
% Params:
%   A - appropriate operator
%   u - image (matrix)
% 
% Return:
%   Au - transposed gradient applied to the image
% 
% Usage:
%   Au = A * u
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 29.01.2010
% 

du = diff(u, 1, A.dimension);

% in addition we have to also add the boundary condition 
% (otherwise A'Au doesn't preserve the size of u);
% here we mirror the boundary
if A.dimension == A.HORIZONTAL
  Au = cat(2, cat( 2, -u(:,1), -du(:,1:end-1) ), u(:,end-1));
elseif A.dimension == A.VERTICAL
  Au = cat(1, cat( 1, -u(1,:), -du(1:end-1,:) ), u(end-1,:));
else
  error('Unknown dimension. Must be either HORIZONTAL or VERTICAL.');
end

end
