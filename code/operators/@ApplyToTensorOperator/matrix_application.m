function u = matrix_application( A, u)
%Applies G to the tensor u. 
%  
% Params:
%   A - appropriate operator
%   u - three dimensional tensor
% 
% Return:
%   Au - three dimensional tensor transformed by the operator G
% 
% Usage:
%   Au = A * u
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 20.04.2012
% 

firstDim = size(u, 1);

for ii = 1:firstDim
  u(ii, :, :) = A.G * squeeze(u(ii, :, :));
end

end
