function create_dir(pathName)
% Creates directory if doesn't exist
% 
% Input:
%   pathName - path to directory
% 
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 30.08.2011
%

if ~exist(pathName, 'dir')
  mkdir(pathName);
end

end