function [my_data, my_sign, my_diff, my_transitions] = find_changes
%FIND_CHANGES Demonstrates finding transitions in data.
    FIG_NAME = 'Find Data Transitions';
    
    my_data = besselj(1, 0:0.2:30); % Data to analyze
    my_sign = sign(my_data); % Get positive or negative sign for data
    my_diff = diff(my_sign); % Find differences in sign array
    my_transitions = find(my_diff); % Find transitions in diff array
    
    createfigure(FIG_NAME, false);
    
    plot(my_data, 'bo-');
    
    enhancefigure([FIG_NAME, ' - Postive/Negative Changes'], ...
        'Data', 'Value');
    
    set(gca, 'XTick', my_transitions); % Set tick on transitions
    set(gca, 'YTick', [min(my_data), 0, max(my_data)]);
    %set(gca, 'Ylim', [min(my_data) - 1, max(my_data) + 1]);
    set(gca, 'XLim', [0, length(my_data)]);
    grid;
end
    