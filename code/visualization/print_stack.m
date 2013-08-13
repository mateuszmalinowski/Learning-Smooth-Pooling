function print_stack( stack )
%Prints stack.
% 
% In:
%   stack
% 
% Written by: Mateusz Malinowski
% Email: mmalinow@mpi-inf.mpg.de
% Created: 27.02.2012
%  

nn = numel(stack);
for j = 1:nn
  disp(stack{j}.w);
end

end

