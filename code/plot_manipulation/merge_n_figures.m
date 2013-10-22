function merge_n_figures( ...
  figurePathCellArray, outputFigurePath, outputFigureTitle, ...
  plotAppearance )
%MERGE_N_FIGURES Merges more n figures.
%
% Params:
%   figurePathCellArray - cell array of pathes to figures
%   outputFigurePath - path of the output figure
%   outputFigureTitle - title of the output figure
%   plotAppearance - plot appearance parameters [optional];
%     plotAppearance.fontSize
%     plotAppearance.lineWidth
% 
%
% Written by: Mateusz Malinowski
% Email: m4linka@gmail.com
% Created: 25.03.2011
% 

if nargin < 4
  plotAppearance = [];
end

figPath1 = figurePathCellArray{1};

figurePathCellArrayTail = figurePathCellArray(2:end);

numFigures = length( figurePathCellArray );

colors = colormap( hsv( numFigures ) );

k = 0;
for figurePathNo = figurePathCellArrayTail
  
  figPath2 = figurePathNo{1};
  
  k = k + 1;
  
  if k == 1
    
    merge_figures( ...
      figPath1, ...
      figPath2, ...
      outputFigurePath, ...
      outputFigureTitle, ...
      colors( 2, : ), ...
      colors( 1, : ));
    
    figPath1 = outputFigurePath;
    
  else
    
    merge_figures( ...
      figPath1, ...
      figPath2, ...
      outputFigurePath, ...
      outputFigureTitle, ...
      colors( k + 1, : ));
    
  end  
  
end

end

