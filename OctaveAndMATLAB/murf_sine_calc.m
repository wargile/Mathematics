function [rise_percent, fall_percent, max_elements, org_pot_pos] = ...
    murf_sine_calc(max_elements, pot_pos)
%MURF_SINE_CALC Do a MuRF DAC volt curve for pot pos from 0 to 10

    start_rise = 4.2;
    end_rise = -0.8;
    interval_rise = ((start_rise + abs(end_rise)) / ...
        (max_elements / 2)) * -1;
    start_fall = 4.7;
    end_fall = -0.705;
    interval_fall = ((start_fall + abs(end_fall)) / ...
        (max_elements / 2)) * -1;
    inc_rise = 35;
    inc_fall = 28;
    max_pot_value = 10;
    max_pot_pos = max_pot_value / 2.0; % 10/2, half of the curve!
    
    org_pot_pos = pot_pos;
    
    if pot_pos > max_pot_value / 2.0
        pot_pos = max_pot_value - pot_pos;
    end

    createfigure('MuRF Sine Curve');
    subplot(2, 1, 1);
    plot((sin(start_rise:interval_rise:end_rise) + 1) * ...
        inc_rise, 'bo-'); % rise
    hold on;
    plot((sin(start_fall:interval_fall:end_fall) + 1) * ...
        inc_fall, 'ro-'); % fall
    hold off;
    box off;
    xlim([0, (max_elements / 2.0) + 1]);
    enhancefigure('MuRF Sine Curve', 'Timer ticks', 'Volt');
    grid;
    
    %elements_rise = abs((start_rise - end_rise) / interval_rise);
    %elements_fall = abs((start_fall - end_fall) / interval_fall);
    
    % START CODE TO FIND PERCENT_RISE AND PERCENT_FALL
    pot_pos_intervals_rise = ((start_rise + abs(end_rise)) * ...
        pot_pos) / max_pot_pos;
        
    rise_percent_at_pot_pos = (sin(start_rise - ...
        pot_pos_intervals_rise) + 1) * inc_rise;
        
    pot_pos_intervals_fall = ((start_fall + abs(end_fall)) * ...
        pot_pos) / max_pot_pos;

    fall_percent_at_pot_pos = (sin(start_fall - ...
        pot_pos_intervals_fall) + 1) * inc_fall;
    % END CODE TO FIND PERCENT_RISE AND PERCENT_FALL
    
    if org_pot_pos > 5
        fprintf('Rise percent at pot_pos %.2f: %.2f\n', ...
            org_pot_pos, rise_percent_at_pot_pos);
        fprintf('Fall percent at pot_pos %.2f: %.2f\n', ...
            org_pot_pos, fall_percent_at_pot_pos);
        % Send back to caller
        rise_percent = rise_percent_at_pot_pos;
        fall_percent = fall_percent_at_pot_pos;
    else
        fprintf('Rise percent at pot_pos %.2f: %.2f\n', ...
            org_pot_pos, fall_percent_at_pot_pos);
        fprintf('Fall percent at pot_pos %.2f: %.2f\n', ...
            org_pot_pos, rise_percent_at_pot_pos);    
        % Send back to caller
        fall_percent = rise_percent_at_pot_pos;
        rise_percent = fall_percent_at_pot_pos;
    end
    

    the_curve_rise = zeros(1, max_elements);
    the_curve_fall = zeros(1, max_elements);
    curve_pos = 0;
    interval = max_pot_value / max_elements;
    
    % Do the full curve
    for counter = 0:interval:max_pot_value
        if counter > max_pot_value / 2.0
            pot_pos = max_pot_value - counter;
        else
            pot_pos = counter;
        end

        curve_pos = curve_pos + 1;
        
        pot_pos_intervals_rise = ((start_rise + abs(end_rise)) * ...
            pot_pos) / max_pot_pos;
            
        rise_percent_at_pot_pos = (sin(start_rise - ...
            pot_pos_intervals_rise) + 1) * inc_rise;
            
        pot_pos_intervals_fall = ((start_fall + abs(end_fall)) * ...
            pot_pos) / max_pot_pos;

        fall_percent_at_pot_pos = (sin(start_fall - ...
            pot_pos_intervals_fall) + 1) * inc_fall;
        
        the_curve_rise(curve_pos) = rise_percent_at_pot_pos; 
        the_curve_fall(curve_pos) = fall_percent_at_pot_pos; 
    end 
    
    subplot(2, 1, 2);
    plot(the_curve_rise, 'b.-');
    hold on;
    plot(the_curve_fall, 'r.-');
    % Highlight pot pos on curves
    pos = ceil(org_pot_pos * (max_elements / max_pot_value) + 1);
    plot(pos, the_curve_fall(pos), 'ro');
    plot(pos, the_curve_rise(pos), 'bo');
    hold off;
    box off;
    xlim([0, max_elements + 3]);
    enhancefigure('', 'Timer ticks', 'Volt');
    grid;
