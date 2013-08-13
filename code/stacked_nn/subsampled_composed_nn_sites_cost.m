function [ cost, grad ] = subsampled_composed_nn_sites_cost( ...
  theta, numFeatures, numClasses, netconfig, ...
  classifierRegularization, poolingRegularization, ...
  dataCell, labels,  isBias)
% Takes a trained theta and a training data set with labels,
% and returns cost and gradient using a stacked perceptron model. 
% It uses sites to compute cost and gradients of particular variable.
% It computes noisy version of the gradient as only subset of data points,
% chosen by oracle, is used.
% 
% Note:
%   1. This function was written based on the UFLDL tutorial
%   (http://ufldl.stanford.edu/wiki/index.php/UFLDL_Tutorial).
% 
% In:
%   theta - the parameter 
%   numFeatures - number of the features (input for the classifier)
%   numClasses - number of classes
%   netconfig - network configuration 
%   classifierRegularization - regularization term for classifier
%   poolingRegularization - regularization term for pooling
%   dataCell - cell array containing data;  
%     dataCell{j} is the j-th layer (coordinate)
%     and dataCell{j} = data(numSamples, numData) 
%   labels - vector containing labels, where labels(j) is the label 
%     for the j-th data point
%   isBias - true if bias is added to the classifier 
%     [optional, by default isBias = false]
% 
% Out:
%   cost - cost of the composed neural network at a given point theta
%   grad - gradient of the composed neural network at a given point theta
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
%  

if ~exist('isBias', 'var') || isempty(isBias)
  isBias = false;
end

%% Setup

if isBias
  biasOffset = 1;
else
  biasOffset = 0;
end

DATA_FRACTION = 1.0;

% number of the subsampled data points
NUM_DATA_POINTS = ceil(size(dataCell{1}, 2)*DATA_FRACTION);

% extract the part which compute the softmax gradient
softmaxTheta = reshape( ...
  theta(1:numClasses*(numFeatures+biasOffset)), ...
  numClasses, numFeatures+biasOffset);

% extract out the "stack"
stack = params2stack(theta(numClasses*(numFeatures+biasOffset)+1:end), ...
  netconfig);
sizeStack = numel(stack);

% choose indices; now oracle is just a random sampler
subdataIndices = randperm(size(dataCell{1}, 2));
subdataIndices = subdataIndices(1:NUM_DATA_POINTS);

% extract the subset of data
dataCell = cellfun(@(x) x(:, subdataIndices), dataCell, ...
  'UniformOutput', false);
labels = labels(subdataIndices);

% compute the normalization term
numData = size(dataCell{1}, 2);
normalization = 1.0 / numData;

% forward propagation method
forward_pass =@(dataCell) ...
  forward_propagation(dataCell, stack);

% back-propagation method
if isBias
  % if there is bias we use only part of the classifier parameters
  backSoftmaxTheta = softmaxTheta(:, 1:end-1);
else
  backSoftmaxTheta = softmaxTheta;
end
back_pass = @(dataCell, topDelta) ...
  back_propagation(dataCell, topDelta, stack, ...
  poolingRegularization, backSoftmaxTheta);

%% Forward propagation 
featuresCoding = forward_pass(dataCell);

if isBias
  featuresCoding = [featuresCoding; ones(1, size(featuresCoding, 2))];
end

%% Compute probability matrix

% matrix containing ones at row j and column i iff. y^i has class j
groundTruth = full(sparse(labels, 1:numData, 1, numClasses, numData));

% compute the probability matrix probMatrix(r,c) = p(y^c=r | x^c; theta);
probMatrix = compute_prob_matrix(softmaxTheta, featuresCoding);
negP = groundTruth - probMatrix;

%% Backpropagation (compute gradient)
delta = -normalization * negP;

softmaxThetaGrad = delta * featuresCoding' ...
  + classifierRegularization.compute_gradient(softmaxTheta);

stackgrad = back_pass(dataCell, delta);

%% Compute cost function
% pooling regularization
poolingReg = 0.0;

for k = 1:sizeStack
  poolingReg = poolingReg + poolingRegularization.eval(stack{k}.w);
end

dataTerm = -normalization * sum(groundTruth .* epslog(probMatrix), 2);
dataTerm = sum(dataTerm);

cost = dataTerm + classifierRegularization.eval(softmaxTheta) + poolingReg;

%% Roll gradient vector
grad = [softmaxThetaGrad(:); stack2params(stackgrad)];

end
