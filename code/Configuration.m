function config = Configuration()
% Set paths, and parameters for the experiments
% 
% Note:
%   be sure paths are set to absolute values if executed on the cluster
% 


% path to dataset
config.dataset_dir = fullfile('', 'data', 'databases');

% local data such as intermediate results;
% remember to set it to the absolute path's value 
% if it is executed on the cluster
config.local_dir = fullfile('', 'data', 'local_data');

% different datasets and their path names
config.CIFAR10 = 'CIFAR-10';
config.CIFAR10_DATASET = 'cifar-10-matlab';
config.CIFAR100 = 'CIFAR-100';
config.CIFAR100_DATASET = 'cifar-100-matlab';

% turn on/off the bias term for the classifier;
% by default it is off as it is harmful during the transfer
config.isBias = false;

% Choose the working dataset
config.working_dataset = config.CIFAR10;

% leave it empty if we don't want to transfer across datasets
config.source_dataset = [];
% config.source_dataset = config.CIFAR100;

% dictionary size; when approximation is used then the size of the batch
config.dictionary_size = 40;
% config.dictionary_size = 1600;

% the size of original dictionary - important only with the approximation
config.original_dictionary_size = 1600;

end