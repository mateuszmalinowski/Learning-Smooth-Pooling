function triangleCodes = triangle_coding( patches, centroids )
% Computes triangle codes.
% 
% In:
%   patches - matrix of patches; numSamples x patchSize*numChannels
%   centroids - matrix of centroids; numCentroids x patchSize*numChannels
% 
% Out:
%   triangle codes; numSamples x numCentroids
% 

% compute 'triangle' activation function
% triangle codes are distance z_k = ||c_k - patch||^2 where patch is the
% current patch, and c_k is k-th centroid, so
% c_k^2 + patch^2 - 2c_k*patch where a^2 = a^T a
xx = sum(patches.^2, 2);
cc = sum(centroids.^2, 2)';
xc = patches * centroids';

z = sqrt( bsxfun(@plus, cc, bsxfun(@minus, xx, 2*xc)) ); % distances

mu = mean(z, 2); % average distance to centroids for each patch
triangleCodes = max(bsxfun(@minus, mu, z), 0);
% triangleCodes is now the data matrix of activations for each patch;
% triangleCodes is a matrix of size numSamples x numCoordinates

end

