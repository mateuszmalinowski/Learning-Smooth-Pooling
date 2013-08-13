% converts batches from the format:
% batchCodes{j} - j-th batch and batchCodes{j}{k} 
% = data(numCoordinates, numSamples) - k-th image into
% convertedBatchCodes{j} - j-th batch and convertedBatchCodes{j}{k} 
% = data(numSamples, numImages) - k-th coordinate
% 

conf = Configuration;

numCentroids = 40;

isDownsampling = true;
% isDownsampling = false;

suffix = '';
if isDownsampling
  suffix = 'Downsampling';
end

PATH_TO_BATCH_CODES = fullfile(conf.local_dir, ...
  ['batchCodes_d' num2str(numCentroids) suffix '.mat']);

PATH_TO_STORE_CONVERTED_BATCHES = fullfile(conf.local_dir, ...
  ['convertedBatchCodes_d' num2str(numCentroids) suffix '.mat']);

load(PATH_TO_BATCH_CODES);

nFolds = length(batchCodes);

convertedBatchCodes = cell(nFolds, 1);

for foldNo = 1:nFolds
  convertedBatchCodes{foldNo} = convert_data(batchCodes{foldNo});
end

save(PATH_TO_STORE_CONVERTED_BATCHES, ...
  'convertedBatchCodes', 'batchLabels', '-v7.3');

fprintf('Batches were converted for the dictionary size: %d\n', ...
  numCentroids);