function enhancefigure(varargin)
%ENHANCEFIGURE Set title, xlabel and ylabel on an existing figure.
%
% Usage: ENHANCEFIGURE (title, xlabel, ylabel)

  %fignum = gcf;

  my_title = []; %#ok<NASGU>
  my_xlabel = [];
  my_ylabel = [];
  
  switch nargin
    case 1
      my_title = varargin{1};
    case 2
      my_title = varargin{1};
      my_xlabel = varargin{2};
    case 3
      my_title = varargin{1};
      my_xlabel = varargin{2};
      my_ylabel = varargin{3};
	otherwise
	  error('Wrong number of parameters.');
  end
  
  %figure(fignum);
  
  % TODO: How to detect if ygrid and xgrid is set?
  % NOTE: This also sets axis and labels to same color!
  if ismatlab
    set(gca, 'XColor', [0.35, 0.35, 0.35])
    set(gca, 'YColor', [0.35, 0.35, 0.35])
  end
  
  if ~isempty(my_title)
    title(my_title, 'FontWeight', 'bold', 'FontSize', 10, ...
        'Color', 'black') 
  end
  
  set(gca, 'FontSize', 8, 'FontWeight', 'normal');
  
  if ~isempty(my_xlabel)
    xlabel(my_xlabel, 'Color', 'black');
  end
  
  if ~isempty(my_ylabel)
    ylabel(my_ylabel, 'Color', 'black');
  end
end