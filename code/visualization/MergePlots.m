% This script merges plots.

%% Setting
conf = Configuration;

% dataset = conf.CIFAR10;
dataset = conf.CIFAR100;

% isTrainSet = true;
isTrainSet = false;

numCentroidsArray = 1600;

%% Directories

statisticsPath = fullfile(conf.experiments_dir, 'statistics');

% filePrefix = 'entropy_feature_label_';
filePrefix = 'mi_feature-label_';

fileSuffix = ['-dim_' num2str(numCentroidsArray)];
fileSuffixInit = [fileSuffix '-init'];
fileSuffixInitConst = [fileSuffixInit 'Const'];

if isTrainSet
  tmpSuffix = '-train';
else
  tmpSuffix = '-test';
end
fileSuffix = [fileSuffix tmpSuffix];
fileSuffixInit = [fileSuffixInit tmpSuffix];
fileSuffixInitConst = [fileSuffixInitConst tmpSuffix];

startIdx = 1;
endIdx = 6400;

loadFile = ...
  [filePrefix num2str(startIdx) '-' num2str(endIdx) fileSuffix];
loadFileInit = ...
  [filePrefix num2str(startIdx) '-' num2str(endIdx) fileSuffixInit];
loadFileConst = ...
  [filePrefix num2str(startIdx) '-' num2str(endIdx) fileSuffixInitConst];

figurePath = fullfile(statisticsPath, dataset, loadFile);
figurePathInit = fullfile(statisticsPath, dataset, loadFileInit);
figurePathInitConstant = fullfile(statisticsPath, dataset, loadFileConst);

figurePathCellArray = {figurePath, figurePathInit, figurePathInitConstant};

outputSuffix = '';
if isTrainSet
  outputSuffix = '-train';
else
  outputSuffix = '-test';
end

outputPath = fullfile( ...
  statisticsPath, dataset, [filePrefix 'Out-3plots' outputSuffix]);

%% Merging
outputTitle = '';
firstPlotColor = 'blue';
secondPlotColor = 'red';

plotAppearance.fontSize = 12;
plotAppearance.lineWidth = 2;

% merge_figures(figurePath, figurePathInit, outputPath, ...
%   outputTitle, secondPlotColor, firstPlotColor, ...
%   '', '', plotAppearance);
merge_n_figures(figurePathCellArray, outputPath, outputTitle);

% re-open the figure
fighandler = openfig(outputPath);
legend('Bag of Words','SPM','our', 'Location', 'Best');
set(gca, 'FontSize', plotAppearance.fontSize);
set(get(gca,'Children'), 'LineWidth', plotAppearance.lineWidth);
saveas(fighandler, outputPath);