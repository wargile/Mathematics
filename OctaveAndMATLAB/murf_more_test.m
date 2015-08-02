function murf_more_test(current_pot_pos)

max_pot_pos = 10;

if current_pot_pos < 4 || current_pot_pos > 6 
    %p_pot_pos_data_rise = ((5 - 1 - (5 - current_pot_pos)) / 4) * 5;
    p_pot_pos_data_rise = current_pot_pos;
    rise_percent = (50 - (((5 - p_pot_pos_data_rise) * 50) / ...
                      (max_pot_pos / 2)));

    %p_pot_pos_data_fall = ((4.5 - 0 - (4.5 - current_pot_pos)) / 4) * 5;
    p_pot_pos_data_fall = current_pot_pos + 1;
    fall_percent = (50 - (((5 - p_pot_pos_data_fall) * 50) / ...
                      (max_pot_pos / 2)));
end

if rise_percent > 50
    rise_percent = 100 - rise_percent;
end

if fall_percent > 50
    fall_percent = 100 - fall_percent;
end

rise_percent
fall_percent
