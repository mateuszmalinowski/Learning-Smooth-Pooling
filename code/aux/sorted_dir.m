function list = sorted_dir( filepath, fileTemplate )
%SORT_FILES Works like dir but it returns files sorted alphanumerically.
%
% Example:
%   Assume there are following files: r_10.mat, r_1.mat, r_2.mat.
%   Then dir returns files in order r_10.mat, r_1.mat, r_2.mat,
%   but sorted_dir returns in order r_1.mat, r_2.mat, r_3.mat.
%   To execute: d = sorted_dir(fullfile(path, 'r_*.mat'), 'r_%d.mat').
% 
% In:
%   filepath 
%   fileTemplate - template to the file; for instance 'r_%d.mat' in the
%     example above
% 
% Out:
%   sorted files
% 
% Based on Jan Simon's post in Matlab Q&A.
% 

list = dir(filepath);
name = {list.name};
str  = sprintf('%s#', name{:});
num  = sscanf(str, [fileTemplate '#']);
[~, index] = sort(num);
list = list(index);

end

