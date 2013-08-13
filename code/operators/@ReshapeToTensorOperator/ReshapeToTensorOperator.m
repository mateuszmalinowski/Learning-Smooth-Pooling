classdef ReshapeToTensorOperator < Operator
  %RESHAPETOTENSOROPERATOR
  %
  % Takes matrix, reshape every row into matrix, and outputs three
  % dimensional tensor. The first dimension of tensor corresponds to the
  % row of the original matrix, that is Au(k,:,:) = u(k,:). Its transpose
  % is also its inverse which transforms three dimensional tensor into the
  % corresponding matrix.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 20.04.2012
  % 
  
  properties
    nRows
    nCols
    isTensorAsResult
  end
  
  methods
    function obj = ReshapeToTensorOperator(nRows, nCols, isTensor)
      % Constructor.
      %
      % Params:
      %   nRows - number of rows 
      %   nCols - number of columns     
      %     Every row of a given matrix is transformed into matrix with
      %     nRows rows and nCols columns.
      %   isTensor - true if the result of reshaping become a tensor
      %     [optional, by default = true]
      %
      % Return:
      %   obj - constructed object
      %

      if nargin < 3 || isempty(isTensor)
        isTensor = true;
      end
      
      obj.nRows = nRows;
      obj.nCols = nCols;
      
      obj.isTensorAsResult = isTensor;
      
    end
    
    function At = matrix_transpose(A)
      % if result is tensor then transpose produces matrix, and so 
      % isTensorAsResult == false; otherwise transpose produces tensor, and
      % so isTensorAsResult == true
      At = ReshapeToTensorOperator(A.nRows, A.nCols, ~A.isTensorAsResult);
    end
    
  end
  
end

