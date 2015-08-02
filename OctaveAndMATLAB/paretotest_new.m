function h = paretotest_new(varargin)
%PARETOTEST_NEW Creates a Pareto diagram in Terje's style.
%
%   A Pareto chart, named after Vilfredo Pareto, is a type of
%   chart which contains both bars and a line graph, that
%   displays the values in descending order as bars and the
%   cumulative totals of each category, left to right,
%   as a line graph.
%
%   Usage: PARETOTEST_NEW(<numeric array>, [x-axis names array],
%                         [left_y_axis_tight true|false],
%                         [cumulative_zero_offset true|false],
%                         [get_maximum_ten_elements true|false])
    
    FIG_NAME = 'Pareto Chart';
    
    if nargin == 0
        error(['Missing parameter(s). ', ...
            'Usage: pareto(<numeric array>, <x-axis names array>) ', ...
            '[left_y_axis_tight true|false], ', ...
            '[cumulative_zero_offset true|false], ', ...
            '[get_maximum_ten_elements true|false])']);
    end
    
    left_y_axis_tight = false;
    cumulative_zero_offset = false;
    get_maximum_ten_elements = false;
    
    if nargin > 2
        left_y_axis_tight = varargin{3};
    end
    
    if nargin > 3
        cumulative_zero_offset = varargin{4};
    end
    
    if nargin > 4
        get_maximum_ten_elements = varargin{5};
    end
    
    if (nargin > 1) && (numel(varargin{1}) ~= numel(varargin{2})) && ...
        (numel(varargin{2}) > 0)
        disp(['warning: Array size mismatch. ', ...
            'Using default numeric xlabels.']);
    end

    MAX_PERCENT_TICKS = 6; % Sets number of ticks on both y-axis
    data = varargin{1};
    
    if get_maximum_ten_elements == true && length(data) > 10
        % Get max 10 most important elements
        temp_data = zeros(1, 10);
        
        for x = 1:10
            [temp_data(x), idx] = max(data); % Get max element
            data(idx) = []; % Delete the transferred element from data
        end
        
        data = temp_data;
    end
        
    % [data, idx] = fliplr(sort(varargin{1})); % Sort desc (old way)
    [data, idx] = sort(data, 'descend'); % Sort desc (new way)
    % NOTE: idx is the position of the elements before sorting
    
    cumulative_percent = zeros(1, length(data) + cumulative_zero_offset);
    % NOTE: Cumulative_zero_offset: Add element to get zero offset node
    
    for x = 1:length(data)
        cumulative_percent(x + cumulative_zero_offset) = ...
            (sum(data(1:x)) * 100) / sum(data);
        % Get cumulation in percent
    end
    
    % Create a new named figure
    createfigure(FIG_NAME, true);
    
    hold on;

    [AX, H1, H2] = plotyy((1:length(data)), data, ...
        (1:length(data) + cumulative_zero_offset), ...
        cumulative_percent, @bar, @plot);
    
    set(H1, 'FaceColor', [0.46 0.67 0.88]);
    set(H1, 'EdgeColor', 'blue');
    %ch = get(H1, 'Children');
    %set(ch, 'EdgeColor', 'b');
    
    set(AX, 'FontSize', 9, 'FontWeight', 'bold');
    xlabel('Response variables');
    set(AX, 'FontSize', 8, 'FontWeight', 'normal');
    set(get(AX(1), 'YLabel'), 'String', 'Frequency');
    set(get(AX(2), 'YLabel'), 'String', 'Cumulative percentage');
    set(get(AX(1), 'YLabel'), 'FontWeight', 'bold');
    set(get(AX(2), 'YLabel'), 'FontWeight', 'bold');
    % h_marker = get(H2, 'Marker');
    set(H2, 'Marker', 'o'); % No plot marker
    set(H2, 'Color', 'blue'); % Set plot color
    set(AX(2), 'YColor', 'black'); % Set right y-axis color
    
    %set(H2, 'LineSmoothing', 'on');
    
    ticklabels = cell(1, MAX_PERCENT_TICKS);
    y2_ticks = linspace(0, 100, MAX_PERCENT_TICKS);
    
    for i = 1:length(y2_ticks) % Create percent labels for right y-axis
        ticklabels{i} = sprintf('%d%%', y2_ticks(i));
    end
    
    set (AX(2), 'YTick', linspace(0, 100, MAX_PERCENT_TICKS), ... 
       'YTickLabel', ticklabels);
   
    if left_y_axis_tight == false
        set(AX(1), 'YLim', [0, sum(data)]);
        y1_ticks = round(linspace(0, sum(data), MAX_PERCENT_TICKS));
    else
        set(AX(1), 'YLim', [0, max(data)]);
        y1_ticks = round(linspace(0, max(data), MAX_PERCENT_TICKS));
        %axis tight
    end

    title('Pareto Chart', 'FontWeight', 'bold', 'FontSize', 11, ...
        'Color', 'black')
    
    if ismatlab
        legend('Frequency', 'Cumulative percentage', ...
                          'Location', 'Best');
    else
        legend('Frequency', 'Cumulative percentage', ...
                          'Location', 'NorthWest');
    end
    
    set(H1,'LineWidth', 1);
    set(H2,'LineWidth', 1,'LineStyle', '-');
    set(AX(1), 'Color', [0.92 0.99 0.95]);
    set(AX(1), 'YGrid', 'on')
    set(AX(1), 'XGrid', 'off')
    set(AX(1), 'YTick', y1_ticks);
    set(AX(2), 'YLim', [0, 100]);
    set(AX(1), 'XTick', 1:length(data));
    set(AX(2), 'XTick', 1:length(data));
    % NOTE: Blank to avoid double labels
    set(AX(2), 'XTickLabel', []);

    box off;
    
    if (ishold()) % Test for hold state
        hold off;
    end
    
    if nargin > 1 && (length(varargin{1}) == length(varargin{2}))
        % Sort the xlabel names according to the sorted data
        sorted_xlabels = cell(1, length(data)); % Preallocate
        
        for i = 1:length(data)
            sorted_xlabels{i} = varargin{2}{idx(i)};
        end
        
        set(AX(1), 'XTickLabel', sorted_xlabels);
    end
 
    % Return data to caller
    if nargout > 0
        h.data = data;
        h.cumulative = cumulative_percent;
        h.old_idx = idx;
        h.AX = AX;
        h.H1 = H1;
        h.H2 = H2;

        if nargin == 2 && (length(varargin{1}) == length(varargin{2}))
            h.xlabels = sorted_xlabels;
        end
    end
end