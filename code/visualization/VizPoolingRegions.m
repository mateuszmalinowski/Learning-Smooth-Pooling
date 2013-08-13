% Shows pooling regions
% 

%% Set-up
conf = Configuration;

% used dataset
dataset = conf.working_dataset;

if strcmp(dataset, conf.CIFAR10)
  numClasses = 10;
elseif strcmp(dataset, conf.CIFAR100)
  numClasses = 100;
end

dictionarySize = conf.dictionary_size;

% layers to visualize
layersIndices = [1,10,40];

% number of the part if applicable (partsNo > 0 --> applicable)
% partsNo = 0;
partsNo = 1;
% partsNo = 41;

% original dictionary; valid only if partsNo > 0
originalDictionary = conf.original_dictionary_size;

% dimensionality of dataset
DATASET_DIM = [32, 32, 3]; 
% DATASET_DIM = [256 256];

% to rescale the visualization
CLIMS = [];
% CLIMS = [0.2 0.6];

% patchsize
rfSize = 6; 

% grid spacing
gridSpacing = 1;

% number of pooling neurons
nPoolingNeurons = 4;  

numFeatures = nPoolingNeurons * dictionarySize;

isHardRegions = false;  % if true, weights are rounded to [0,1]

% if true then show the average too
isShowAverage = false;

% true if downsampling was used
isDownsampling = true;

% true if we want to show initialization of the pooling regions
showPoolingInit = false;

nSamplesPerDim = ([DATASET_DIM(1) DATASET_DIM(2)] - rfSize)/gridSpacing+1;
if isDownsampling
  if strcmp(dataset, conf.CIFAR10) || strcmp(dataset, conf.CIFAR100)
    downscaleFactor = 3.0;
  elseif strcmp(dataset, conf.CALTECH101)
    downscaleFactor = 4.0;
  end
  nSamplesPerDim = ceil(nSamplesPerDim / downscaleFactor);
end

% maximal allowed number of iterations to learn the pooling regions
maxTrainingIterations = 3000;

% the number of columns in visualization
numVizColumns = 2;
% numVizColumns = 3;

%% Choice of the pooling visualization method
pooling_visualization = @show_pooling_regions;
% pooling_visualization = @show_pooling_regions_separately;

%% Directory

suffix = '';
if isDownsampling
  suffix = 'Downsampling';
end

if partsNo > 0
  suffix = [suffix '-od_' num2str(originalDictionary) ...
    '-part_' num2str(partsNo)];
end

if showPoolingInit
  matfilename = ['poolingInit_d' num2str(dictionarySize) ...
    '-poolingUnits_' num2str(nPoolingNeurons) '.mat'];
else
  matfilename = ['poolingOpt_d' num2str(dictionarySize) ...
    '_iter' num2str(maxTrainingIterations) ...
    '-poolingUnits_' num2str(nPoolingNeurons) suffix '.mat'];
end

if showPoolingInit
  savefilename = ['poolingRegionsInit_poolingUnits' ...
    num2str(nPoolingNeurons)];
else
  savefilename = ['poolingRegions_d' num2str(dictionarySize) ...
    '_iter' num2str(maxTrainingIterations) ...
    '-poolingUnits' num2str(nPoolingNeurons) suffix];
end

EXPERIMENTS_DIR = fullfile(conf.local_dir,  dataset);

PARAMETERS_PATH = fullfile(EXPERIMENTS_DIR, matfilename);

% set the save path if we want to save the results
SAVE_PATH = [];

%% Load parameters
loader = load(PARAMETERS_PATH);

if showPoolingInit
  theta = loader.thetaInit;
else
  theta = loader.thetaOpt;
end
netconfig = loader.netconfig;

stack = params2stack( ...
  params2stackparams(theta, numClasses, numFeatures), netconfig);

%% Show pooling regions
  
pooling_visualization( ...
  stack, nSamplesPerDim, layersIndices, isHardRegions, ...
  [], SAVE_PATH, numVizColumns, CLIMS);

if isShowAverage
  
  avgTmp = 0;
  
  stacksize = numel(stack);
  
  for ii = 1:stacksize
    avgTmp = avgTmp + stack{ii}.w;
  end
  avgStack = cell(1);
  avgStack{1}.w = (1.0/stacksize) * avgTmp;
  
  pooling_visualization( ...
    avgStack, nSamplesPerDim, 1, isHardRegions, ...
    'average regions', [SAVE_PATH '_avg'], numVizColumns, CLIMS);
  
end

%% show minimal/maximal value in the stack
[mini, maxi] = find_min_max_in_stack(stack);
fprintf('Minimal %f, and maximal %f\n', mini, maxi);
