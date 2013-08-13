function stackParams = params2stackparams( ...
  params, numClasses, featuresSize )
%PARAMS2STACKPARAMS Brings about parameter vector corresponding to the
% stack.
% 
% In:
%   params - vector of parameters
%   numClasses - number of classes
%   featuresSize - total number of features
% 
% Out:
%   stackParams - vector of parameters corresponding to stack
% 

stackParams = params(numClasses*featuresSize+1:end);

end

