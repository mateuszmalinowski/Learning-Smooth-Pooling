function dataCell = convert_data(inputData)
% convert inputData into dataCell, where
% inputData{j} = data(numCoordinates, numSamples) of j-th data point, and
% dataCell{k} = data(numSamples, numData) of k-th layer (coordinate) 
% 
% In:
%   inputData 
% 
% Out:
%   output data
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 19.02.2012
% 

numCoordinates = size(inputData{1}, 1);  % number of codes
numData = length(inputData);  % number of data
numSamples = size(inputData{1}, 2);

dataCell = cell(numCoordinates, 1);
data = zeros(numSamples, numData);
for j = 1:numCoordinates
  for k = 1:numData
    data(:, k) = inputData{k}(j, :);
  end
  dataCell{j} = data;
end

end

