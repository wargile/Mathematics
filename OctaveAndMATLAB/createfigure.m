function createfigure(figname, erasefigure)
%CREATEFIGURE Creates a new named figure, or set focus
% on an existing figure with the supplied name.
%
% CREATEFIGURE <figure name> [erase figure]
% If parameter 'erasefigure' is not zero, erases old figure.

  fignum = findobj('type', 'figure', 'name', figname);

  if nargin == 0
    figname = 'New Figure';
    erasefigure = false;
  end
  
  if nargin == 1
    erasefigure = false;
  end
  
  if isempty(fignum)
    % Figure not found, create new 
    figure('name', figname);
  else
    % Figure found, set active
    figure(fignum);
    
    if erasefigure
      clf;
    end
  end
end

