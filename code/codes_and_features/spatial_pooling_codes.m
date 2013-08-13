function q = spatial_pooling_codes( ...
  codes, pRows, pCols, ...
  numPoolingRegionsRows, numPoolingRegionsCols, pooling_op )
% Pool over the spatial regions.
% 
% In:
%   codes - matrix of size pRows x pCols 
%   pRows, pCols - number of rows and columns 
%   numPoolingRegionsRows, numPoolingRegionsCols - 
%     number of pooling regions per row and column
%   pooling_op - pooling operator
% 
% Out:
%   pooled features - matrix of size 
%     (pRows/poolingSizeRow)*(pCols/poolingSizeCol) x numCoordinates
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 26.04.2012
% 

numCoordinates = size(codes, 2);
% 
% reshape to numCoordinates-channel image
codes = reshape(codes, pRows, pCols, numCoordinates);

% pool over quadrants

poolingSizeRow = floor(pRows / numPoolingRegionsRows);
poolingSizeCol = floor(pCols / numPoolingRegionsCols);

% residuals
poolingSizeRowRes = mod(pRows, numPoolingRegionsRows);
poolingSizeColRes = mod(pCols, numPoolingRegionsCols);

q = zeros(numPoolingRegionsRows, numPoolingRegionsCols, numCoordinates);
% q = zeros(numPoolingRegionsRows, numPoolingRegionsCols);

rowInd = 1;
r1=1;
while r1 < pRows
  colInd = 1;
  c1=1;
  
  if poolingSizeRowRes > 0
    r2 = min(r1 + poolingSizeRow, pRows);
    poolingSizeRowRes = poolingSizeRowRes - 1;
  else
    r2 = min(r1 + poolingSizeRow - 1, pRows);
  end
  
  poolingSizeColResCounter = poolingSizeColRes;
  
  while c1 < pCols
    
    if poolingSizeColResCounter > 0
      c2 = min(c1 + poolingSizeCol, pCols);
      poolingSizeColResCounter = poolingSizeColResCounter - 1;
    else
      c2 = min(c1 + poolingSizeCol - 1, pCols);
    end
    
    q(rowInd, colInd, :) = ...
      pooling_op(pooling_op(codes(r1:r2, c1:c2, :), 1), 2);
    
    c1 = c2 + 1;
    colInd = colInd + 1;
  end
  r1 = r2 + 1;
  rowInd = rowInd + 1;
end

q = reshape(q, numPoolingRegionsRows*numPoolingRegionsCols, numCoordinates);

end
