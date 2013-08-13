function [ patches ] = single_grid_spacing_patches_extractor( ...
  X, imageSize, rfSize, ~)
% Extracts rectangular patches on the grid with 1-by-1 spacing.
% 
% In:
%   X - given image; a vector containing imageSize(1) x imageSize(2) x 3 
%     dimensional image from 3 channels
%   imageSize - imageSize = [numRows, numCols, numChannels] (not used)
%   rfSize - size of the patch
%   gridSpacing - grid spacing (not used)
% 
% Out:
%   patches(a,:) denotes a-th patch from the given image that has
%     size: rfSize x rfSize x 3
% 
% Based on A. Coates's source code.
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-ing.mpg.de
% Created: 21.09.2012
%  

patchSize = imageSize(1) * imageSize(2);
twoPatchSize = 2*patchSize;

% X(1:patchSize) denotes image from the first channel, and so on ...;
% reshape(X(1:patchSize),imageSize(1:2)) denotes the image from the 
% first channel;
% extract overlapping sub-patches into rows of 'patches'
patches = [...
  im2col(reshape(X(1:patchSize),imageSize(1:2)), ...
    [rfSize rfSize]) ;
  im2col(reshape(X(patchSize+1:twoPatchSize),imageSize(1:2)), ...
    [rfSize rfSize]) ;
  im2col(reshape(X(twoPatchSize+1:end),imageSize(1:2)), ...
    [rfSize rfSize]) ]';

end

