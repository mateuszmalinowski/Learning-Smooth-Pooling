classdef ApplyToTensorOperator < Operator
  %APPLYTOTENSOROPERATOR
  %
  % Applies an operator to tensor along the first dimension. More
  % precisely, if G is an operator and T is a three dimensional tensor then
  % ApplyToTensorOperator(G) * T = [G * T(k,:,:)]_k.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 20.04.2012
  % 
  
  properties
    G
  end
  
  methods
    function obj = ApplyToTensorOperator(op)
      % Constructor.
      %
      % Params:
      %   op - operator G 
      %
      % Return:
      %   obj - constructed object
      %

      obj.G = op;
      
    end
    
    function At = matrix_transpose(A)
      At = ApplyToTensorOperator(A.G');
    end
    
  end
  
end

