AddPath;

currentPart = 0;

%% Compute triangle codes
tic;
ComputeTriangleCodes;
t=toc;
fprintf('Triangle codes computed\n');
fprintf('- minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));

%% Compute pooling regions together with the classifier
tic; 
TriangleCodingPoolingRegions(currentPart); 
t=toc;
fprintf('Joint training of the classifier and the pooling regions\n');
fprintf('- minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));