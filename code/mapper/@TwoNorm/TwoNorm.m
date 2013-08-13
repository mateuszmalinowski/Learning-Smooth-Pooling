classdef TwoNorm < Mapper
  % Mapper of l-2 norm: 0.5 ||u||^2 where ||.|| is l2 norm, or Frobenius
  % norm in case if u is a matrix.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 19.04.2012
  % 
  
  properties( SetAccess = protected, GetAccess = protected )
    
    
    % multiplier/hyperparameter
    t
    
  end
  
  methods
    
    function obj = TwoNorm( hyperparameter )
      % Constructor of the mapper.
      %
      % Params:
      %   hyperparameter 
      %
      % Return:
      %   obj - instance
      %
      
      obj.t = hyperparameter;
      
    end
    
    function set_multiplier( obj, t )
      % Sets multiplier for all sites
      %
      % Params:
      %   t - multiplier to set
      %
      
      obj.t = t;
      
    end
    
  end
  
end

