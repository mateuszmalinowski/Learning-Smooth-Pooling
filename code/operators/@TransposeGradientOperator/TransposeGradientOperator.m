classdef TransposeGradientOperator < Operator
  %TRANSPOSEGRADIENTOPERATOR
  %
  % Transpose gradient operator which approximates transpose gradient
  % w.r.t. given dimension. This operator works on matrices.
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
    function obj = TransposeGradientOperator(dimension)
      % Constructor.
      %
      % Params:
      %   dimension - dimension w.r.t gradient is computed
      %     (HORIZONTAL, VERTICAL)
      %
      % Return:
      %   obj - constructed object
      %
      
      obj.dimension = dimension;
    end
    
    function At = matrix_transpose(A)
      At = GradientOperator(A.dimension);
    end
    
  end
  
end

