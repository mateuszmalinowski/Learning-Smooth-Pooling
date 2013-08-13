function [trainX, trainY] = load_train_batch_data(datasetPath)
% Loads train data (batch format)
% 

  f1=load(fullfile(datasetPath, 'data_batch_1.mat'));
  f2=load(fullfile(datasetPath, 'data_batch_2.mat'));
  f3=load(fullfile(datasetPath, 'data_batch_3.mat'));
  f4=load(fullfile(datasetPath, 'data_batch_4.mat'));
  f5=load(fullfile(datasetPath, 'data_batch_5.mat'));
  
  trainX = double([f1.data; f2.data; f3.data; f4.data; f5.data]);
  
  if nargout > 1
    % add 1 to labels!
    trainY = ...
      double([f1.labels; f2.labels; f3.labels; f4.labels; f5.labels]) + 1;
  end
  
  clear f1 f2 f3 f4 f5;
  
end