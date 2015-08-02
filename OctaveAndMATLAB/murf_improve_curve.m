function [pot_pos_rise, pot_pos_fall, the_curve_rise, the_curve_fall] = ...
    murf_improve_curve(max_elements, pot_pos)
%MURF_IMPROVE_CURVE Calculate pot_pos rise and fall percents

    max_pot_pos = 10;
    min_pot_pos = 0;
    %ref_voltage = 5;
    %ratio = fall/rise;

    rise = [0 4  9 22 50 5 50 22  9 4 0];
    fall = [2 8 16 36 70 5 70 36 16 8 2];
    
    if nargin < 2
        max_elements = 100;
        pot_pos = 5;
    end
    
    if max_pot_pos < 0 || (pot_pos < min_pot_pos) || (pot_pos > max_pot_pos)
        error('Invalid paramter values.');
    end

    % Return data for pot_pos input param
    [pot_pos_rise, pot_pos_fall] = get_pot_pos(pot_pos);
    
    createfigure('MuRF Curve');

    subplot(2, 1, 1);
    plot(rise, 'c.-');
    hold on;
    plot(fall, 'g.-');

    start_interval = floor(pot_pos + 1);

    if (pot_pos ~= (max_pot_pos / 2.0)) && (pot_pos < max_pot_pos)
        start_offset_rise = mod(pot_pos + 1, start_interval);
        current_rise = rise(start_interval) + ...
            ((rise(start_interval + 1) - rise(start_interval)) * ...
            start_offset_rise) / 1.0;

        start_offset_fall = mod(pot_pos + 1, start_interval);
        current_fall = fall(start_interval) + ...
            ((fall(start_interval + 1) - fall(start_interval)) * ...
            start_offset_fall) / 1.0;
    elseif pot_pos == (max_pot_pos / 2.0)
        current_rise = rise((max_pot_pos / 2.0) + 1);
        current_fall = fall((max_pot_pos / 2.0) + 1);
    else
        current_rise = rise(max_pot_pos + 1);
        current_fall = fall(max_pot_pos + 1);
    end

    plot(pot_pos + 1, current_rise, 'b*');
    plot(pot_pos + 1, current_fall, 'b*');
    hold off;
    ylim([-3 max(fall) + 3]);
    set(gca, 'YGrid', 'on');
    set(gca, 'XTick', 0:max_pot_pos + 1);
    set(gca, 'XTickLabel', ...
        {'', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'});
    
    if pot_pos <= 7
        text(pot_pos + 1.1, current_fall, ...
            '\leftarrow Percent rise/fall', ...
            'HorizontalAlignment', 'left');
    else
        text(pot_pos + 0.9, current_fall, ...
            'Percent rise/fall \rightarrow', ...
            'HorizontalAlignment', 'right');
    end
    
    box off;
    enhancefigure('MuRF Curve', 'Pot Position', ...
        'Rise/Fall Percent');
        
    subplot(2, 1, 2);
    interval = 5 / (max_elements / 2.0);
    
    the_curve_rise = zeros(1, floor(5 / interval));
    the_curve_fall = zeros(1, floor(5 / interval));
    element = 1;
    
    if pot_pos <= (max_pot_pos / 2.0)
        start_pos = min_pot_pos;
        end_pos = (max_pot_pos / 2.0);
    else
        start_pos = (max_pot_pos / 2.0);
        end_pos = min_pot_pos;
        interval = interval * -1;
    end

    % Find which part of the curve we're on
    if pot_pos < (max_pot_pos / 2.0)
        p1 = get_pot_pos(pot_pos);
        p2 = get_pot_pos(pot_pos + 0.0001);
        
        if p1 < p2
            position = 'LEFT';
        else
            position = 'MIDDLE';
        end
    else
        p1 = get_pot_pos(max_pot_pos - pot_pos);
        p2 = get_pot_pos(max_pot_pos - pot_pos + 0.0001);
        
        if p1 > p2
            position = 'MIDDLE';
        else
            position = 'RIGHT';
        end
    end

    fprintf('p1: %.16f p2: %.16f Pos: %s\n', p1, p2, position);

    for counter = start_pos:interval:end_pos - interval
        [data_pot_pos_rise, data_pot_pos_fall] = ...
            get_pot_pos(counter);
    
        the_curve_rise(element) = data_pot_pos_rise;
        the_curve_fall(element) = data_pot_pos_fall;
        element = element + 1;
    end

    plot(the_curve_rise, 'b.-');
    hold on;
    plot(the_curve_fall, 'r.-');
    hold off;
    %axis tight;
    grid;
    box off;
    enhancefigure('', 'Pot Position', 'Rise/Fall Percent');

function [data_pot_pos_rise, data_pot_pos_fall] = get_pot_pos(pot_pos)
    % TEST with x^2 curve for rise and fall, interval 0->5
    pos_rise = pot_pos; % Interval 0->4: No extra needed
    pos_fall = pot_pos;
    curve_break = 4;
    
    if pot_pos > curve_break
        start = curve_break; % Where we left off
        
        dip_rise = 1.6; % End of curve dip
        dip_fall = 0.22; %1.055;
        
        advance = abs(curve_break - pot_pos);
        ratio_rise = (start - dip_rise) / 1.0; % / 1 = interval 4 to 5
        pos_rise = start - (advance * ratio_rise);
        ratio_fall = (start - dip_fall) / 1.0; % / 1 = interval 4 to 5
        pos_fall = start - (advance * ratio_fall);
    end

    %data_pot_pos_rise = realpow(pos_rise * 1.75, 2);
    data_pot_pos_rise = realpow(pos_rise * 1.9, 2);
    data_pot_pos_fall = realpow((pos_fall * 2.3), 2) + 10;

   
    %Matlab tips:
    %set( line_handle, 'XData', new_x_data, 'YData', new_y_data )    
    %will modify a line object in an existing diagram.
