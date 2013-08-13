classdef DifferenceOperator < Operator
  %DIFFERENCEOPERATOR
  %
  % Takes matrix [W1;W2], and computes W1 - W2. This operator assumes that
  % size(W1) = size(W2).
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 28.05.2012
  % 
  
  properties (Constant)

  end
    
  methods
    function obj = DifferenceOperator()
      % Constructor.
      %
      % Return:
      %   obj - constructed object
      %
      
    end
    
    function At = matrix_transpose(~)
      At = DifferenceOperator();
    end
    
  end
  
end

