function stackgrad = back_propagation( ...
  dataCell, topDelta, stack, ...
  poolingRegularization, classifierParams )
%BACK_PROPAGATION Performs back-propagation over the whole networks apart 
% from the top layer.
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

% stackgrad contains gradient of the stack
stackgrad = cell(size(stack));

delta = ...
  classifierParams' * topDelta;

for k = 1:sizeStack
  
  currDelta = delta(k:sizeStack:end,:);
  stackgrad{k}.w = currDelta * dataCell{k}' ...
    + poolingRegularization.compute_gradient(stack{k}.w);
  
end

end

