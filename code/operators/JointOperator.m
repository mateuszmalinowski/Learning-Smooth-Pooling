classdef JointOperator < Operator
  % Operator that takes another operator two operators U, F and stores
  % them as U * F.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 26.09.2010
  % 
  
  properties (SetAccess = protected, GetAccess = protected)
    % outer operator
    Outer
    
    % inner operator
    Inner
  end
  
  methods
    function obj = JointOperator(U, F)
      % Constructor.
      %
      % It performs U * F * u.
      %
      % Params:
      %   U - outer operator
      %   F - inner operator
      %
      % Return:
      %   obj - constructed object
      %
      
      obj.Outer = U;
      obj.Inner = F;
    end
      
    function At = matrix_transpose(A)
      At = JointOperator( A.Inner', A.Outer' );
    end
    
    function Ax = matrix_application(A, x)
      % Computes undersampled fft of signal x.
      
      Ax = A.Outer * (A.Inner * x);
    end
        
  end
  
end

