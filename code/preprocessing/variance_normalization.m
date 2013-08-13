function patches = variance_normalization( patches, delta )
%VARIANCE_NORMALIZATION Normalize variance of the patches.
% 
% More precisely, it divides patches by sqrt(var(patches, 1) + delta).
% 
% In:
%   patches - array of size featureLength x numPatches
%     representing patches
%   delta - small value added in order to 'denoise' noisy patches
% 
% Out:
%   patches with normalized variance
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 26.03.2012 
%

% truncate to +/-3 standard deviation
pstd = sqrt(var(patches, [], 1) + delta);
patches = bsxfun(@rdivide, patches, pstd);

end

