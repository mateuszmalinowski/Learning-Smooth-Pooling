function [ codes, whitenMatrix ] = codes_whitening( codes, whitenMatrix )
%CODES_WHITENING Whitens the codes.
%  
% In:
%   codes - codes{k} = data(numSamples, numData) denotes codes for the k-th
%     coordinate
%   whitenMatrix - optional, if provided then the function returns codes
%     after whitening by whitenMatrix and the copy of whitenMatrix; 
%     otherwise the function computes whitenMatrix from scratch
% 
% Out:
%   codes
%   whitenMatrix - the whitening matrix
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.05.2012 
%

numCoordinates = length(codes);

if  nargin == 1
  whitenMatrix = cell(numCoordinates, 1);

  for codesLayerNo = 1:numCoordinates
    C = cov(codes{codesLayerNo}');
    [V,D] = eig(C);
    whitenMatrix{codesLayerNo} = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
  end
end

for codesLayerNo = 1:numCoordinates
  codes{codesLayerNo} = ...
    whitenMatrix{codesLayerNo} * codes{codesLayerNo} ;
end

end

