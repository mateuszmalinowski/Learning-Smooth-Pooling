function show_pooling_regions_separately( ...
  stack, nSamplesPerDim, layersIndices, isHardRegions, ...
  figName, savePath, numVizColumns, clims)
% Visualizes pooling regions.
% 
% Note:
%   we assume every layer has the same number of the pooling neurons.
% 
% In:
%   stack - stack with parameters; structure:
%     stack{k}.w denotes parameter w from k-th layer
%   nSamplesPerDim - tuple of two elements (nRows, nCols) denoting number 
%     of samples taken per each image dimension
%   layersIndices - list that contains indices of the layers to show;
%     [optional, default = starts from the first layer]
%   isHardRegions - if true then parameters are rounded to the closest
%     integer, [optional, default = false]
%   figName - figure's name [optional, default = null]
%   savePath - path to save figure [optional, default = null]
%   numVizColumns - number of columns in visualization 
%     [optional, default = 2];
%   clims - the rescaling vector [min, max]; rescale from min to max;
%     if clims == [] then rescalling happens per region separately;
%     [optional, default = []];
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 16.04.2012
%

nLayers = numel(stack);

if nargin < 3 || isempty(layersIndices)
  layersIndices = 1:nLayers;
end

if nargin < 4 || isempty(isHardRegions)
  isHardRegions = false;
end

if nargin < 5 || isempty(figName)
  figName = '';
end

if nargin < 6
  savePath = [];
end

% the number of columns in visualization
if nargin < 7 || isempty(numVizColumns)
  numColumns = 2;
else
  numColumns = numVizColumns;
end

if nargin < 8
  clims = [];
end

for layerNo = layersIndices
  w = stack{layerNo}.w;
  
  if isHardRegions
    w = round(w);
  end
  
  numPoolingNeurons = size(w, 1);
  
  for ii = 1:numPoolingNeurons
    
    mw = reshape(w(ii, :), nSamplesPerDim(1), nSamplesPerDim(2));
    
    h = figure('Name', figName);
    if isempty(clims)
      imagesc(mw);
    else
      imagesc(mw, clims);
    end

    colormap gray
    
    axis off;
    
    clear img;

    if ~isempty(savePath)
      saveas(h, [savePath '_poolingNeuronNo' num2str(ii) ...
      '_layerNo' num2str(layerNo)], 'fig');
    end
    
  end
  
  
end

end
