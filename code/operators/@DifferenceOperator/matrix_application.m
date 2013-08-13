function Au = matrix_application( A, u)
%Takes u = [W1;W2] and computes W1 - W2. It is assumed that 
% size(W1) = size(W2)
%  
% Params:
%   A - appropriate operator
%   u - image (matrix)
% 
% Return:
%   Au - W1 - W2, where u = [W1;W2]
% 
% Usage:
%   Au = A * u
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 28.05.2012
% 

nRows = size(u, 1);
nRowsW1 = floor(nRows / 2);

Au = u(1:nRowsW1, :) - u(nRowsW1+1:end, :);

end
