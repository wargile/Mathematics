function [percent_curve_rise, percent_curve_fall] = ...
    murf_get_pot_pos_value()

    max_pot_pos = 10;
    
    percent_curve_rise = zeros(1, max_pot_pos);
    percent_curve_fall = zeros(1, max_pot_pos);
    
    for counter = 0:max_pot_pos
        if counter <= (max_pot_pos / 2)
            [r, f] = get_pot_pos_value(counter);
        else
            [r, f] = get_pot_pos_value(max_pot_pos - counter);
        end
        
        percent_curve_rise(counter + 1) = r;
        percent_curve_fall(counter + 1) = f;

    end
    
    plot(percent_curve_rise);
    hold on;
    plot(percent_curve_fall);
    hold off;
    grid;
    
function [rise_percent, fall_percent] = get_pot_pos_value(pot_pos)
    start1 = 5;
    start2 = 4.7;
    dip1 = 1.7; % 2.2
    dip2 = 1.65; % 2.2
    inc_factor1 = 12;
    inc_factor2 = 13.5;
    max_elements = 10;
   
    interval = (start1 - dip1) / (max_elements / 2.0);
    interval2 = (start2 - dip2) / (max_elements / 2.0);
    
    if pot_pos <= 5
        rise_percent = 1 - cos(start1 - (interval * pot_pos)) * 3.5 %4;
    else
        rise_percent = 1 - cos(dip1 + (interval * pot_pos)) * 3.5 %4;
    end

    if pot_pos <= 5 
        fall_percent = 1 - cos(start2 - (interval2 * pot_pos)) * 3.5; %4
    else
        fall_percent = 1 - cos(dip2 + (interval2 * pot_pos)) * 3.5; %4;
    end

    rise_percent = rise_percent * inc_factor1;
    fall_percent = fall_percent * inc_factor2;
    
    if rise_percent < 0
        rise_percent = 0;
    end
    
    if fall_percent < 0
        fall_percent = 0;
    end
    
    fprintf('Rise: %f, Fall %f\n', rise_percent, fall_percent);