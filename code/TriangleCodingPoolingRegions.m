function TriangleCodingPoolingRegions(currentPart, ~)
% Trains the pooling regions on the triangle codes.
% 
% In:
%   currentPart - current part (important if a feature vector was split
%     into smaller batches/parts), pooling regions can then be trained in
%     parallel; if it is not applicable then set to 0
% 
% Created by: Mateusz Malinowski
% E-mail: mmalinow@mpi-inf.mpg.de
% 

if isdeployed && ischar(currentPart)
  currentPart = str2double(currentPart);
end

%% Manual Configuration (can be change, or adjusted to new setting)
conf = Configuration;

% choice of dataset
currentDataset = conf.working_dataset;

numCentroids = conf.dictionary_size;

% true if we want to use bias in the classifier
isBias = conf.isBias;

% size of the patches
patchSize = 6;

imageSize=[32 32 3];

% neural network setting
numHiddenLayers = numCentroids;
numPoolingUnits = 4; % use pooling units
numFeatures = numHiddenLayers * numPoolingUnits;

% maximal number of iterations for training
maxTrainingIterations = 3000;

% defines the projection function
projectionFunction =@(x, nFeats, nClass) clamp_pooling_weights( ...
  x, 0, 1, nFeats, nClass);
% projectionFunction =@(x, a, b) x;

% pooling initialization
pooling_initializer = @initialize_parameters_quadrants;

% true if we downsample code
isDownsampling = true;

% original dictionary size (before the split; valid only if currentPart>0)
if currentPart > 0
  originalDictSize = conf.original_dictionary_size;
  
  fprintf('Original code %d, batch dimensionality %d, part %d\n', ...
    originalDictSize, numCentroids, currentPart);
end

% true if we want to apply the mean centering on the codes
isShiftCodesAroundMean = true;

% true if we want to normalized codes to have unit variance
isCovarianceNormalization = true;

% true if we want to whiten the codes
isCodesWhitening = true;

% hyperparameters
classifierWeight = 0.001;
poolingWeight = 0.0;
spatialSmoothingWeight = 0.01;

%% Automatic Configuration (don't change it)

if currentPart > 0
  % true if there are parts
  isPartsComputed = true;
else
  isPartsComputed = false;
end

% computes number of samples per dimension
numSamplesPerDimension = [imageSize(1) imageSize(2)] - patchSize + 1;

if isDownsampling
  downsamplingFactor = 3.0;
  numSamplesPerDimension = numSamplesPerDimension/downsamplingFactor;
end

%% Choice of the data loader
if strcmp(currentDataset, conf.CIFAR10)
  train_loader = @(x) load_train_batch_data(x);
  test_loader = @(x) load_test_batch_data(x);
  currentDatasetPathname = conf.CIFAR10_DATASET;
elseif strcmp(currentDataset, conf.CIFAR100)
  train_loader = @(x) load_train_fine_labeled_data(x);
  test_loader = @(x) load_test_fine_labeled_data(x);
  currentDatasetPathname = conf.CIFAR100_DATASET;
end

%% Directories

datasetDir = fullfile(conf.dataset_dir, currentDatasetPathname);

suffix = '';
if isDownsampling
  suffix = [suffix 'Downsampling'];
end

if isPartsComputed
  suffix = [suffix '-od_' num2str(originalDictSize) ...
    '-part_' num2str(currentPart)];
end

PATH_TO_STORE_TRAIN_CODES = fullfile(conf.local_dir, currentDataset, ...
  ['trainCodes_d' num2str(numCentroids) suffix '.mat']);

PATH_TO_STORE_TEST_CODES = fullfile(conf.local_dir, currentDataset, ...
  ['testCodes_d' num2str(numCentroids) suffix '.mat']);

PATH_TO_STORE_GENERALIZED_POOLING_PARAMS = fullfile(conf.local_dir, ...
  currentDataset, ...
  ['poolingOpt_d' num2str(numCentroids) ...
  '_iter' num2str(maxTrainingIterations) ...
  '-poolingUnits_' num2str(numPoolingUnits) suffix  '.mat']);

%% Welcome screen
fprintf('Learnable pooling regions welcome you with %s dataset\n', ...
  currentDataset);
 
%% Load training data

[~, trainY] = train_loader(datasetDir);

numCategories = length(unique(trainY));

%% Initialize the pooling regions
disp('Initialize  the pooling regions');
  
[thetaInit, netconfig] = pooling_initializer( ...
  numHiddenLayers, numPoolingUnits, ...
  numCategories, numSamplesPerDimension, isBias);

%% Welcome message and load patches to train
disp('Start coding generalized pooling with sites')

l = load(PATH_TO_STORE_TRAIN_CODES);
trainCodes = l.trainCodes;

%% Initialize regularizers

% feed sites manager with priors
classifierPrior = SitesManager();

if classifierWeight ~= 0
  cat(classifierPrior, SitesManager(TwoNorm(classifierWeight)));
else
  classifierPrior = NullMapper();
end

poolingPrior = SitesManager();

if poolingWeight == 0 && spatialSmoothingWeight == 0
  poolingPrior = NullMapper();
end

if poolingWeight ~= 0
  cat(poolingPrior, SitesManager(TwoNorm(poolingWeight)));
end

if spatialSmoothingWeight ~= 0
  
  % set up finite differences
  gradHoriz = GradientOperator(GradientOperator.HORIZONTAL);
  gradVert = GradientOperator(GradientOperator.VERTICAL);
  
  R = ReshapeToTensorOperator(numSamplesPerDimension(1), numSamplesPerDimension(2));
  Rt = R';
  applyOpHoriz = ApplyToTensorOperator(gradHoriz);
  jointOpHoriz = JointOperator(applyOpHoriz, R);
  jointOpHoriz = JointOperator(Rt, jointOpHoriz);

  applyOpVert = ApplyToTensorOperator(gradVert);
  jointOpVert = JointOperator(applyOpVert, R);
  jointOpVert = JointOperator(Rt, jointOpVert);
  
  poolingGradHoriz = TwoNormOnOperator(jointOpHoriz,spatialSmoothingWeight);
  poolingGradVert = TwoNormOnOperator(jointOpVert, spatialSmoothingWeight);
  
  cat(poolingPrior, SitesManager(poolingGradHoriz));
  cat(poolingPrior, SitesManager(poolingGradVert));
  
end

%% Shift training codes around the mean if needed
if isShiftCodesAroundMean
  % codes{j} = data(numSamples, numImages) for j-th code (coordinate)
  [trainCodes, meanTrainCodes] = codes_mean_centering(trainCodes);
end

%% Normalize codes to have unit variance if needed
if isCovarianceNormalization
  % codes{j} = data(numSamples, numImages) for j-th code (coordinate)
  [trainCodes, stdTrainCodes] = codes_covariance_normalization(trainCodes);
end

%% Whiten codes if needed
if isCodesWhitening
  
  assert(isCodesWhitening == isShiftCodesAroundMean, ...
    'Whitening of the codes requires centering data around origin');
  
  [trainCodes, whitenMatrix] = codes_whitening(trainCodes);
end

%% Train the pooling regions together with classifier

projFun =@(x) projectionFunction(x, numFeatures, numCategories);

thetaOpt = train_generalized_pooling_sites( ...
  trainCodes, trainY, numCategories, ...
  thetaInit, netconfig, numFeatures, ...
  classifierPrior, poolingPrior, ...
  maxTrainingIterations, projFun, isBias);

projectionName = func2str(projectionFunction); %#ok, save
save(PATH_TO_STORE_GENERALIZED_POOLING_PARAMS, ...
  'thetaOpt', 'netconfig', 'numCategories', 'numFeatures', ...
  'poolingWeight', 'classifierWeight', 'spatialSmoothingWeight', ...
  'numCentroids', 'numPoolingUnits', 'maxTrainingIterations', ...
  'projectionName', '-v7.3');

predTrain = composed_nn_predict( ...
  thetaOpt, netconfig, numFeatures, ...
  numCategories, trainCodes, isBias)';

trainAcc = 100 * (1 - sum(predTrain ~= trainY) / length(trainY));
fprintf('Train accuracy %f%%\n', trainAcc);

%% Test classification 

% Load the test data
fprintf('Loading test data...\n');

[~, testY] = test_loader(datasetDir);

% load test codes
l = load(PATH_TO_STORE_TEST_CODES);
testCodes = l.testCodes;

% Shift test codes around the mean of the training codes if needed
if isShiftCodesAroundMean
  % codes{j} = data(numSamples, numImages) for j-th code (coordinate)
  testCodes = codes_mean_centering(testCodes, meanTrainCodes);
end

% normalize the test codes to have unit variance
if isCovarianceNormalization
  % codes{j} = data(numSamples, numImages) for j-th code (coordinate)
  testCodes = codes_covariance_normalization(testCodes, stdTrainCodes);
end

% whiten test codes if needed
if isCodesWhitening
  testCodes = codes_whitening(testCodes, whitenMatrix);
end

% test and print result
numCategories = length(unique(testY));
predTest = composed_nn_predict( ...
  thetaOpt, netconfig, numFeatures, ...
  numCategories, testCodes, isBias)';

testAcc = 100 * (1 - sum(predTest ~= testY) / length(testY));
fprintf('Test accuracy %f%%\n', testAcc);

%% Display results

print_hyperparams([], numCentroids, classifierWeight, poolingWeight, ...
  [], [], spatialSmoothingWeight, ...
  maxTrainingIterations, [], [], func2str(projectionFunction));

fprintf('Number of pooling neurons: %d\n', numPoolingUnits);

disp('Matlab OOP was used with ');
disp('classifier sites:');
disp(classifierPrior);
disp('pooling sites:');
disp(poolingPrior);

if isShiftCodesAroundMean
  disp('Codes were shifted around the mean');
end

if isCovarianceNormalization
  disp('Codes were normalized to have an unit variance');
end

if isCodesWhitening
  disp('Codes were whitened');
end

if isDownsampling
  disp('downsampling was performed');
end

if isPartsComputed
  
  fprintf('Part %d was computed\n', currentPart);
  fprintf('Original dictionary size was %d\n', originalDictSize);
  
end

if isBias
  disp('Additional classifier''s bias term is used');
end

end