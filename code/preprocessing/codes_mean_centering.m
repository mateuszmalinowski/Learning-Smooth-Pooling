function [ codes, meanCodes ] = codes_mean_centering( codes, meanCodes )
%CODES_MEAN_CENTERING Centers the codes around the mean.
% 
% In:
%   codes - codes{k} = data(numSamples, numData) denotes codes for the k-th
%     coordinate
%   meanCodes - optional, if provided then the function returns codes
%     shifted by meanCodes and the copy of meanCodes; otherwise the
%     function computes meanCodes from scratch
% 
% Out:
%   codes
%   meanCodes - mean of the codes
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.05.2012 
%

nCoordinates = length(codes);

if nargin == 1
  meanCodes = cell(nCoordinates, 1);
  
  for codesLayerNo = 1:nCoordinates
    meanCodes{codesLayerNo} = mean(codes{codesLayerNo}, 2);
  end
end

for codesLayerNo = 1:nCoordinates
  codes{codesLayerNo} = bsxfun( ...
    @minus, codes{codesLayerNo}, meanCodes{codesLayerNo});
end

end

