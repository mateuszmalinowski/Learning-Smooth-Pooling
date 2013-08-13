function Au = matrix_application( A, u)
%Reshapes image u. 
%  
% Params:
%   A - appropriate operator
%   u - image (matrix)
% 
% Return:
%   Au - Reshaped matrix (three dimensional tensor)
% 
% Usage:
%   Au = A * u
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 20.04.2012
% 

if A.isTensorAsResult
  % produce tensor
  Au = reshape(u, size(u,1), A.nRows, A.nCols);
else
  % produce matrix
  Au = squeeze(reshape(u, size(u,1), A.nRows * A.nCols, 1));
end

end
