function [thetaInit, netconfig] = initialize_parameters_randomly( ...
  numHiddenLayers, numPoolingUnits, ...
  numClasses, numSamplesPerDim, isBias)
% Initializes parameters random pooling weights,
% and random initialization for softmax classifier.
% 
% In:
%   numHiddenLayers - number of hidden layers
%   numPoolingUnits - number of hidden units per layer
%   numClasses - number of considered classes
%   nSamplesPerDim - nSamplesPerDim = [prows, pcols] where 
%     prows/pcols denotes number of rows/columns in the code; such number
%     can be used for spatial division of the codes
%   isBias - true if we add bias term to the classifier
% 
% Out:
%   thetaInit - initialized parameters
%   netconfig - structure containing the topology of network
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.02.2012
%  

% set the randomizer
rng(5);

MEAN = 0.5;
MAX_VAL = 1.0;
MIN_VAL = 0.0;

numFeatures = numHiddenLayers * numPoolingUnits;
numSamples = prod(numSamplesPerDim);

if isBias
  numFeatures = numFeatures + 1;
end

% initialize parameters of the classifier
classifierTheta = 0.005 * randn(numClasses, numFeatures);

% perturbation parameters
% r  = sqrt(6) / sqrt(numPoolingUnits+numSamples+1);
r = .05;
two_r = 2*r;

% initialize stack
stack = cell(numHiddenLayers, 1);
for k = 1:numHiddenLayers
%   stack{k}.w = ones(numPoolingUnits, numSamples);
  stack{k}.w = clamp( ...
    MEAN+randn(numPoolingUnits, numSamples)*two_r, MIN_VAL, MAX_VAL);
end

[stackparams, netconfig] = stack2params(stack);

thetaInit = [classifierTheta(:); stackparams];

end
