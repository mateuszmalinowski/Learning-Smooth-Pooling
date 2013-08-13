AddPath;

disp('Training with the approximation');

%% Compute triangle codes
tic;
ComputePooledFeatures;
t=toc;
fprintf('Pooled features are computed\n');
fprintf('- minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));

%% Split into batches
tic;
TransferTriangleFeaturesSVM;
t=toc;
fprintf('Classification with the SVM\n');
fprintf(' - minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));
