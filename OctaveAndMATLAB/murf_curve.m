function [curve_rise, curve_fall] = murf_curve(p_max_elements, p_pot_pos)
%MURF_CURVE creates the rise and fall percent values for the 
%   pot_pos interval from 0 to 10.

    createfigure('MuRF rise and fall percents');

    start1 = 5;
    start2 = 4.70;
    dip = 1.7;

    if nargin == 0
        max_elements = 10;
        p_max_elements = 10;
        p_pot_pos = 5;
    end

    if nargin == 1
        max_elements = p_max_elements;
        p_pot_pos = 5;
    end

    if nargin == 2
        max_elements = p_max_elements;
    end

    interval = (start1 - dip) / (max_elements / 2.0);
    %interval2 = (start2 - 2.2) / (max_elements / 2.0);
    interval2 = (start2 - dip) / (max_elements / 2.0);

    a = 1 - cos(start1:-interval:dip) * 4;
    b = 1 - cos((dip + interval):interval:start1) * 4;
    %b = 1 - cos(dip:interval:start1) * 4;

    c = 1 - cos(start2:-interval2:dip) * 4;
    d = 1 - cos((dip + interval2):interval2:start2) * 4;
    %d = 1 - cos(dip:interval2:start2) * 4;

    inc_factor1 = 12;
    inc_factor2 = 13;

    subplot(2, 3, 1);

    %plot([c.*inc_factor1], 'ro-');
    %plot([d.*inc_factor1], 'mo-');
    plot([a.*inc_factor1 b.*inc_factor1], 'ro-');
    %plot([c d], 'ro-');
    hold on;
    %plot([a.*inc_factor2], 'bo-');
    %plot([b.*inc_factor2], 'go-');
    plot([c.*inc_factor2 d.*inc_factor2], 'b*-');
    %plot([a b], 'bo-');
    hold off;
    box off;
    axis tight;

    %enhancefigure('MuRF envelope curve', '', '');

    xticks = ones(1, 11);

    for counter = 2:11
        xticks(counter) = xticks(counter - 1) + (max_elements / 10);
    end

    set(gca, 'XTick', xticks);
    %set(gca, 'YTick', [0 10 20 30 40 50 60 70]);
    grid;

    % START Find rise/fall percents for pot pos 1-10
    curve_rise = zeros(1, 6);
    curve_fall = zeros(1, 6);
    curve_change = zeros(1, 6);
    counter = 1;

    for pot_pos = 0:5
        [curve1, curve2] = get_pot_pos_value(pot_pos);
        [curve3, curve4] = get_pot_pos_value(pot_pos - 0.01);

        if curve1 < 0
            curve1 = 0;
        end
        
        if curve2 < 0
            curve2 = 0;
        end

        curve_rise(counter) = curve1;
        curve_fall(counter) = curve2;
        
        if curve3 < curve1 && curve4 < curve2
            curve_change(counter) = 5;
        else
            curve_change(counter) = -5;
        end
        
        counter = counter + 1;
        fprintf('Pot pos values: %f %f\n', curve1, curve2);
    end

    fprintf('\n');
    subplot(2, 3, 2);
    plot(curve_rise, 'b*-');
    hold on;
    plot(curve_fall, 'ro-');
    bar(curve_change, 'g');
    hold off;
    grid;
    box off;
    axis tight;

    counter = 1;

    for pot_pos = 5:10
        [curve1, curve2] = get_pot_pos_value(10 - pot_pos);
        [curve3, curve4] = get_pot_pos_value(10 - pot_pos - 0.01);
        
        if curve1 < 0
            curve1 = 0;
        end
        
        if curve2 < 0
            curve2 = 0;
        end

        curve_rise(counter) = curve2; % NOTE! Opposite values for 5-10
        curve_fall(counter) = curve1; % NOTE! Opposite values for 5-10
        
        if curve3 > curve1 && curve4 > curve2
            curve_change(counter) = 5;
        else
            curve_change(counter) = -5;
        end
        
        counter = counter + 1;
        fprintf('Pot pos values: %f %f\n', curve1, curve2);
    end

    subplot(2, 3, 3);
    plot(curve_rise, 'b*-');
    hold on;
    plot(curve_fall, 'ro-');
    bar(curve_change, 'g');
    hold off;
    grid;
    box off;
    axis tight;
    % END Find rise/fall percents for pot pos 1-10


    % TEST START: Create DAC curve
    if p_pot_pos <= 5
        [curve1, curve2] = get_pot_pos_value(p_pot_pos);
    else
        [curve2, curve1] = get_pot_pos_value(10 - p_pot_pos);
    end
    
    if curve1 < 0
        curve1 = 0;
    end
    
    if curve2 < 0
        curve2 = 0;
    end

    fprintf('DAC: Pot_pos: %f, curve1: %f, curve2: %f\n', ...
        p_pot_pos, curve1, curve2);
        
    create_DAC_curve(p_pot_pos, curve1, curve2);
    % TEST END: Create DAC curve
    
end

function [curve1, curve2] = get_pot_pos_value(pot_pos)
    start1 = 5;
    start2 = 4.7;
    dip = 1.7; % 2.2
    inc_factor1 = 12;
    inc_factor2 = 13.5;
    max_elements = 10;

    interval = (start1 - dip) / (max_elements / 2.0);
    interval2 = (start2 - dip) / (max_elements / 2.0);
    
    if pot_pos <= 5
        curve1 = 1 - cos(start1 - (interval * pot_pos)) * 4;
    else
        curve1 = 1 - cos(dip + (interval * pot_pos)) * 4;
    end

    if pot_pos <= 5 
        curve2 = 1 - cos(start2 - (interval2 * pot_pos)) * 4;
    else
        curve2 = 1 - cos(dip + (interval2 * pot_pos)) * 4;
    end

    curve1 = curve1 * inc_factor1;
    curve2 = curve2 * inc_factor2;
end

function create_DAC_curve(p_pot_pos, percent_rise, percent_fall)
    ref_voltage = 5;
    percent_max_elements = 100;
    percent_start = percent_rise - (percent_max_elements / 2.0);
    percent_end = percent_fall - (percent_max_elements / 2.0);
    
    if percent_start < 0
        percent_start = 0;
    end

    if percent_end < 0
        percent_end = 0;
    end
    
    max_elements_rise = round((percent_max_elements * ...
        percent_rise) / 100.0);
    max_elements_fall = round((percent_max_elements * ...
        percent_fall) / 100.0);
    fprintf('Elements rise: %d, Elements fall: %d PS: %f PE: %f\n', ...
        max_elements_rise, max_elements_fall, percent_start, percent_end);
        
    if max_elements_rise < 1
        max_elements_rise = 1;
    end

    if max_elements_fall < 1
        max_elements_fall = 1;
    end

    %if max_elements_rise + max_elements_fall > percent_max_elements
    %    max_elements_fall = percent_max_elements - max_elements_rise;
    %end

    rise_interval = ref_voltage / max_elements_rise;
    fall_interval = ref_voltage / max_elements_fall;

    % ------------------------------------------------------------------
    % Find start pos
    curve_data = zeros(1, percent_max_elements + 1);
    counter = 0;
    
    if percent_start == 0
        change = 0;
        curve_data(1) = 0; % NOTE: Just to create a nice curve...
    else
        change = percent_start * rise_interval;
    end

    if p_pot_pos > 5
        start_pos = percent_max_elements - (max_elements_rise + ...
            max_elements_fall);

        if start_pos < 1
            start_pos = 2;
        end
    else
        start_pos = 2;
    end
    %start_pos = abs(percent_max_elements - ...
    %(max_elements_rise + max_elements_fall));

    fprintf('Start pos: %.2f Rise_int: %.2f Fall_int: %.2f\n', ...
        start_pos, rise_interval, fall_interval);

    % ------------------------------------------------------------
    % START Do curve ascent (Call function here for each timer event)
    % DAC values is > 0 when counter >= start_pos 
    for counter = start_pos:(start_pos + max_elements_rise)
        change = change + rise_interval;
        
        if change > ref_voltage
            change = ref_voltage;
        end
        
        curve_data(counter) = change;
    end

    temp_counter = counter;
    fprintf('Temp counter: %.2f\n', temp_counter);

    % Do curve descent
    for counter = temp_counter:(max_elements_fall + temp_counter - 1)
        change = change - fall_interval;
        
        if change > 0
            curve_data(counter) = change;
        else
            curve_data(counter) = 0;
        end
    end
    % END --------------------------------------------------------------

    % Display rise/fall curve
    subplot(2, 3, 4);
    plot(curve_data, 'co-');
    hold on;
    stairs(curve_data, 'b');
    hold off;
    box off;    
    grid;
    %xlim([-1, percent_max_elements + 2]);
    ylim([-0.5, ref_voltage + 0.5]);
    set(gca, 'YTick', 0:5);
    % FOR DEBUG END ----------------------------------------------------
    
    % TEST: Display start/end percent
    subplot(2, 3, 5);
    plot([(ref_voltage * percent_start) / 100, ref_voltage, ...
        (ref_voltage * percent_end) / 100], 'bo-');
    set(gca, 'ylim', [0 5]);
    box off;
    grid;
    
    murf_calc(percent_max_elements, p_pot_pos, max_elements_rise, ...
        max_elements_fall, rise_interval, fall_interval);    
end

function murf_calc(max_elements, pot_pos, elements_rise, ...
    elements_fall, rise_interval, fall_interval)
    %ref_voltage = 5;
    
    if (elements_rise + elements_fall) <= max_elements
        if pot_pos <= 5
            element_at_peak = elements_rise;
            start_pos = 0;
            end_pos = element_at_peak + elements_fall;
        else
            element_at_peak = (max_elements / 2) + ...
                ((max_elements / 2) - elements_fall);
            start_pos = element_at_peak - elements_rise;
            end_pos = max_elements;
        end
    else
        element_at_peak = -1; %pot_pos * (max_elements / 10);
        start_pos = (max_elements / 2) - elements_rise;
        end_pos = (max_elements / 2) + elements_fall;
    end

    
    if start_pos < 0
        change = abs(start_pos) * rise_interval;
    else
        change = 0;
    end

    fprintf('\nChange: %f\n', change);
    fprintf('Pot pos: %f\n', pot_pos);
    fprintf('Start pos: %d\n', start_pos);
    fprintf('End pos: %d\n', end_pos);
    fprintf('Element at peak: %d\n', element_at_peak);
    fprintf('Rise interval: %f\n', rise_interval);
    fprintf('Fall interval: %f\n', fall_interval);
    
    subplot(2, 3, 6);
    bar([start_pos end_pos], 'c');
    set(gca, 'YTick', [start_pos, end_pos]);
end