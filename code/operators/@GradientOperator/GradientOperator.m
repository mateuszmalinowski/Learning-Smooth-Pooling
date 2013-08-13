classdef GradientOperator < Operator
  %GRADIENTOPERATOR
  %
  % Gradient operator which approximates gradient w.r.t. specific
  % dimension. This operator works on matrices.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 22.02.2010
  % 
  
  properties (Constant)
    % horizontal approximation
    HORIZONTAL = 2
    
    % vertical approximation
    VERTICAL = 1
  end
  
  properties
    % dimension w.r.t. gradient is computed
    dimension
  end
  
  methods
    function obj = GradientOperator(dimension)
      % Constructor.
      %
      % Params:
      %   dimension - dimension w.r.t gradient is computed
      %     (HORIZONTAL, VERTICAL)
      %
      % Return:
      %   obj - constructed object
      %
      
      assert(any(dimension == [1,2]));
      
      obj.dimension = dimension;
    end
    
    function At = matrix_transpose(A)
      At = TransposeGradientOperator(A.dimension);
    end
    
  end
  
end

