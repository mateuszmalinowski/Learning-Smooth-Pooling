function XC = extract_features( ...
  X, centroids, poolingOp, patches_extractor, ...
  rfSize, gridSpacing, imageSize, M,P)
% 
% In:
%   X - input RGB image (X(a, :) denotes a-th observation)
%   centroids - dictionary
%   poolingOp - pooling operator
%   patches_extractor - extractor of the patches
%   rfSize - size of every patch
%   gridSpacing - grid spacing
%   imageSize - dimensionality of input data X
%   M, P - whitening matrices (M - mean)
% 
% Out:
%   XC - computed features; XC(a, :) denotes a-th feature
% 
  assert(nargin == 7 || nargin == 9);
  whitening = (nargin == 9);
  numCentroids = size(centroids,1);
  
  % compute features for all training images
  XC = zeros(size(X,1), numCentroids*4);
  for ii=1:size(X,1)
    if (mod(ii,1000) == 0) 
      fprintf('Extracting features: %d / %d\n', ii, size(X,1)); 
    end
    
    patches = patches_extractor(X(ii, :));
    % patches(a,:) denotes a-th patch from the ii-th image that has
    % size: rfSize x rfSize

    % do preprocessing for each patch
  
    % normalize for contrast
    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)),...
      sqrt(var(patches,[],2)+10));
    
    % whiten
    if (whitening)
      patches = bsxfun(@minus, patches, M) * P;
    end
    
    % compute 'triangle' activation function
    xx = sum(patches.^2, 2);
    cc = sum(centroids.^2, 2)';
    xc = patches * centroids';
    
    z = sqrt( bsxfun(@plus, cc, bsxfun(@minus, xx, 2*xc)) ); % distances

    mu = mean(z, 2); % average distance to centroids for each patch
    patches = max(bsxfun(@minus, mu, z), 0);
    % patches is now the data matrix of activations for each patch
    % patches is a matrix of size numSamples x numCodes
    
    % reshape to numCentroids-channel image
    prows = ceil((imageSize(1)-rfSize+1)/gridSpacing);
    pcols = ceil((imageSize(2)-rfSize+1)/gridSpacing);
    
    patches = reshape(patches, prows, pcols, numCentroids);

    % pool over quadrants
    halfr = round(prows/2);
    halfc = round(pcols/2);
    q1 = poolingOp(poolingOp(patches(1:halfr, 1:halfc, :), 1),2);
    q2 = poolingOp(poolingOp(patches(halfr+1:end, 1:halfc, :), 1),2);
    q3 = poolingOp(poolingOp(patches(1:halfr, halfc+1:end, :), 1),2);
    q4 = poolingOp(poolingOp(patches(halfr+1:end, halfc+1:end, :), 1),2);
    
    % concatenate into feature vector
    XC(ii,:) = [q1(:);q2(:);q3(:);q4(:)]';

  end
