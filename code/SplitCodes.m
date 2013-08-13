% This script splits codes into two or more non-verlapping 
% equally-sized parts.
% 
% There is also a possibility to switch into the overlapping mode.
% In such case every non-overlapped pair have one overlapped part
% (overlapping is in the middle).
% 
% There is also a possibility to randomly permutate the vector, and do
% splits afterwards.
% 

function SplitCodes

%% Setup

conf = Configuration;

dataset = conf.working_dataset;

% number of codes (original part)
numCodes = 1600;

% size of part in one split
sizeSplitPart = 40;

% true if downsampling is used
isDownsampling = true;

% array containing the starting indices for the split
startSplitIndexArray = 1:sizeSplitPart:numCodes;

%% Dictionaries

if isDownsampling
  suffix = 'Downsampling';
else
  suffix = '';
end

% original code
splitSuffix = [suffix '-od_' num2str(numCodes)];

% paths to the original codes
PATH_TO_TRAIN_CODES = fullfile(conf.local_dir, dataset, ...
  ['trainCodes_d' num2str(numCodes) suffix '.mat']);

PATH_TO_TEST_CODES = fullfile(conf.local_dir, dataset, ...
  ['testCodes_d' num2str(numCodes) suffix '.mat']);

% paths to the split codes
PREFIX_PATH_TO_SPLIT_TRAIN_CODES = fullfile(conf.local_dir, dataset, ...
  ['trainCodes_d' num2str(sizeSplitPart) splitSuffix '-part_']);

PREFIX_PATH_TO_SPLIT_TEST_CODES = fullfile(conf.local_dir, dataset, ...
  ['testCodes_d' num2str(sizeSplitPart) splitSuffix '-part_']);

%% Load original codes

load(PATH_TO_TRAIN_CODES);
load(PATH_TO_TEST_CODES);

origTrainCodes = trainCodes;
origTestCodes = testCodes;
% dimensionality:
%   codes{j} - j-th coordinate of the codes
%   codes{j} == data(numSamplesPerImage, numImages)
% 

%% Do spliting into N equally sized parts, and save results
for startSplitIndex = startSplitIndexArray  
  
  do_splitting( ...
    startSplitIndex, sizeSplitPart, origTrainCodes, origTestCodes, ...
    PREFIX_PATH_TO_SPLIT_TRAIN_CODES, PREFIX_PATH_TO_SPLIT_TEST_CODES);

end

fprintf('Dictionary size %d with dictionary %s\n', numCodes, dataset);

end

function do_splitting(...
  startCodesIndex, sizeSplitPart, origTrainCodes, origTestCodes, ...
  PREFIX_PATH_TO_SPLIT_TRAIN_CODES, ...
  PREFIX_PATH_TO_SPLIT_TEST_CODES)
% 
% In:
%   startCodesIndex - the first index for the original codes
%   sizeSplitPart - size of the split part
%   origTrainCodes - original training codes
%   origTestCodes - original testing codes
%   PREFIX_PATH_TO_SPLIT_TRAIN_CODES - path for the file where train codes
%     were split
%   PREFIX_PATH_TO_SPLIT_TEST_CODES - path for the file where test codes
%     were split
% 

  ct = startCodesIndex - 1;
   
  
  PATH_TO_SPLIT_TRAIN_CODES = [PREFIX_PATH_TO_SPLIT_TRAIN_CODES, ...
    num2str(startCodesIndex)];
  
  PATH_TO_SPLIT_TEST_CODES = [PREFIX_PATH_TO_SPLIT_TEST_CODES, ...
    num2str(startCodesIndex)];
  
  nct = ct + sizeSplitPart;
  trainCodes = origTrainCodes(ct+1:nct);  %#ok, to save
  testCodes = origTestCodes(ct+1:nct);    %#ok, to save
  
  save(PATH_TO_SPLIT_TRAIN_CODES, 'trainCodes', '-v7.3');
  save(PATH_TO_SPLIT_TEST_CODES, 'testCodes', '-v7.3');

end