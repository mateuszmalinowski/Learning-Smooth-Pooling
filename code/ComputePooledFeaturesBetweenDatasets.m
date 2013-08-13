% This script computes the pooled features. Features are 'raw' (we didn't
% normalize them in any way) allowing to make normalization afterwards from
% the client's side.
% 
% It starts from the codes and learnt pooling regions, and next it uses
% learnt pooling regions to compute features. It can assemble one feature
% from the separated parts.
% 
% This is also possible to compute the pooled features of the target
% dataset using the pooling regions trained on the source dataset.
% 
% Format of the computed (pooled) features:
%   trainFeatures_adaptivePooling_d40[-dim1600-od1600][-permuted]
%   -transfer_by_codes[-normalization][-whiten][-init][Downsampling]
%   [-normalizedFeats][-whitenFeats]
%   where [a] means a is optional
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 30.09.2012
% 

function ComputePooledFeaturesBetweenDatasets

%% Configuration
conf = Configuration;

sourceDataset = conf.source_dataset;

targetDataset = conf.working_dataset;

% the total number of classes
if strcmp(sourceDataset, conf.CIFAR10)
  totalNumberOfClasses = 10;
elseif strcmp(sourceDataset, conf.CIFAR100)
  totalNumberOfClasses = 100;
else
  error('Unknown dataset');
end

% array of centroids to concatenate
numCentroidsArray = 40;
% numCentroidsArray = 40 * ones(1,40);

% array of parts if the original codes were split;
% if not then it should be left empty
% partsArray = 1:40:1600;
partsArray = [];

% original dictionary size (valid only if partsArray is non-empty)
originalDictSize = 1600;

if ~isempty(partsArray)
  assert(length(numCentroidsArray) == length(partsArray), ...
    'Number of centroids must be the same as the number of parts');
end

%% There might be not a good idea to normalize codes if they are 
% concatenated

% true if we perform codes's normalization; 
% mean centering + variance normalization
isCodesNormalization = false;

% true if we want to perform whitening of the codes
isWhitenCodes = false;

%% Pooling regions setup

% true for downsampled version
isDownsampling = true;

% number of maximal iterations intended to learn the pooling regions
maxTrainingPoolingIterations = 3000;

numPoolingNeurons = 4; 

suffix = '';
if isDownsampling
  suffix = [suffix 'Downsampling'];
end

%% Welcome screen
disp('Computing the pooled features have begun');
fprintf(['Transfer between %s (source dataset for the pooling regions)' ...
  ' and %s (target dataset for the codes and features)'], ...
  sourceDataset, targetDataset);

%% Set directories

% stackParamsCellArray is a cell array containing stack parameters
% classifierParamsCellArray is a cell array containing classifier
% parameters
numCentroidsArrayLen = length(numCentroidsArray);

numCentroidsString = '';
uniqCentroidsArray = unique(numCentroidsArray);
for k = 1:length(uniqCentroidsArray)
  numCentroids = uniqCentroidsArray(k);
  numCentroidsString = [numCentroidsString num2str(numCentroids)];
  if k < length(uniqCentroidsArray)
    numCentroidsString = [numCentroidsString '-'];
  end
end

concatenatedCodesSuffix = ['-poolingUnits_' num2str(numPoolingNeurons)];
if isCodesNormalization
  concatenatedCodesSuffix = [concatenatedCodesSuffix '-normalization'];
end

if isWhitenCodes
  concatenatedCodesSuffix = [concatenatedCodesSuffix '-whiten'];
end

partsSuffix = '';
if ~isempty(partsArray)
  if ~isempty(randSplitArray) && any(randSplitArray) 
    partsSuffix = [partsSuffix '-permuted'];
  end
  partsSuffix =  [partsSuffix '-dim' num2str(sum(numCentroidsArray)) ...
    '-od' num2str(originalDictSize)];
end

% paths to the stored (pooled) features
transferDatasets = sprintf('-transfer_from_%s_to_%s', ...
  sourceDataset, targetDataset);
PATH_TO_STORE_TRAIN_FEATURES = fullfile(conf.local_dir, targetDataset, ...
  ['trainFeatures_' 'adaptivePooling' '_d' numCentroidsString ...
  partsSuffix transferDatasets concatenatedCodesSuffix suffix])

PATH_TO_STORE_TEST_FEATURES = fullfile(conf.local_dir, targetDataset, ...
  ['testFeatures_' 'adaptivePooling' '_d' numCentroidsString ...
  partsSuffix transferDatasets concatenatedCodesSuffix suffix])

%% The 'concatenating loop' (extract weights, train codes, and test codes)

partsCounter = 0;

sumNumCentroidsArray = sum(numCentroidsArray);
weights = cell(sumNumCentroidsArray, 1);
trainCodes = cell(sumNumCentroidsArray, 1);
testCodes = cell(sumNumCentroidsArray, 1);

ct = 0;
for k = 1:numCentroidsArrayLen
  numCentroids = numCentroidsArray(k);
  
  if ~isempty(partsArray)
    partsCounter = partsArray(k);
  end
  
  if partsCounter > 0
    
    % -r if random split was performed
    randSplitSuffix = '';
    
    if ~isempty(randSplitArray)
      if randSplitArray(k)
        randSplitSuffix = '-r';
        disp('Randomized split is now considered');
      else
        disp('No randomized split is now considered');
      end
    end
    
    fprintf('Current part is %d\n', partsCounter);
    partSuffix = ['-od_' num2str(originalDictSize) ...
      randSplitSuffix, '-part_' num2str(partsCounter)];
  else
    partSuffix = '';
  end
  
  totalSuffix = [suffix partSuffix];
  
  % total number of features
  featuresSize = numPoolingNeurons * numCentroids;
 
  PATH_TO_STORE_GENERALIZED_POOLING_PARAMS = fullfile( ...
    conf.local_dir, sourceDataset, ...
    ['poolingOpt_d' num2str(numCentroids) ...
    '_iter' num2str(maxTrainingPoolingIterations)  ...
    '-poolingUnits_' num2str(numPoolingNeurons) ...
    totalSuffix]);
  
  PATH_TO_STORE_TRAIN_CODES = fullfile(conf.local_dir, targetDataset, ...
    ['trainCodes_d' num2str(numCentroids) totalSuffix]);
  
  PATH_TO_STORE_TEST_CODES = fullfile(conf.local_dir, targetDataset, ...
    ['testCodes_d' num2str(numCentroids) totalSuffix]);
  
  %% Takes stack
  poolingLoader = load(PATH_TO_STORE_GENERALIZED_POOLING_PARAMS);
  trainCodesLoader = load(PATH_TO_STORE_TRAIN_CODES);
  testCodesLoader = load(PATH_TO_STORE_TEST_CODES);
  
  stackParams = params2stackparams(poolingLoader.thetaOpt, ...
    totalNumberOfClasses, featuresSize);
  
  % increase the counter
  nct = ct + numCentroids;
  
  % concatenate codes
  trainCodes(ct+1:nct) = trainCodesLoader.trainCodes;
  testCodes(ct+1:nct) = testCodesLoader.testCodes;
  
  % concatenate weights
  weights(ct+1:nct) = params2stack(stackParams, poolingLoader.netconfig);
  % weights is a cell array of numCentroids number of elements
  % weights{k}.w is a matrix of size numPoolingNeurons x numSamples
  
  ct = nct;
  
end

% normalize codes if needed
if isCodesNormalization
  % codes{j} = data(numSamples, numImages) for j-th code (coordinate)
  for codesLayerNo = 1:length(trainCodes)
    meanTrainCodes= mean(trainCodes{codesLayerNo}, 2);
    stdTrainCodes = std(trainCodes{codesLayerNo}, 0, 2);
    
    trainCodes{codesLayerNo} = bsxfun(@rdivide, bsxfun( ...
      @minus, trainCodes{codesLayerNo}, meanTrainCodes), stdTrainCodes);
    
    testCodes{codesLayerNo} = bsxfun(@rdivide, bsxfun( ...
      @minus, testCodes{codesLayerNo}, meanTrainCodes), stdTrainCodes);
    
    clear meanTrainCodes;
    clear stdTrainCodes;
  end
  
  % whiten the codes if needed
  if isWhitenCodes
    for codesLayerNo = 1:length(trainCodes)
      C = cov(trainCodes{codesLayerNo}');
      [V,D] = eig(C);
      whitenMatrix = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
      
      trainCodes{codesLayerNo} = ...
        whitenMatrix * trainCodes{codesLayerNo};
      testCodes{codesLayerNo} = ...
        whitenMatrix * testCodes{codesLayerNo};
    end
    clear C;
    clear whitenMatrix;
  end
  
end

% convert to raw codes
trainCodes = convert_to_raw_codes(trainCodes);
testCodes = convert_to_raw_codes(testCodes);
% trainCodes{k} - codes from k-th image; size: dictSize x numSamples

% create adaptive pooling
adaptivePoolingOp = @(patches) adaptive_pooling(patches, weights);

%% Extract train features
trainXC = extract_features_from_codes_whole_image( ...
  trainCodes, adaptivePoolingOp, numPoolingNeurons); %#ok, to save
% trainXC(j,:) represents a feature vector from j-th image

save(PATH_TO_STORE_TRAIN_FEATURES, 'trainXC', '-v7.3');

%% Extract test features

% compute testing features and standardize
testXC = extract_features_from_codes_whole_image( ...
  testCodes, adaptivePoolingOp, numPoolingNeurons); %#ok, to save
save(PATH_TO_STORE_TEST_FEATURES, 'testXC', '-v7.3');

end
