function [ patches ] = random_patch_extractor( ...
  data, imageSize, numPatches, rfSize, gridSpacing, isVerbose)
% Extracts randomly rectangular patches on the grid 
% with given grid spacing.
% 
% In:
%   data - data points; data(k,:) refers to the k-th datapoint
%   imageSize - imageSize = [numRows, numCols, numChannels]
%   numPatches - number of patches to extract
%   rfSize - size of the patch
%   isVerbose - set on/off verbosity (optional, default = false)
% 
% Out:
%   patches - extracted patches; patches(k,:) refers to the k-th patch
% 
% Based on A. Coates's source code.
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 21.09.2012
%  

if nargin < 6 || isempty(isVerbose)
  verbosity = false;
else
  verbosity = isVerbose;
end

numChannels = imageSize(3);

% defines maximal grid points
maxRowGridPoint = ceil((imageSize(1) - rfSize + 1)/gridSpacing);
maxColGridPoint = ceil((imageSize(2) - rfSize + 1)/gridSpacing);

% defines offset from the 'left' boundary
remRow = mod(imageSize(1) - rfSize, gridSpacing);
remCol = mod(imageSize(2) - rfSize, gridSpacing);
offsetRow = floor(remRow/2) + 1;
offsetCol = floor(remCol/2) + 1;

patches = zeros(numPatches, rfSize*rfSize*numChannels);
for ii=1:numPatches
  
  if verbosity && (mod(ii,10000) == 0)
    fprintf('Extracting patch: %d / %d\n', ii, numPatches);
  end
  
  r = gridSpacing * (random('unid', maxRowGridPoint)-1) + offsetRow;
  c = gridSpacing * (random('unid', maxColGridPoint)-1) + offsetCol;
  patch = reshape(data(mod(ii-1,size(data,1))+1, :), imageSize);
  patch = patch(r:r+rfSize-1,c:c+rfSize-1,:);
  patches(ii,:) = patch(:)';
  
end

end

