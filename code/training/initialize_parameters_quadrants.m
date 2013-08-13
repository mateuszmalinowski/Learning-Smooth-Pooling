function [thetaInit, netconfig] = initialize_parameters_quadrants( ...
  numHiddenLayers, numPoolingUnits, ...
  numClasses, nSamplesPerDim, isBias)
%INITIALIZE_PARAMETERS_QUADRANTS Initialize parameters over quadrants
% (regions 2-by-2).
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
% Created: 12.04.2012
%  

assert(numPoolingUnits == 4, ...
  ['For now using quadrants as an initializer requires' ...
  '4 hidden units per layer'])

% number of features
numFeatures = numHiddenLayers * numPoolingUnits;

if isBias
  numFeatures = numFeatures + 1;
end

% number of samples
numSamples = prod(nSamplesPerDim);

%% initialize parameters of the classifier
classifierTheta = 0.005 * randn(numClasses, numFeatures);

%% initialize stack

halfr = round(nSamplesPerDim(1)/2);
halfc = round(nSamplesPerDim(2)/2);

stack = cell(numHiddenLayers, 1);
for k = 1:numHiddenLayers
  
  stack{k}.w = zeros(numPoolingUnits, numSamples);

  w = reshape( ...
    stack{k}.w, numPoolingUnits, nSamplesPerDim(1), nSamplesPerDim(2));
  
  w(1, 1:halfr, 1:halfc) = 1;
  w(2, halfr+1:end, 1:halfc) = 1;
  w(3, 1:halfr, halfc+1:end) = 1;
  w(4, halfr+1:end, halfc+1:end) = 1;
  
  stack{k}.w = reshape(w, numPoolingUnits, numSamples);
  
end

%% Vectorize parameters
[stackparams, netconfig] = stack2params(stack);

thetaInit = [classifierTheta(:); stackparams];

end

