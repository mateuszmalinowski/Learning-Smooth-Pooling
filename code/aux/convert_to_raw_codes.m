function outputData = convert_to_raw_codes(inputData)
% convert inputData into outputData, where
% inputData{j} = data(numSamples, numData) of j-th layer (coordinate), and  
% outputData{k} = data(numCoordinates, numSamples) of k-th data point
% 
% Notes:
%   Very slow, should be rewritten.
% 
% In:
%   inputData 
% 
% Out:
%   output data
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 10.05.2012
% 

numCoordinates = length(inputData);
numData = size(inputData{1}, 2);
numSamples = size(inputData{1}, 1);

outputData = cell(numData, 1);
data = zeros(numCoordinates, numSamples);

for dataNo = 1:numData
  for coordinateNo = 1:numCoordinates
    data(coordinateNo, :) = inputData{coordinateNo}(:, dataNo);
  end
  
  outputData{dataNo} = data;
  
end

end

