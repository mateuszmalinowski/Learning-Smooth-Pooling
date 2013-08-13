function [mini, maxi] = find_min_max_in_stack(stack)
% Finds minimal and maximal value in the whole stack.
% 
% In:
%   stack
% 
% Out:
%   mini, maxi - minimal and maximal value in the stack
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 18.04.2012
%

nLayers = numel(stack);

layersIndices = 1:nLayers;

mini = 1000;
maxi = -mini;
for layerNo = layersIndices
  w = stack{layerNo}.w;
  
  miw = min(w(:));
  maw = max(w(:));
  
  if miw < mini, mini = miw; end;
  if maw > maxi, maxi = maw; end;
  
end

end

