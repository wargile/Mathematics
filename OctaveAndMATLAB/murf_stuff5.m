function murf_stuff5(resolution = 100, pot_pos = 4.5, curve_peak = 3.5, ...
                     curve_multiplier_rise = 3.5, curve_multiplier_fall ...
                     = 4.5)

    % Define some constants
    volt_ref = 5.0;
    max_pot_value = 10;
    curve_dip = 5.5

    createfigure('MurF Stuff #5');
    clf;
    subplot(3, 1, 1);

    if curve_dip == curve_multiplier_rise
        warning('Curve dip and curve multiplier rise can not be equal');
        curve_multiplier_rise = curve_multiplier_rise + 0.0000000001
        % Avoid DIV/0!
    end
    
    if curve_dip == curve_multiplier_fall
        warning('Curve dip and curve multiplier fall can not be equal');
        curve_multiplier_fall = curve_multiplier_fall + 0.0000000001
        % Avoid DIV/0!
    end

    %% Get rise and fall curve to meet at same dip pos:

    hold on;
    peak_pos = curve_peak % From input param
    curve_peak_rise = curve_multiplier_rise  % From input param
    curve_peak_fall = curve_multiplier_fall  % From input param
    elements = ceil(peak_pos * (resolution / max_pot_value))
    % IMPORTANT! ceil above
    
    % Rise curve before curve peak
    curve_peak = curve_peak_rise
    curve_end = curve_peak
    interval = sqrt(curve_end) / elements
    plot(realpow(0:interval:sqrt(curve_end), 2), 'r.-');
    
    % Fall curve before curve peak
    curve_peak = curve_peak_fall
    curve_end = curve_peak
    interval = sqrt(curve_end) / elements
    plot(realpow(0:interval:sqrt(curve_end), 2), 'b.-');
    
    elements = ceil(((max_pot_value / 2.0) - ...
                     peak_pos) * (resolution / max_pot_value))
    % IMPORTANT! ceil above
    
    % Rise curve after curve peak
    curve_peak = curve_peak_rise
    curve_end = curve_dip
    interval = (sqrt(curve_peak) - sqrt(curve_end)) / elements
    plot(ceil(peak_pos * (resolution / max_pot_value) + 1): ...
         ceil(peak_pos * (resolution / max_pot_value) + elements + 1), ...
         realpow(sqrt(curve_peak):-interval:sqrt(curve_end), 2), 'r.-');
    
    % Fall curve after curve peak
    curve_peak = curve_peak_fall
    curve_end = curve_dip
    interval = (sqrt(curve_peak) - sqrt(curve_end)) / elements
    plot(ceil(peak_pos * (resolution / max_pot_value) + 1): ...
         ceil(peak_pos * (resolution / max_pot_value) + elements + 1), ...
         realpow(sqrt(curve_peak):-interval:sqrt(curve_end), 2), 'b.-');
    
    
    grid;
    xlim([0, (resolution / 2.0) + 2]);
    box off;
    
    % Get the rise and fall percent
    [rise_percent, fall_percent] = ...
        get_rise_fall_percents(resolution, pot_pos, peak_pos, curve_multiplier_rise, ...
                                           curve_multiplier_fall, curve_dip)
    % Plot the rise and fall percents in curve
    hold on;
    plot(ceil(pot_pos * (resolution / max_pot_value)) + 1, rise_percent, 'bo');
    plot(ceil(pot_pos * (resolution / max_pot_value)) + 1, fall_percent, 'ro');
    %hold off;
    
    % Plot the rise and fall curve for pot_pos'es through the resolution
    subplot(3, 1, 2);
    
    divisor = 1.0; % Do 2.0 for first curve half
    rise_curve = zeros(1, ceil(resolution / divisor));
    fall_curve = zeros(1, ceil(resolution / divisor));
    pos = 0;
    
    % This is the code for the PIC timer tick interrupt counter range
    for counter = 0:(max_pot_value / resolution):(max_pot_value / divisor)
        pos = pos + 1;
        [rise_percent, fall_percent] = ...
            get_rise_fall_percents(resolution, ...
                                   counter, peak_pos, curve_multiplier_rise, ...
                                   curve_multiplier_fall, curve_dip);
        rise_curve(pos) = rise_percent;
        fall_curve(pos) = fall_percent;
    end

    plot(rise_curve, 'b.-');
    hold on;
    plot(fall_curve, 'r.-');

    % Add the rise/fall at pot_pos
    [rise_percent, fall_percent] = ...
        get_rise_fall_percents(resolution, ...
                               pot_pos, ...
                               peak_pos, curve_multiplier_rise, ...
                               curve_multiplier_fall, curve_dip);
    
    plot(pot_pos * (resolution / max_pot_value) + 1, rise_percent, 'bo');
    plot(pot_pos * (resolution / max_pot_value) + 1, fall_percent, 'ro');
    
    % Add the rise/fall at peak_pos
    [rise_percent, fall_percent] = ...
        get_rise_fall_percents(resolution, ...
                               peak_pos, ...
                               peak_pos, curve_multiplier_rise, ...
                               curve_multiplier_fall, curve_dip);
    
    plot(peak_pos * (resolution / max_pot_value) + 1, rise_percent, 'c.');
    plot(peak_pos * (resolution / max_pot_value) + 1, fall_percent, 'c.');
    
    ylim([0, max(rise_percent, fall_percent) + 2]);
    xlim([0, resolution / divisor + 2]);
    grid;
    
  
    enhancefigure('MuRF Stuff #5', 'Resolution ticks', ['Rise and ' ...
                        'fall percents']);

    % TEST: Get the peak pos (curve break) in resolution at pot_pos
    pot_pos_in_res = zeros(1, max_pot_value);
    
    for counter = 0:max_pot_value / 2.0
        pot_pos_in_res(counter + 1) = ...
            get_peak_pos_in_resolution(counter, resolution, ...
                                               max_pot_value);
    end
    
    for counter = 1:max_pot_value / 2.0
        pot_pos_in_res((max_pot_value / 2.0) + counter + 1) = ...
            get_peak_pos_in_resolution((max_pot_value / 2.0) - counter, resolution, ...
                                               max_pot_value);
    end
    
    subplot(3, 1, 3);
    %plot(pot_pos_in_res, 'bo-');
    %set(gca, 'xticklabel', [0:max_pot_value]);
    grid;
    
    % TEST: Get cutoff volt and plot
    get_cutoff_volt(resolution, pot_pos);
end


%% Find rise and fall percents at pot pos
function [percent_rise, percent_fall] = ...
        get_rise_fall_percents(resolution, pot_pos, peak_pos, curve_peak_rise, ...
                                           curve_peak_fall, curve_dip)
    
    max_pot_value = 10;
    
    % Enable for whole pot_pos range
    if (pot_pos > max_pot_value / 2.0)
        pot_pos = max_pot_value - pot_pos;
    end
    
    % Get rise percent
    if (pot_pos <= peak_pos)
        % TODO: Get elements and interval once!
        elements = (peak_pos * (resolution / max_pot_value));
        interval = sqrt(curve_peak_rise) / elements;
        percent_rise = realpow((pot_pos * (resolution / max_pot_value)) * interval, 2);
    else
        % TODO: Get elements and interval once!
        elements = (((max_pot_value / 2.0) - ...
                         peak_pos) * (resolution / max_pot_value));
        interval = (sqrt(curve_peak_rise) - sqrt(curve_dip)) / elements;
        percent_rise = realpow(sqrt(curve_peak_rise) - ...
                               (interval * ((pot_pos - peak_pos) * ...
                                            (resolution / max_pot_value))), 2);
    end

    % Get fall percent
    if (pot_pos <= peak_pos)
        % TODO: Get elements and interval once!
        elements = (peak_pos * (resolution / max_pot_value));
        interval = sqrt(curve_peak_fall) / elements;
        percent_fall = realpow((pot_pos * (resolution / max_pot_value)) * interval, 2);
    else
        % TODO: Get elements and interval once!
        elements = (((max_pot_value / 2.0) - ...
                         peak_pos) * (resolution / max_pot_value));
        interval = (sqrt(curve_peak_fall) - sqrt(curve_dip)) / elements;
        percent_fall = realpow(sqrt(curve_peak_fall) - ...
                               (interval * ((pot_pos - peak_pos) * ...
                                            (resolution / max_pot_value))), 2);
    end
end


%% Find pot_pos in resolution - not needed?
function [peak_pos_in_resolution] = ...
        get_peak_pos_in_resolution(pot_pos, resolution, max_pot_value)
    peak_pos_in_resolution = (realpow(pot_pos, 2) / (max_pot_value / 2.0)) * ...
        (resolution / max_pot_value);
end


%% TEST: Get cutoff volt and other stuff
function [cutoff_volt] =  get_cutoff_volt(resolution, pot_pos)
% Testings....
    max_pot_value = 10
    volt_ref = 5.0
    percent_rise = 32.0
    
    % Enable for whole pot_pos range
    if (pot_pos > max_pot_value / 2.0)
        pot_pos = (max_pot_value / 2.0) - (pot_pos - (max_pot_value / 2.0));
    end
    
    percent_rise_in_res = (percent_rise * resolution) / 100.0
    volt_per_step = sqrt(volt_ref) / percent_rise_in_res
    %pot_pos * resolution / max_pot_value
    
    plot(realpow(0:volt_per_step:sqrt(volt_ref), 2), 'mo-');
    
    if (percent_rise_in_res > ((pot_pos * resolution) / max_pot_value))
        cutoff_volt = abs((pot_pos * resolution / max_pot_value) - ...
            percent_rise_in_res) * volt_per_step
    else
        cutoff_volt = 0
    end
    
    hold on;
    plot(realpow(cutoff_volt:volt_per_step:sqrt(volt_ref), 2), 'go-');
    grid;
end
