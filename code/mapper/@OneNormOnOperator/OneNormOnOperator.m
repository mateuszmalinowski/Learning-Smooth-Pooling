classdef OneNormOnOperator < Mapper
  % Mapper of l-2 norm: 0.5 ||Xu|| where ||.|| is 
  % an approximation of the l1 norm. 
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 05.02.2013
  % 
  
  properties( SetAccess = protected, GetAccess = protected )
    
    
    % multiplier/hyperparameter
    t
    
    % linear operator, and its transpose
    X
    Xt
    
    % approximation
    epsilon
    
  end
  
  methods
    
    function obj = OneNormOnOperator(operator, hyperparameter, precision)
      % Constructor of the mapper.
      %
      % Params:
      %   operator
      %   hyperparameter 
      %   precision
      %
      % Return:
      %   obj - instance
      %
      
      obj.t = hyperparameter;
      
      obj.X = operator;
      
      obj.Xt = operator';
      
      if nargin == 3
        obj.epsilon = precision;
      else
        obj.epsilon = 0.00001;
      end
      
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

