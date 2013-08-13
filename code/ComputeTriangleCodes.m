function ComputeTriangleCodes
% Extract patches and computes the triangle codes
% 
% Based on the A. Coates's code.
% Modified by Mateusz Malinowski
% 

%% Setting
conf = Configuration;

dataset = conf.working_dataset;

numCentroids = conf.dictionary_size;

if strcmp(dataset, conf.CIFAR10) || strcmp(dataset, conf.CIFAR100)
  imageSize = [32 32 3];
  gridSpacing = 1;  % the sample spacing
  patchSize = 6;    % patch size in one dimension
else
  error('Unknown dataset');
end

% important for pre-pooling
samplingRows = ceil((imageSize(1) - patchSize + 1)/gridSpacing);
samplingCols = ceil((imageSize(2) - patchSize + 1)/gridSpacing);
numberOfPoolingRegionsRow = 9;
numberOfPoolingRegionsCol = 9;
% choice of the pre-pooling operator
pooling_op =@(x, d) sum(x, d);

% the pre-pooling function; if empty then pre-pooling is not applied
% prepooling_fun = [];
prepooling_fun = @(x) spatial_pooling_codes( ...
  x, samplingRows, samplingCols, ...
  numberOfPoolingRegionsRow, numberOfPoolingRegionsCol, pooling_op);

% number of patches used for the dictionary learning
numPatches = 400000;

% whitening as a preprocessing step
isWhitening = true;

% decide which parts of the code to run
isExtractRandomPatches = true;
isRunClustering = true;
isExtractTrainCodes = true;
isExtractTestCodes = true;

if strcmp(dataset, conf.CIFAR10)
  datasetName = conf.CIFAR10_DATASET;
elseif strcmp(dataset, conf.CIFAR100)
  datasetName = conf.CIFAR100_DATASET;
else
  error('Unknown dataset');
end

%% Directories
% directory for the dataset
DATASET_DIR = fullfile(conf.dataset_dir, datasetName);

PATH_TO_STORE_PATCHES = fullfile(conf.local_dir, dataset, ...
  ['randomPatches.mat']);

PATH_TO_STORE_CENTROIDS = fullfile(conf.local_dir, dataset, ...
  ['centroids_d' num2str(numCentroids) '.mat']);

codesSuffix = '';

if ~isempty(prepooling_fun)
  codesSuffix = [codesSuffix 'Downsampling'];
end

PATH_TO_STORE_TRAIN_CODES = fullfile(conf.local_dir, dataset, ...
  ['trainCodes_d' num2str(numCentroids) codesSuffix '.mat']);

PATH_TO_STORE_TEST_CODES = fullfile(conf.local_dir, dataset, ...
  ['testCodes_d' num2str(numCentroids) codesSuffix '.mat']);

%% Set the data loaders

% data loader used to load data
if strcmp(dataset, conf.CIFAR10)
  train_loader = @(x) load_train_batch_data(x);
  test_loader = @(x) load_test_batch_data(x);
elseif strcmp(dataset, conf.CIFAR100)
  train_loader = @(x) load_train_fine_labeled_data(x);
  test_loader = @(x) load_test_fine_labeled_data(x);
else
  error('Uknown dataset');
end

%% Choice of the encoder
encoder = @triangle_coding;

%% Choice of the patches extractor
if strcmp(dataset, conf.CIFAR10) || strcmp(dataset, conf.CIFAR100)
  patches_extractor =@(x) single_grid_spacing_patches_extractor( ...
    x, imageSize, patchSize, gridSpacing);
else
  error('Uknown patches extractor!');
end

%% Welcome screen
fprintf('Compute Triangle Codes, dataset %s with number of clusters %d\n', ...
  dataset, numCentroids);

%% Extract random patches

if isExtractRandomPatches
  disp('Extracting patches');

  trainX = train_loader(DATASET_DIR);
  
  % extract random patches
  patches = random_patch_extractor( ...
    trainX, imageSize, numPatches, patchSize, gridSpacing, true);
  
  save(PATH_TO_STORE_PATCHES, 'patches');
else
  load(PATH_TO_STORE_PATCHES);
end
  
patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), ...
  sqrt(var(patches,[],2)+10));

% whiten
if isWhitening
  C = cov(patches);
  M = mean(patches);
  [V,D] = eig(C);
  P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
  patches = bsxfun(@minus, patches, M) * P;
end

% run K-means
if isRunClustering
  % train vocabulary
  disp('Train vocabulary');
  centroids = run_kmeans(patches, numCentroids, 50);
  save(PATH_TO_STORE_CENTROIDS, 'centroids');
else
  load(PATH_TO_STORE_CENTROIDS);
end

%% Extract train codes 

if isExtractTrainCodes
  disp('Compute codes for training set');
  if ~isempty(prepooling_fun)
    disp('Pre-pooling operator is used');
  end
  
  [trainX, trainY] = train_loader(DATASET_DIR);
  
  if (isWhitening)
    trainCodes = extract_codes( ...
      trainX, centroids, encoder, patches_extractor, M,P, prepooling_fun);
  else
    trainCodes = extract_codes( ...
      trainX, centroids, encoder, patches_extractor, ...
      [], [], prepooling_fun);
  end
  
  % transform codes from codes{j} = data(numCodes, numSamples) for j-th 
  % image into codes{j} = data(numSamples, numImages) for j-th code
  trainCodes = convert_data(trainCodes);  %#ok, saved later
  save(PATH_TO_STORE_TRAIN_CODES, 'trainCodes', '-v7.3');
  clear trainCodes;
  
end

%% Extract test codes
if isExtractTestCodes
  disp('Compute codes for test set');
  if ~isempty(prepooling_fun)
    disp('Pre-pooling operator is used');
  end
  
  % Load CIFAR test data
  fprintf('Loading test data...\n');
  testX = test_loader(DATASET_DIR);
  
  if (isWhitening)
    testCodes = extract_codes( ...
      testX, centroids, encoder, patches_extractor, M,P, prepooling_fun);
  else
    testCodes = extract_codes(testX, centroids, ...
      encoder, patches_extractor, [], [], prepooling_fun);
  end
  
  % transform codes:
  %   from codes{j} = data(numCoordinates, numSamples) for the j-th image 
  %   into codes{j} = data(numSamples, numImages) for the j-th code
  testCodes = convert_data(testCodes);  %#ok, to save
  save(PATH_TO_STORE_TEST_CODES, 'testCodes', '-v7.3');
  
end

fprintf('Extracted for dictionary size %d\n', numCentroids);

end
