classdef TwoNormOnOperator < Mapper
  % Mapper of l-2 norm: 0.5 ||Xu||^2 where ||.|| is l2 norm, or Frobenius
  % norm in case if u is a matrix, and X is some linear operator.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 19.04.2012
  % 
  
  properties( SetAccess = protected, GetAccess = protected )
    
    
    % multiplier/hyperparameter
    t
    
    % linear operator, and its transpose
    X
    Xt
    
  end
  
  methods
    
    function obj = TwoNormOnOperator( operator, hyperparameter )
      % Constructor of the mapper.
      %
      % Params:
      %   operator
      %   hyperparameter 
      %
      % Return:
      %   obj - instance
      %
      
      obj.t = hyperparameter;
      
      obj.X = operator;
      
      obj.Xt = operator';
      
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

