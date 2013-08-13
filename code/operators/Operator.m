classdef Operator < handle
  %OPERATOR - abstraction of operator.
  %   
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 29.01.2010
  % 
  
  properties 
  end
  
  properties (GetAccess = protected, SetAccess = protected)
    % cell array of observers
    mTimesObserver = []
  end
  
  methods
    
    function Ab = mtimes(A,b)
      Ab = matrix_application(A,b);
      
      if ~isempty(A.mTimesObserver)
        A.mTimesObserver.update();
      end
    end
    
    function At = ctranspose(A)
      At = matrix_transpose(A);
      
      if ~isempty(A.mTimesObserver)
        At.attach_observer(A.mTimesObserver);
      end
      
    end
    
    function attach_observer(obj, observer)
      % Attach observer to object.
      %
      % Params:
      %   observer - instance of subclass IObserver
      %
      
      obj.mTimesObserver = observer;
    end
    
    function observer = last_observer(obj)
      % Returns the last attached observer.
      %
      % Return:
      %   observer - last attached observer
      %
      
      observer = obj.mTimesObserver;
    end
  end
  
  methods(Access = protected)
    function v = isAppropriateOperator(A, className)
      % Checks if A has appropriate type
      %
      % Params:
      %   A - object to check
      %
      % Return:
      %   v - true iff A has TakeImaginaryOperator type
      %
      
      v = isa(A, className);
    end
  end
  
  methods(Abstract)
    
    % non-commutative operation which mimics A * x    
    ab = matrix_application(A,x);
    
    % computes conjugate transpose of A
    At = matrix_transpose(A)
        
  end
  
end