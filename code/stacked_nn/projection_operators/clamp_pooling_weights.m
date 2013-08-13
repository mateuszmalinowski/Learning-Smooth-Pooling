function y = clamp_pooling_weights( x, minValue, maxValue, ...
  numFeatures, numClasses)
%Restricts possible values of the weights in x.w to be between
% minVal and maxVal. If values of x.w are outside of the interval 
% [minVal maxVal] then those values are substituted 
% by minVal if x < minVal or maxVal if x > maxVal.
% 
% Invoke: clamp_pooling_weights(x, minValue, maxValue)
% 
% In:
%   x - the input parameter
%   minValue - minimal possible value (if -infinity then ingored)
%   maxValue - maximal possible value (if infinity then ignored)
%   numFeatures - number of the features (input for the classifier)
%   numClasses - number of classes
% 
% Out:
%   y - output in range [minVal, maxVal]
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 01.08.2012
%  

% parameters for the classifier
xhead = x(1:numFeatures*numClasses);

% extract out the "stack"
xtail = x(numFeatures*numClasses+1:end);

xtail = min(max(xtail, minValue), maxValue);

y = [xhead; xtail];

end

