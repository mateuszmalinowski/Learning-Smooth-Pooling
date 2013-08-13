function pooledVal = adaptive_pooling( ...
  patches, weights, prepooling_operator )
%ADAPTIVE_POOLING does adaptive/weighted pooling over the whole patches.
% 
% In:
%   patches - matrix of size numSamples x numCoordinates
%   weights - cell array where weights{k} are weights for k-th coordinate;
%     that is weights{k}.w is a matrix of size 
%     numPoolingRegions x numSamples
%   prepooling_operator - prepooling operator; applied to patches before
%     the pooling happens; optional by default empty
% 
% Out:
%   pooledVal - pooled features 
%     (vector of dimension numPoolingRegions times numCoordinates)
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 07.05.2012
% 

if nargin < 3
  prepooling_operator = [];
end

numCoordinates = size(patches, 2);
% numSamples = size(patches, 1);
numPoolingRegions = size(weights{1}.w, 1);

pooledVal = zeros(numCoordinates, numPoolingRegions);

for k = 1:numCoordinates
  
  currPatches = patches(:, k);
  
  if ~isempty(prepooling_operator)
    currPatches = prepooling_operator(currPatches);
  end
  
  pooledVal(k, :) = weights{k}.w * currPatches;
end

pooledVal = pooledVal(:);

end
