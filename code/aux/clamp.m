function y = clamp( x, minVal, maxVal )
%Restricts possible values of x to be between minVal and maxVal. If values
% of x are outside of the interval [minVal maxVal] then those values are
% substituted by minVal if x < minVal or maxVal if x > maxVal.
% 
% Invoke: clamp(x, minValue, maxValue)
% 
% In:
%   x - input
%   minVal - minimal possible value
%   maxVal - maximal possible value
% 
% Out:
%   y - output in range [minVal, maxVal]
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 27.02.2012
%  

y = min(max(x, minVal), maxVal);

end

