function print_hyperparams( fid, ...
  numCentroids, classifierWeight, poolingWeight, ...
  lessOneWeight, moreZeroWeight, anisotropicSmoothingW, ...
  maxTrainingIterations, nFolds, accValid, projFuncStr)
%PRINT_HYPERPARAMS 
% 

if isempty(fid)
  fid = 1;
end

if ~isempty(numCentroids)
  fprintf(fid, 'Number of centroids %d\n', numCentroids);
end

fprintf(fid, 'Hyperparameters: scaled\n');
if ~isempty(classifierWeight)
  fprintf(fid, '- classifier weight: %f\n', classifierWeight);
end
if ~isempty(poolingWeight)
  fprintf(fid, '- pooling weight: %f\n', poolingWeight);
end
if ~isempty(lessOneWeight)
  fprintf(fid, '- <=1 constraint: %f\n', lessOneWeight);
end
if ~isempty(moreZeroWeight)
  fprintf(fid, '- >=0 constraint: %f\n', moreZeroWeight);
end
if ~isempty(anisotropicSmoothingW)
  fprintf(fid, '- anisotropic smoothing: %f\n', anisotropicSmoothingW);
end
if ~isempty(maxTrainingIterations)
  fprintf(fid, 'Maximal number of iterations was set to %d\n', ...
    maxTrainingIterations);
end

if nargin > 8 && ~isempty(nFolds) && ~isempty(accValid)
  fprintf(fid, 'With %d-folds accuracy %f\n', nFolds, accValid);
end

if nargin > 10
  fprintf(fid, 'Projection function used: %s\n', projFuncStr);
end

end

