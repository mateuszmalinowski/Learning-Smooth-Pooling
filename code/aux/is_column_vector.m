function isColumn = is_column_vector( v )
%IS_COLUMNT_VECTOR Checks if vector is a column vector (matrix m-by-1).
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 19.02.2012
% 

if size(v, 2) == 1
  isColumn = true;
else
  isColumn = false;
end

end

