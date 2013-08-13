classdef NullMapper < Mapper
  % Mapper that returns 0.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 26.04.2012
  % 
  
  methods
    
    % evaluates the expression
    function val = eval( ~, ~, varargin )
      val = 0;
    end
    
    % computes gradient
    function gradient = compute_gradient( ~, ~, varargin )
      gradient = 0;
    end
    
    % computes Hessian as a function of vector v
    function hessian = compute_hessian( ~, ~, varargin )
      hessian = 0;
    end
    
    % sets multiplier
    set_multiplier( obj, t )
    
  end
  
end

