AddPath;

disp('Training with the approximation -- input preparation');

%% Compute triangle codes
tic;
ComputeTriangleCodes;
t=toc;
fprintf('Triangle codes computed\n');
fprintf('- minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));

%% Split into batches
tic;
SplitCodes;
t=toc;
fprintf('Codes are split\n');
fprintf(' - minutes %f, hours %f\n', t/60.0, t/(60.0*60.0));
