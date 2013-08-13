function optTheta = train_generalized_pooling_sites( ...
  trainSparseCodes, trainLabels, numClasses, ...
  initTheta, netconfig, numFeatures, ...
  classifierPrior, poolingPrior, ...
  maxIter, projFun, isBias)
%TRAIN_GENERALIZED_POOLING 
% 
% In:
%   trainSparseCodes - sparse codes for training;
%     so trainSparseCodes{j} = data(numSamples, numData) of the
%     j-th layer (coordinate) 
%   trainLabels - labels of the training input
%   numClasses - number of possible classes
%   initTheta - initial parameters
%   netconfig - structure containing the topology of network
%   numFeatures - number of features (number of inputs for the classifier)
%   classifierPrior - mapper used for the classifier regularizer
%   poolingPrior - mapper used for the pooling regularizer
%   maxIter - maximal number of iterations
%   projFun - the projection function 
%   isBias - should bias term in the classifier be included
% 
% Out:
%   optTheta - learned parameters
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 26.02.2012
% 

if maxIter > 0
  options.Method = 'cg'; % CG optimizer
  options.Method = 'lbfgs'; % L-BFGS optimizer
  options.maxIter = maxIter;	  % Maximum number of iterations of L-BFGS to run 
  options.display = 'on';
  options.Corr = 130;  % number of corrections stored in memory
  options.MaxFunEvals = 100000; % maximal number of function evaluations
  [optTheta, ~] = minFuncProj(@(p) subsampled_composed_nn_sites_cost(p, ...
      numFeatures, numClasses, netconfig, ...
      classifierPrior, poolingPrior, ...
      trainSparseCodes, trainLabels, isBias), ...
      projFun, initTheta, options);
  
else
  optTheta = initTheta;
end

end
