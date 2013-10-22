function  merge_figures( ...
  figurePath1, figurePath2, outputFigurePath, ...
  outputFigureTitle, secondPlotColor, firstPlotColor)
%MERGE_PLOTS Merges two figures.
%
% Params:
%   figurePath1 - path of the first figure
%   figurePath2 - path of the second figure
%   outputFigurePath - path of the output figure
%   outputFigureTitle - title of the output figure
%   secondPlotColor - color of the graph in figure 2
%   firstPlotColor - color of the graph in figure 1
%     [optional, default = default color]
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 24.03.2011
% 

inName1 = [figurePath1 '.fig'];
inName2 = [figurePath2 '.fig'];
outName = [outputFigurePath '.fig'];

fighandler1 = openfig( inName1 );
fighandler2 = openfig( inName2 );

set( findobj( fighandler2, 'type', 'line' ), 'Color', secondPlotColor );

if nargin >= 6 && ~isempty(firstPlotColor)
  
  set( findobj( fighandler1, 'type', 'line' ), 'Color', firstPlotColor );
  
end

if nargin < 7
  legend1 = '';
  legend2 = '';
end

L = findobj( fighandler1, 'type', 'line' );
copyobj( L, findobj( fighandler2, 'type', 'axes' ) );
title( outputFigureTitle );

saveas( fighandler2, outName ); 

close(fighandler1);
close(fighandler2);

% clear all;
% close all;

end

