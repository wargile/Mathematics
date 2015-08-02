function [ret] = murf_stuff6(resolution_in = 100.0, pot_pos_in = 2.222, ...
                             peak_pos_in = 3.5, percent_curve_rise_in = 55, ...
                             percent_curve_fall_in = 75)

    % clear all % IMPORTANT before call
    
    % Define some global constants
    global volt_ref = 5.0;
    global max_pot_value = 10;
    global curve_dip = 5.5; % TODO: Calculate?
    global resolution = resolution_in;
    global pot_pos = pot_pos_in;
    global peak_pos = peak_pos_in;
    global percent_curve_rise = (percent_curve_rise_in * resolution) / 100.0;
    global percent_curve_fall = (percent_curve_fall_in * resolution) / 100.0;
    
    %pot_pos
    %resolution
    %percent_curve_rise
    %percent_curve_fall

    % TODO: Need to get percent_rise and fall at pot_pos first!!
    
    % Test functions
    [ret.percent_rise_at_pot_pos, ret.percent_fall_at_pot_pos, ...
     ret.cutoff_volt, ret.volt_pr_step_rise, ...
     ret.volt_pr_step_fall, ret.start_pos] = get_curve_info();
    
    the_array = zeros(1, resolution + 1);
    
    for counter = 0:resolution
        if (pot_pos > max_pot_value / 2.0)
            volt = get_volt_value(resolution - counter);
            volt
        else
            volt = get_volt_value(counter);
            volt
        end
        
        the_array(counter + 1) = volt;
    end
    
    plot(the_array, 'bo-');
end

%% Find various curve info, check only once
function [percent_rise_at_pot_pos, percent_fall_at_pot_pos, cutoff_volt, ...
          volt_pr_step_rise, volt_pr_step_fall, start_pos] = get_curve_info()
    
    global volt_ref;
    global max_pot_value;
    global curve_dip;
    global resolution;
    global pot_pos;
    global peak_pos;
    global cutoff_volt;
    global percent_curve_rise;
    global percent_curve_fall;
    global volt_pr_step_rise;
    global volt_pr_step_fall;
    global percent_fall_at_pot_pos;
    global percent_rise_at_pot_pos;
    
    %pot_pos
    %resolution
    
    % Enable for whole pot_pos range
    if (pot_pos > max_pot_value / 2.0)
        pot_pos = (max_pot_value / 2.0) - (pot_pos - (max_pot_value / 2.0));
    end
    
    pot_pos_in_resolution = pot_pos * (resolution / max_pot_value);
    
    % Get rise percent
    if (pot_pos <= peak_pos)
        elements_rise = (peak_pos * (resolution / max_pot_value));
        interval_rise = sqrt(percent_curve_rise) / elements_rise;
        percent_rise_at_pot_pos = realpow(pot_pos_in_resolution * interval_rise, 2);
    else
        elements_rise = (((max_pot_value / 2.0) - ...
                     peak_pos) * (resolution / max_pot_value));
        interval_rise = (sqrt(percent_curve_rise) - sqrt(curve_dip)) / elements_rise;
        percent_rise_at_pot_pos = realpow(sqrt(percent_curve_rise) - ...
                                          (interval_rise * ((pot_pos - peak_pos) * ...
                                                       (resolution / max_pot_value))), 2);
    end

    % Get fall percent
    if (pot_pos <= peak_pos)
        elements_fall = (peak_pos * (resolution / max_pot_value));
        interval_fall = sqrt(percent_curve_fall) / elements_fall;
        percent_fall_at_pot_pos = realpow(pot_pos_in_resolution * interval_fall, 2);
    else
        elements_fall = (((max_pot_value / 2.0) - ...
                     peak_pos) * (resolution / max_pot_value));
        interval_fall = (sqrt(percent_curve_fall) - sqrt(curve_dip)) / elements_fall;
        percent_fall_at_pot_pos = realpow(sqrt(percent_curve_fall) - ...
                                          (interval_fall * ((pot_pos - peak_pos) * ...
                                                       (resolution / max_pot_value))), 2);
    end
    
    volt_pr_step_fall = (volt_ref / percent_fall_at_pot_pos);
    
    if (volt_pr_step_fall > volt_ref)
        volt_pr_step_fall = volt_ref;
    end
 
    % Get the peak pos in resolution (correct placement??)
    peak_pos = (realpow(pot_pos, 2) / (max_pot_value / 2.0)) * (resolution / max_pot_value);
  
    if (resolution - peak_pos - percent_fall_at_pot_pos < 0)
        cutoff_steps = abs(resolution + 0 - peak_pos - percent_fall_at_pot_pos); % NOTE: +0 changed from +1
        cutoff_volt = (cutoff_steps + 0) * volt_pr_step_fall; % NOTE: +0 changed from +1
    else
        cutoff_volt = 0;
    end
    
    if (cutoff_volt > 0)
        start_pos = 0;
    else
        start_pos = peak_pos - percent_rise_at_pot_pos;
        
        if (start_pos < 0)
            start_pos = 0;
        end
    end
    
    if (percent_rise_at_pot_pos == 0)
        volt_pr_step_rise = volt_ref; % (volt_ref - cutoff) / 1.0F;
        peak_pos = 0.0001; % 1.0F; // TODO: Optimal solution for div/0 issue?
    else
        volt_pr_step_rise = (volt_ref - cutoff_volt) / (peak_pos - start_pos);
    end
    
    if (volt_pr_step_rise > volt_ref)
        volt_pr_step_rise = volt_ref;
    end

    %hold on;
    %plot(realpow(cutoff_volt:volt_per_step:sqrt(volt_ref), 2), 'go-');
    %grid;
end

function [volt] = get_volt_value(resolution_pos)
    global volt_ref;
    global max_pot_value;
    global curve_dip;
    global resolution;
    global pot_pos;
    global peak_pos;
    global start_pos;
    global percent_curve_rise;
    global percent_curve_fall;
    global cutoff_volt;
    global volt_pr_step_rise;
    global volt_pr_step_fall;
    global percent_fall_at_pot_pos;
    global percent_rise_at_pot_pos;

    if (resolution_pos < start_pos)
        volt = 0;
    else
        if (resolution_pos < peak_pos)
            volt = realpow(cutoff_volt + (volt_pr_step_rise * (resolution_pos - start_pos)), 2) / volt_ref;
        else
            if (resolution_pos <= peak_pos + percent_fall_at_pot_pos)
                volt = realpow(volt_ref - (volt_pr_step_fall * (resolution_pos - peak_pos)), 2) / volt_ref;
            else
                volt = 0;
            end
            
            % Ensure DAC volt = volt_ref at peak pos
            if (resolution_pos == round(peak_pos) && volt < volt_ref) % changed from ceil
                volt = volt_ref;
            end
        end
    end
end
