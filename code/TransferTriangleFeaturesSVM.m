% Train the classifier on top of the pooled regions.
% The script can also concatenate two or more pooling regions obtained 
% from two dictionaries of different size. Classifier is trained then on 
% top of such spatially pooled features.
% 
% Note:
% 1. It is better to consolidate parts using ComputePooledFeatures before.
% 2. Ordering of the features:
%   features(k, :) corresponds to the feature from k-th data point
% 3. This source code also allows to combine features from different
%   dictionaries
% 
% Format of the features's path (example):
%   trainFeatures_adaptivePooling_d40[-dim1600-od1600][-permuted]
%   -transfer_by_codes[-normalization][-whiten][-init][Downsampling]
%   [-normalizedFeats][-whitenFeats]
%   where [a] means a is optional
% 
% Based on the Adam Coates's source code. 
% 
% Adaptation made by: Mateusz Malinowski, email: mmalinow@mpi-inf.mpg.de
% 

function TransferTriangleFeaturesSVM
%% Configuration
conf = Configuration;

% current dataset
dataset = conf.working_dataset;

% the source dataset; used only when transfer between datasets;
% otherwise make it empty
% sourceDataset = [];
sourceDataset = conf.source_dataset;

if strcmp(dataset, conf.CIFAR10)
  datasetName = conf.CIFAR10_DATASET;
elseif strcmp(dataset, conf.CIFAR100)
  datasetName = conf.CIFAR100_DATASET;
else
  error('Unknown dataset');
end

% the classifier hyperprior
classifierHyperParameter = 100;

% original dictionary size; we can use different dictionaries by
% concatenating them
% originalDictSizeArr = [16 32 64];
% originalDictSizeArr = 40;
% originalDictSizeArr = 1600;
originalDictSizeArr = conf.original_dictionary_size;

% array of the split sizes; partsSizeArr(k) corresponds to the parts
% obtained from originalDictSizeArr(k); 
% parts come from the approximation by splitting into batches;
% if empty then we don't use approximation
% partsSizeArr = [16 32 64 40 40 40];
% partsSizeArr = 40;
% partsSizeArr = [40 40];
% partsSizeArr = [];
partsSizeArr = conf.dictionary_size;

% maximal number of allowed iterations
maxIterations = 100;

% true if we want to normalize also features
isFeaturesNormalization = true;

% true if we also want to whiten features
isFeaturesWhitening = true;

% true if we want to do cross-validation
isCrossValidation = false;

% true if we want to save learnt classification model
isSaveClassifierModel = false;

%% Pooling regions setup

% the number of the pooling neurons
numPoolingNeurons = 4;

% true for downsampled version
isDownsampling = true;

%% Welcome screen
disp('Transfer features has begun');

if ~isempty(sourceDataset)
  fprintf('Transfer between datasets, from %s to %s\n', ...
    sourceDataset, dataset);
end

%% Choice of the data loader
if strcmp(dataset, conf.CIFAR10)
  train_loader = @(x) load_train_batch_data(x);
  test_loader = @(x) load_test_batch_data(x);
elseif strcmp(dataset, conf.CIFAR100)
  train_loader = @(x) load_train_fine_labeled_data(x);
  test_loader = @(x) load_test_fine_labeled_data(x);
end

%%  Load data
datasetPath = fullfile(conf.dataset_dir, datasetName);

fprintf('Loading data (%s dataset)\n', dataset);
[~, trainY] = train_loader(datasetPath);
[~, testY] = test_loader(datasetPath);

numTrainData = length(trainY);
numTestData = length(testY);

suffix = ['-poolingUnits_' num2str(numPoolingNeurons)];

if isDownsampling
  suffix = [suffix 'Downsampling'];
end

%% The 'concatenating loop' 
disp('Big concatenating loop is coming');

% initialize 'stuff'
sumNumCentroidsArray = sum(originalDictSizeArr);
numCentroidsArrayLen = length(originalDictSizeArr);

trainFeats = zeros(numTrainData, sumNumCentroidsArray*numPoolingNeurons);
testFeats = zeros(numTestData, sumNumCentroidsArray*numPoolingNeurons);

if isempty(sourceDataset)
  transferStr = '-transfer_by_codes';
else
  % transfer between datasets
  transferStr = sprintf('-transfer_from_%s_to_%s', ...
    sourceDataset, dataset);
end

ct = 0;
for k = 1:numCentroidsArrayLen
  originalDictSizeNo = originalDictSizeArr(k);
  
  if ~isempty(partsSizeArr)
    partsSize = partsSizeArr(k);
  else
    partsSize = originalDictSizeNo;
  end
  
  fprintf('Original dict size %d is considered\n', originalDictSizeNo);
  fprintf('Parts size is %d\n', partsSize);
  
  partsSuffix = '';
  if ~isempty(partsSizeArr)
    partsSuffix = ['-dim' num2str(originalDictSizeNo) ...
      '-od' num2str(originalDictSizeNo)];
  end
    
  PATH_TO_LOAD_TRAIN_FEATURES = fullfile(...
    conf.local_dir, dataset, ...
    ['trainFeatures_' 'adaptivePooling' '_d' num2str(partsSize) ...
    partsSuffix transferStr suffix])
  
  PATH_TO_LOAD_TEST_FEATURES = fullfile(...
    conf.local_dir, dataset, ...
    ['testFeatures_' 'adaptivePooling' '_d' num2str(partsSize) ...
    partsSuffix transferStr suffix])
    
  % load (not-normalized) features
  % trainXC = data(numImages, featuresSize) 
  % where featuresSize = originalDictSize * numPoolingNeurons
  trainFeatsLoader = load(PATH_TO_LOAD_TRAIN_FEATURES);
  testFeatsLoader = load(PATH_TO_LOAD_TEST_FEATURES);
  
  nct = ct + size(trainFeatsLoader.trainXC, 2);
  trainFeats(:, ct+1:nct) = trainFeatsLoader.trainXC;
  testFeats(:, ct+1:nct) = testFeatsLoader.testXC;
  
  ct = nct;
end

%% Preprocess features if needed

if isFeaturesNormalization
  disp('Features mean and variance normalization');
  
  % standardize data
  trainFeats_mean = mean(trainFeats);
  trainFeats_sd = sqrt(var(trainFeats)+0.01);
  trainFeats = bsxfun( ...
    @rdivide, bsxfun(@minus, trainFeats, trainFeats_mean), trainFeats_sd);
end

if isFeaturesWhitening
  disp('Features whitening');
  
  if ~isFeaturesNormalization
    trainFeats_mean = mean(trainFeats);
    trainFeats = bsxfun(@minus, trainFeats, trainFeats_mean);
  end
  
  trainCov = cov(trainFeats);
  [V,D] = eig(trainCov);
  whitenMatrix = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
  trainFeats = trainFeats * whitenMatrix;
  
end

trainFeats = [trainFeats, ones(size(trainFeats,1),1)];

%% Do cross-validation (optional) 

if isCrossValidation
  disp('Cross validation');
  
  % number of folds
  nFolds = 5;
  
  % number of data per fold
  nDataPerFold = size(trainFeats, 1) / nFolds;
  
  % all possible hyperparameters
  lambdaArray = [100 90 80 70 60 50 40 30 20 10 1];
  trainAcc = zeros(length(lambdaArray), 1);
  testAcc = zeros(length(lambdaArray), 1);
  
  for ii = 1:length(lambdaArray)
    lambda = lambdaArray(ii);
    fprintf('cross-validation of %d-ith lambda: %f\n', ii, lambda);
    
    cumulativeTrainAcc = 0.0;
    cumulativeTestAcc = 0.0;
    ct = 0;
    for k = 1:nFolds
      
      nct = ct + nDataPerFold;
      foldTestIndices = ct+1:nct;
      foldTrainIndices = setdiff(1:size(trainFeats, 1), foldTestIndices);

      foldTrainX = trainFeats(foldTrainIndices, :);
      foldTestX = trainFeats(foldTestIndices, :);
      
      foldTrainY = trainY(foldTrainIndices);
      foldTestY = trainY(foldTestIndices);
      
      nclass = length(unique(foldTrainY));
      
      % train
      theta = train_svm(foldTrainX, foldTrainY, ...
        lambda, maxIterations);

      [~, trainPrediction] = max(foldTrainX*theta, [], 2);
      [~, testPrediction] = max(foldTestX*theta, [], 2);

      cumulativeTrainAcc = cumulativeTrainAcc ...
        + 100*(1 - sum(trainPrediction ~= foldTrainY)/length(foldTrainY));
      
      % test
      cumulativeTestAcc = cumulativeTestAcc ...
        + 100 * (1 - sum(testPrediction ~= foldTestY) / length(foldTestY));
      
    end
    trainAcc(ii) = (1.0 / nFolds) * cumulativeTrainAcc;
    testAcc(ii) = (1.0 / nFolds) * cumulativeTestAcc;
  end
    
  [maxTestAcc, ind] = max(testAcc);
  lambdaBest = lambdaArray(ind);
  maxTrainAcc = trainAcc(ind);
  
  fprintf('Best parameter is %f; train accuracy %f test accuracy %f\n', ...
    lambdaBest, maxTrainAcc, maxTestAcc);
  fprintf('Dataset %s, vocabulary %d\n', dataset, originalDictSizeArr);
  fprintf('Hyper-parameter was checked over %s\n', mat2str(lambdaArray));
  
  return
end

%% Train classifier 
disp('Train the classifier');

theta = train_svm(trainFeats, trainY, ...
  classifierHyperParameter, maxIterations);
% keyboard;
[~,predTrain] = max(trainFeats*theta, [], 2);

trainAcc = 100 * (1 - sum(predTrain ~= trainY) / length(trainY));
fprintf('Train accuracy %f%%\n', trainAcc);
% keyboard;
if isSaveClassifierModel
  PATH_CLASSIFIER_MODEL = fullfile(conf.local_dir, dataset, ...
    ['svmClassifierModel_d' mat2str(partsSizeArr) ...
    '_od' mat2str(originalDictSizeArr) '_perm' mat2str(permArr) suffix]);
  save(PATH_CLASSIFIER_MODEL, 'theta', '-v7.3');
end

%% Test classification 
disp('Test the classifier');

if isFeaturesNormalization
  testFeats = bsxfun(@rdivide, ...
    bsxfun(@minus, testFeats, trainFeats_mean), trainFeats_sd);
end

if isFeaturesWhitening
  
  if ~isFeaturesNormalization
    testFeats = bsxfun(@minus, testFeats, trainFeats_mean);
  end
  
  testFeats = testFeats * whitenMatrix;
end

testFeats = [testFeats, ones(size(testFeats,1),1)];

% test and print result
[~, predTest] = max(testFeats*theta, [], 2);

testAcc = 100 * (1 - sum(predTest ~= testY) / length(testY));
fprintf('Test accuracy %f%%\n', testAcc);

%% Print results and hyperparameters
fprintf('Size in total is %d\n', size(testFeats, 2));

fprintf('Dataset: %s\n', dataset);

my_print(1, originalDictSizeArr, partsSizeArr, isDownsampling, ...
  isFeaturesNormalization, isFeaturesWhitening, ...
  maxIterations, classifierHyperParameter, ...
  partsSize, numPoolingNeurons, trainAcc, testAcc);

end

%% Aux.

function my_print(fid, originalDictSizeArr, partsSizeArr, ...
  isDownsampling, isFeaturesNormalization, isFeaturesWhitening, ...
  maxIterations, classifierHyperParameter, ...
  partsSize, numPoolingNeurons, trainAcc, testAcc)

fprintf(fid, 'Original dictionary size array: %s\n', ...
  mat2str(originalDictSizeArr));
fprintf(fid, 'Parts sizes: %s\n', mat2str(partsSizeArr));
fprintf(fid, 'Is downsampling: %d\n', isDownsampling);
fprintf(fid, 'Is features normalization: %d\n', isFeaturesNormalization);
fprintf(fid, 'Is features whitening: %d\n', isFeaturesWhitening);
fprintf(fid, 'Linear SVM was used\n');
fprintf(fid, 'Maximal number of iterations: %d\n', maxIterations);
fprintf(fid, 'Classifier hyperprior: %d\n', classifierHyperParameter);
fprintf(fid, 'Size of the parts is %d\n', partsSize);
fprintf(fid, 'Number of pooling neurons: %d\n', numPoolingNeurons);

fprintf(fid, 'Train accuracy %f\n', trainAcc);
fprintf(fid, 'Test accuracy %f\n', testAcc);

end