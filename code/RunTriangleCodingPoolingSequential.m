% Run sequentially the TriangleCodingPoolingRegions script for more 
% than one parts.
% 

warning('Not recommended. Better to run on the cluster in parallel way');

conf = Configuration;

% the size of single part
dictSize = conf.dictionary_size;

% the original dictionary size
originalDictSize = conf.original_dictionary_size;

for k = 1:dictSize:originalDictSize
  TriangleCodingPoolingRegions(k);
end