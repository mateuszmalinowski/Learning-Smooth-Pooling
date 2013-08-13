function TestGradientSites()
% Check the gradients for the composed neural network with sites.
% 
% It does the gradient checking; it checks analytical gradient against its 
% numerical version.
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 19.04.2012
%  

%% Setup (small toy model)

EPSILON = 1e-7;

% inputSize = 4;      % also dimensionality of samples
dictionarySize = 10;  % number of codes
numPoolingUnits = 4;   % num of pooling neurons
numHiddenLayers = dictionarySize;  % number of hidden layers
numData = 5;          % number of data points
numSamples = 16;       % number of samples extracted per data point
numClasses = 2;

% model's hyperparameters
lambda = 0.01;  % regularization weight for the classifier
poolingWeight = 0.04; % regularization weight for pooling
gradientWeight = 0.01; % regularization weight for gradient of w

% approximation 'strength' to the max-function
alpha = 1.0;

% true if we want to map input into exp-space
% isExponentialMapping = false;
isExponentialMapping = true;

% if true then weights are constrained to get values between 0 and 1
% isWeightConstraints = true;
isWeightConstraints = false;

%% Fill with data

% generates data
dataCellArray = cell(dictionarySize, 1);
for k = 1:dictionarySize
  dataCellArray{k} = randn(numSamples, numData); 
  
  if isExponentialMapping
    dataCellArray{k} = exp(alpha * abs(dataCellArray{k}));
  end
  
end
labels = randi(numClasses, numData, 1);

% initialize weights
stack = cell(numHiddenLayers,1);
for k = 1:numHiddenLayers
  stack{k}.w = 0.1 * randn(numPoolingUnits, numSamples);
  
  if isWeightConstraints
    stack{k}.w = clamp(stack{k}.w + 0.5, 0, 1);
  end
  
end

numFeatures = numPoolingUnits * numHiddenLayers;
softmaxTheta = 0.005 * randn(numClasses, numFeatures);

[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [ softmaxTheta(:) ; stackparams ];

%% Initialize regularizers

% define finite difference operator
gradOpHoriz = GradientOperator(GradientOperator.HORIZONTAL);
gradOpVert = GradientOperator(GradientOperator.VERTICAL);

% reshape and apply operators
nRows = floor(sqrt(numSamples));
nCols = floor(sqrt(numSamples));
R = ReshapeToTensorOperator(nRows, nCols);
Rt = R';
applyOpHoriz = ApplyToTensorOperator(gradOpHoriz);
jointOpHoriz = JointOperator(applyOpHoriz, R);
jointOpHoriz = JointOperator(Rt, jointOpHoriz);

applyOpVert = ApplyToTensorOperator(gradOpVert);
jointOpVert = JointOperator(applyOpVert, R);
jointOpVert = JointOperator(Rt, jointOpVert);

% classifier regularizer
classifierTwoNorm = TwoNorm(lambda);

% pooling regularizer
poolingTwoNorm = TwoNorm(poolingWeight);
% poolingBiggerThanZero = SmallerThanA(-moreZeroWeight, 0);
% poolingSmallerThanOne = SmallerThanA(lessOneWeight, 1);
% poolingGradientHoriz = TwoNormOnOperator(jointOpHoriz, gradientWeight);
% poolingGradientVert = TwoNormOnOperator(jointOpVert, gradientWeight);
poolingGradientHoriz = OneNormOnOperator(jointOpHoriz, gradientWeight);
poolingGradientVert = OneNormOnOperator(jointOpVert, gradientWeight);

% feed sites manager with priors
classifierPrior = SitesManager(classifierTwoNorm);
% % poolingPrior = SitesManager( ...
% %   poolingTwoNorm, ...
% %   poolingGradientHoriz, poolingGradientVert, ...
% %   poolingBiggerThanZero, poolingSmallerThanOne);
poolingPrior = SitesManager( ...
  poolingTwoNorm, ...
  poolingGradientHoriz, poolingGradientVert);

%% Compute gradients
tic;
[~, grad] = composed_nn_sites_cost(stackedAETheta, numFeatures, ...
  numClasses, netconfig, classifierPrior, poolingPrior, ...
  dataCellArray, labels, false);
t = toc;

numgrad = compute_numerical_gradient( @(x) composed_nn_sites_cost(x, ...
  numFeatures, numClasses, netconfig, ...
  classifierPrior, poolingPrior, ...
  dataCellArray, labels, false), stackedAETheta);

%% Verification

% Compare numerically computed gradients with the ones obtained
% from backpropagation
diff = norm(numgrad-grad)/norm(numgrad+grad);

if diff >= EPSILON
  disp([numgrad grad]);
end

assert(diff < EPSILON, ...
  ['Numerical and analytical gradients differ too much; ' ...
  'difference is ' num2str(diff)]);
            
end
