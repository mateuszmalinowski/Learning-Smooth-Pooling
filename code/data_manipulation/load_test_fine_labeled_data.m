function [testX, testY] = load_test_fine_labeled_data(datasetPath)
% Loads test data.
% 
  f1 = load(fullfile(datasetPath, 'test.mat'));
  testX = double(f1.data);
  
  if nargout > 1
    testY = double(f1.fine_labels) + 1;
  end
  
  clear f1;
end