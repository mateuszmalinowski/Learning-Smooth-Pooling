function [ codes, stdCodes ] = codes_covariance_normalization( ...
  codes, stdCodes )
%CODES_COVARIANCE_NORMALIZATION Normalizes the codes to have unit
% covariance.
% 
% In:
%   codes - codes{k} = data(numSamples, numData) denotes codes for the k-th
%     coordinate
%   stdCodes - optional, if provided then the function returns codes
%     normalized by stdCodes and the copy of stdCodes; otherwise the
%     function computes stdCodes from scratch
% 
% Out:
%   codes
%   stdCodes - standard deviation of the codes
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.05.2012 
%

numCoordinates = length(codes);

if nargin == 1
  stdCodes = cell(numCoordinates, 1);

  for codesLayerNo = 1:numCoordinates
    stdCodes{codesLayerNo} = std(codes{codesLayerNo}, 0, 2);
  end
end

for codesLayerNo = 1:numCoordinates
  codes{codesLayerNo} = bsxfun( ...
    @rdivide, codes{codesLayerNo}, stdCodes{codesLayerNo} + 0.001);
end

end

