function XC = extract_features_from_codes_whole_image( ...
  X, poolingOp, numPoolingRegions)
% Extract features (similar to Coates' extract features), but the
% statistics are computed over the whole image space. Spatial pooling can
% be steered by appropriate (weighted) poolingOp. As input codes are taken.
% 
% In:
%   X - codes, cell array such that X{j} denotes data for j-th image;
%     moreover X{j} = data(numCoordinates, numSamples)
%   poolingOp - pooling operator; poolingOp takes patches as an input of
%     size numSamples x numCoordinates
%   numPoolingRegions - number of pooling regions
% 
% Out:
%   XC - computed features; XC(a, :) denotes a feature vector from the a-th
%     image
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 10.05.2012
% 

numImages = length(X);
numCoordinates = size(X{1}, 1);

XC = zeros(numImages, numCoordinates * numPoolingRegions);

for k = 1:numImages
  
    % concatenate into feature vector
    XC(k,:) = poolingOp(X{k}');
    
end

end

