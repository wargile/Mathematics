function ret = paretotest(varargin)
%PARETO creates a Pareto diagram.
%
%   A Pareto chart, named after Vilfredo Pareto, is a type of
%   chart which contains both bars and a line graph, that
%   displays the values in descending order as bars and the
%   cumulative totals of each category, left to right,
%   as a line graph.
%
%   See also:
%   http://www.mathworks.com/access/helpdesk/help/techdoc/ref/pareto.html
%
%   Double axis graphs:
%   http://www.mathworks.com/access/helpdesk/help/techdoc/...
%   creating_plots/f1-11215.html
    
    % NOTE: This is never reached because of varargin
    if nargin == 0
        error(['Missing parameter. ', ...
            'Usage: pareto(<numeric array>, <xlabel names array>)']);
    end
    
    unsorted_data = varargin{1};
    
    % data = fliplr(sort(varargin{1})); % Sort descending (old way)
    data = sort(varargin{1}, 'descend'); % Sort descending (new way)
    
    cumulative = zeros(1, length(data));
    
    % TODO: Sort the data in descending order
    
    p = 1;
    
    for i = 1:length(data)
        if i > 1
            p = i - 1;
        end
        
        cumulative(i) = cumulative(p) + data(i);
    end
    
    % Let's plot our Pareto diagram...
    
    bar_handle = bar(data);
    ch = get(bar_handle, 'Children');
    set(ch, 'EdgeColor', 'b');
    %k = 128;                % Number of colors in color table
    %colormap(summer(k));    % Expand the previous colormap
    %shading interp;         % Needed to graduate colors
    colormap cool;
    hold on;
    plot(cumulative, 'ro-');
    hold off;
    grid;
    box off;
    title('Pareto Chart', 'FontWeight', ...
        'bold', 'FontSize', 11)
    legend('Frequency', 'Cumulative percentage', ...
           'Location', 'NorthWest');
    set(gca, 'FontSize', 8, 'FontWeight', 'bold');
    %ylabel({'Cumulative','percentage'}); % MATLAB only
    ylabel('Cumulative percentage');
    xlabel('Frequency');
    set(gca, 'FontSize', 8, 'FontWeight', 'normal');
    set(gca,'Color', [0.95 0.96 0.95])
    
    if nargin == 2 && (length(varargin{1}) == length(varargin{2}))
        % Sort the xlabel names according to the sorted data
        
        sorted_xlabels = cell(1, length(data)); % Preallocate
        
        for i = 1:length(data)
            for p = 1:length(data)
                if unsorted_data(p) == data(i)
                    sorted_xlabels{i} = varargin{2}{p}; 
                end
            end
        end
        set(gca, 'XTick', 1:length(data))
        set(gca, 'XTickLabel', sorted_xlabels);
    end
    
    % Let's be kind and return our data...
    
    ret.data = data;
    ret.cumulative = cumulative;
end
