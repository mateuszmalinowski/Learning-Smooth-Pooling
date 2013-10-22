function pictureName = get_picture_name( picturePath )
% Gets picture name from the path
%
% Params:
%   picturePath - path to the picture (with '/' convection)
%
% Return:
%   pictureName - name of the picture 
%
% Usage:
%   pictureName = get_picture_name('pics/monkey.png') 
%       returns monkey
%   

tmp = strsplit('/', picturePath);
tmp2 = strsplit('.', tmp{end});
pictureName = tmp2{1};


end

