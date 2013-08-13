function [featuresCoding, weightedSum] = forward_propagation( ...
  dataCell, stack)
%FORWARD_PROPAGATION Forward propagation from input data to features.
% 
% In:
%   dataCell - cell array containing data;  
%     so, dataCell{j} is the j-th layer (coordinate)
%     moreover dataCell{j} = data(numSamples, numData) 
%   stack - stack containing parameters per layer, that is
%     stack{j}.w denotes parameter w at layer j
% 
% Out:
%   featuresCoding - features obtained by forward propagation; 
%     featuresCoding(l:numLayers:end, k) denotes pooled descriptors 
%     of the k-th data point and l-th layer
%   weightedSum - weighted sum of data; weightedSum(l:numLayers:end, k) 
%     denotes weighted sum of the k-th data point and l-th layer
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.02.2012
%   

numData = size(dataCell{1}, 2);
nLayers = numel(stack);

% take the total number of features
numHiddenUnitsPerLayer = size(stack{1}.w, 1);
numFeatures = numHiddenUnitsPerLayer * nLayers;

% assert(numel(stack) == length(dataCell), ...
%   'Number of elements of the stack must be equal to the number of layers');

if nargout > 1
  % weightedSum = W * data
  weightedSum = zeros(numFeatures, numData);
  isComputeWeightedSum = true;
else
  isComputeWeightedSum = false;
end

featuresCoding = zeros(numFeatures, numData);

% tic;
for k = 1:nLayers
  z = stack{k}.w * dataCell{k};
    
  featuresCoding(k:nLayers:end, :) = z;
  
  if isComputeWeightedSum
    weightedSum(k:nLayers:end, :) = z;
  end
  
end
% t = toc;
% fprintf('weighted pooling, time %f\n', t);
% keyboard;

end

