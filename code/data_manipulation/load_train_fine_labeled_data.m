function [trainX, trainY] = load_train_fine_labeled_data(datasetPath)
% Loads train data 
% 

  f1=load(fullfile(datasetPath, 'train.mat'));
  
  trainX = double(f1.data);
  
  if nargout > 1
    % add 1 to labels!
    trainY = ...
      double(f1.fine_labels) + 1;
  end
  
  clear f1;
  
end