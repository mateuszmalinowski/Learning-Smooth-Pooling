function codes = extract_codes( ...
  X, centroids, encoder, patches_extractor, ...
  M, P, prepooling_op)
% 
% In:
%   X - input RGB image (X(a, :) denotes a-th image)
%   centroids - dictionary
%   encoder - encoding function
%   patches_extractor - function that extract patches from the given image
%   M, P - whitening matrices (M - mean); optional [default = []]
%   prepooling_op - the prepooling operator; optional [default = []]
% 
% Out:
%   codes - computed codes; cell array where codes{j} denotes codes
%     computed from j-th image, moreover codes{j} = 
%     data(numCoordinates, numSamples), where numCoordinates denotes 
%     number of coordinates, and numSamples denotes number of extracted 
%     samples from the image
% 
% Based on: A. Coates's source code
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 21.09.2012
%

assert(nargin == 4 || nargin == 6 || nargin == 7);
whitening = (nargin >= 6) && ~isempty(P);
isPrepooling = (nargin == 7) && ~isempty(prepooling_op);

codes = cell(size(X,1), 1);

for ii=1:size(X,1)
  % loop over all images
  
  if (mod(ii,1000) == 0)
    fprintf('Extracting codes: %d / %d\n', ii, size(X,1));
  end
  
  patches = patches_extractor(X(ii, :));
  
  % patches(a,:) denotes a-th patch from the ii-th image that has
  % size: rfSize x rfSize
  
  % normalize for contrast
  patches = bsxfun(@rdivide, ...
    bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));
  
  % whiten
  if (whitening)
    patches = bsxfun(@minus, patches, M) * P;
  end
  
  if isPrepooling
    codes{ii} = prepooling_op(encoder(patches, centroids))';
  else
    codes{ii} = encoder(patches, centroids)';
  end
  
end
