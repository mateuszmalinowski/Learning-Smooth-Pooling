function stackgrad = back_max_propagation( ...
  dataCell, topDelta, stack, ...
  poolingRegularization, classifierParams)
%BACK_MAX_PROPAGATION Performs back-propagation over the whole
% networks apart from the top layer. Includes max pooling as a last layer
% before the top one.
% 
% In:
%   dataCell - cell array containing data;  
%     so, dataCell{j} is the j-th layer (coordinate)
%     moreover dataCell{j} = data(numSamples, numData) 
%   topDelta - delta from the top layer
%   stack - stack containing parameters per layer, that is
%     stack{j}.w denotes parameter w at layer j
%   poolingRegularization - regularization term for pooling
%   classifierParams - classifier parameters; 
%     matrix(numClasses, numFeatures)
% 
% Out:
%   stackgrad - gradient for different layers
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 17.12.2012
%  

sizeStack = numel(stack);
numPoolingUnits = size(stack{1}.w,1);
% numData = size(dataCell{1}, 2);

% stackgrad contains gradient of the stack
stackgrad = cell(size(stack));

% delta = ...
%   classifierParams' * topDelta .* dx_activation(affineTransformOfCodes);

delta = ...
  classifierParams' * topDelta;

% dx_pooling = zeros(numPoolingUnits, numData);
for k = 1:sizeStack
  
  % currDelta \in R[#pooling_units x #data]
  currDelta = delta(k:sizeStack:end,:);

  % computes subgradient of max_j{w_1j u_j} where u_j is a visual word
  % at location j-th
  for j = 1:numPoolingUnits
    ww = bsxfun(@times, stack{k}.w(j, :)', dataCell{k});
    [~, maxIndices] = max(ww, [], 1);
    currDelta(j, :) = currDelta(j, maxIndices);
  end
  
%   currDelta = currDelta .* dx_pooling;
  
  stackgrad{k}.w = currDelta * dataCell{k}' ...
    + poolingRegularization.compute_gradient(stack{k}.w);
  
end

end

