function ret = pareto_tb(varargin)
%PARETO_TB creates a Pareto diagram.
%
%   A Pareto chart, named after Vilfredo Pareto, is a type of
%   chart which contains both bars and a line graph that
%   displays the values in descending order as bars and the
%   cumulative totals of each category, left to right,
%   as a line graph.
    
    if nargin == 0
        error('Missing parameter. Usage: pareto(<numeric array>)');
    end
    
    data = fliplr(sort(varargin{1})); % Sort descending
    
    cumulative = zeros(1, length(data));
    
    % TODO: Sort the data in descending order
    
    i = 1;
    p = 1;
    
    for i = 1:length(data)
        if i > 1
            p = i - 1;
        end
        
        cumulative(i) = cumulative(p) + data(i);
    end
    
    % Let's plot our Pareto diagram...
    
    bar(data);
    hold on;
    plot(cumulative, 'ro-');
    hold off;
    grid;
    box off;
    title('Pareto chart', 'FontWeight', ...
        'bold', 'FontSize', 10)
    set(gca, 'FontSize', 8);
    set(gca,'Color', [0.95 0.96 0.95])
    ylabel('Cumulative percentage');
    xlabel('Defects');
    legend('Cumulative percentage', 'Defects', ...
           'Location', 'NW');
    
    % Let's be kind and return our data...
    
    ret.data = data;
    ret.cumulative = cumulative;