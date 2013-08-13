% Converts figures to pdfs
% 

conf = Configuration;

% true if we want to plot everything in the folder; otherwise it skips
% files that have pdf extension
isPlotEverything = true;

% dataset = conf.CIFAR10;
% dataset = conf.CIFAR100;
dataset = conf.MIT_INDOOR;

isBlackAndWhite = false;

MAIN_DIR = 'tmp';
% MAIN_DIR = 'data';
% MAIN_DIR = conf.experiments_dir;
SUBDIRECTORY_IN_DATASET = '';
% SUBDIRECTORY_IN_DATASET = 'play_with_regularizations';
% SUBDIRECTORY_IN_DATASET = 'icml_submission';
SUBDIRECTORY_TO_VISUALIZE = '';
% SUBDIRECTORY_TO_VISUALIZE = 'cv_viz';
% SUBDIRECTORY_TO_VISUALIZE = 'pooling_regions';
% SUBDIRECTORY_TO_VISUALIZE = 'pooling_regions_with_classifier';
% SUBDIRECTORY_TO_VISUALIZE = 'statistics';
% SUBDIRECTORY_TO_VISUALIZE = 'FullConfusion';
% SUBDIRECTORY_TO_VISUALIZE = 'results';
CV_VIZ_DIR_DATASET = fullfile(MAIN_DIR, SUBDIRECTORY_TO_VISUALIZE, ...
  dataset, SUBDIRECTORY_IN_DATASET);

addpath('plot_manipulation');

d = dir(fullfile(CV_VIZ_DIR_DATASET, '*.fig'));
dlen = length(d);

for ii = 1:dlen
  fullpath = fullfile(CV_VIZ_DIR_DATASET, d(ii).name);
  
  [pathstr, filename, ~] = fileparts(fullpath);
  
  if isPlotEverything
    fig2pdf(fullfile(pathstr, filename), isBlackAndWhite);
  else
    if ~exist(fullfile(pathstr, [filename '.pdf']), 'file')
      fig2pdf(fullfile(pathstr, filename), isBlackAndWhite);
    end
  end
end

rmpath('plot_manipulation');