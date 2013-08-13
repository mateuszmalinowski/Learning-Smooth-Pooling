function [predClass, featuresCoding] = composed_nn_predict( ...
  theta, netconfig, numFeatures, numClasses, ...
  dataCell, isBias )
%Predict class for the input data. 
% 
% Note:
%   1. This function was written based on UFLDL tutorial
%   (http://ufldl.stanford.edu/wiki/index.php/UFLDL_Tutorial).
% 
% In:
%   theta - the parameter 
%   netconfig - network configuration 
%   numFeatures - number of the features (input for the classifier)
%   numClasses - number of classes
%   dataCell - cell array containing data;  
%     so, dataCell{j} is the j-th layer (coordinate)
%     moreover dataCell{j} = data(numSamples, numData) 
%   isBias - true if we use bias term in the classifier 
%     [optional, by default false]
% 
% Out:
%   predClass - predicted class
%   featuresCoding - encoded features
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.02.2012
%   

if ~exist('isBias', 'var') || isempty(isBias)
  isBias = false;
end

if isBias
  biasOffset = 1;
else
  biasOffset = 0;
end

% Setup
forward_pass =@(dataCell, stackOfWeights) ...
  forward_propagation(dataCell, stackOfWeights);

%% Unroll theta parameter

% We first extract the part which compute the softmax gradient
softmaxTheta = reshape( ...
  theta(1:numClasses*(numFeatures+biasOffset)), ...
  numClasses, numFeatures+biasOffset);

% extract out the "stack"
stack = params2stack( ...
  theta(numClasses*(numFeatures + biasOffset)+1:end), netconfig);

%% forward propagation
featuresCoding = forward_pass(dataCell, stack);

if isBias
  featuresCoding = [featuresCoding; ones(1, size(featuresCoding, 2))];
end

%% softmax classification
probMatrix = compute_prob_matrix(softmaxTheta, featuresCoding);
[~, predClass] = max(probMatrix, [], 1);

end
