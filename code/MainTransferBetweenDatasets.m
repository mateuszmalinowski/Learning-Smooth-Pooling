AddPath;

disp('Compute the pooled features between datasets');
tic; 
ComputePooledFeaturesBetweenDatasets;
t=toc;
disp('Features are computed');
fprintf(' - minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));

disp('Classification on the transferred features');
tic;
TransferTriangleFeaturesSVM;
t=toc;
fprintf(' - minuts %f, hours %f\n', t/60.0, t/(60.0*60.0));