function [testX, testY] = load_test_batch_data(datasetPath)
% Loads test data (batch format).
% 
  f1 = load(fullfile(datasetPath, 'test_batch.mat'));
  testX = double(f1.data);
  
  if nargout > 1
    testY = double(f1.labels)+1;
  end
  
  clear f1;
end