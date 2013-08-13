function stack = params2stack(params, netconfig)

% Converts a flattened parameter vector into a nice "stack" structure 
% for us to work with. This is useful when you're building multilayer
% networks.
%
% stack = params2stack(params, netconfig)
%
% params - flattened parameter vector representing the stack
% netconfig - auxiliary variable containing 
%             the configuration of the network
%

% Map the params (a vector into a stack of weights)
depth = numel(netconfig.layersizes);
stack = cell(depth,1);
prevLayerSize = netconfig.inputsize; % the size of the previous layer
curPos = double(1);                  % mark current position in parameter vector

for d = 1:depth
    % Create layer d
    stack{d} = struct;

    % Extract weights
    wlen = double(netconfig.layersizes{d} * prevLayerSize);

    stack{d}.w = reshape( ...
      params(curPos:curPos+wlen-1), netconfig.layersizes{d}, prevLayerSize);
    curPos = curPos+wlen;
    
    % Set previous layer size
%     prevLayerSize = netconfig.layersizes{d};
end

end