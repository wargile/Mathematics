function murf_calc(max_elements, pot_pos)
%MURF_CALC Create DAC volt curve for MuRF pot pos from 0 to 10

    LEFT = 0;
    MIDDLE = 1;
    RIGHT = 2;
    MAX_POT_POS = 10;
    MIN_POT_POS = 0;
    
    pos = MIDDLE;
    
    if nargin == 0
        max_elements = 100;
        pot_pos = 5;
    end

    if nargin == 1
        pot_pos = 5;
    end

    if pot_pos < MIN_POT_POS
        pot_pos = MIN_POT_POS;
    end
    
    if pot_pos > MAX_POT_POS
        pot_pos = MAX_POT_POS;
    end
    
    if pot_pos <= 5
        [elements_rise, elements_fall] = get_pot_pos_value(pot_pos);
    else
        [elements_fall, elements_rise] = get_pot_pos_value(10 - pot_pos);
    end

    if pot_pos <= 5
        p1 = get_pot_pos_value(pot_pos - 0.001);
        p2 = get_pot_pos_value(pot_pos);
    else
        p2 = get_pot_pos_value(10 - pot_pos - 0.001);
        p1 = get_pot_pos_value(10 - pot_pos);
    end

    if p1 < p2 && pot_pos <= 5
        pos = LEFT;
    elseif (p1 > p2 && pot_pos <= 5) || ((p1 < p2 && pot_pos > 5))
        pos = MIDDLE;
    elseif p1 > p2 && pot_pos > 5
        pos = RIGHT;
    end

    CreatePlot(max_elements, elements_rise, elements_fall, pot_pos, pos);

function [the_curve] = CreatePlot(max_elements, elements_rise, elements_fall, pot_pos, pos)
    LEFT = 0;
    MIDDLE = 1;
    RIGHT = 2;

    ref_voltage = 5;
    %max_elements = 50;
    % Calculate elements_rise and elements_fall for values other than 100
    elements_rise = (elements_rise * max_elements) / 100;
    elements_fall = (elements_fall * max_elements) / 100;

    takeaway_elements_rise = 0;
    init_rise = 0;
    start_pos = 1;

    if (elements_rise + elements_fall) > max_elements
        takeaway_elements_rise = floor((max_elements - ...
            (elements_rise + elements_fall)) / 2.0);
    end

    if takeaway_elements_rise < 0
        takeaway_elements_rise = abs(takeaway_elements_rise);
    else
        takeaway_elements_rise = 0;
    end

    if (elements_rise + elements_fall) > max_elements
        init_rise = (ref_voltage / elements_rise) * takeaway_elements_rise;
    end

    elements_rise = elements_rise - takeaway_elements_rise;

    change_interval_rise = (ref_voltage - init_rise) / elements_rise;
    
    if takeaway_elements_rise > 0
        change_interval_fall = (ref_voltage - init_rise) / ...
            (max_elements - (start_pos + elements_rise));
    else
        change_interval_fall = ref_voltage / elements_fall;
    end

    the_curve = zeros(1, max_elements + 1);
    % +1 here just to ensure 0 value at end of curve, not needed for PIC DAC
    % Sending PIC DAC values should ALWAYS start and end with zero value
    change = init_rise;
    
    % Transitions: LEFT: 2.82 RIGHT: 7.18
    
    if (elements_rise + elements_fall) < max_elements
        if pos == LEFT
            start_pos = 1;
        elseif pos == RIGHT    
            start_pos = round(max_elements - (elements_rise + elements_fall));
        else
            start_pos = round((max_elements / 2) - elements_rise);
        end
    end

    if start_pos < 1
        start_pos = 1;
    end

    fprintf('Start: %f ElementsRise: %f ElementsFall: %f Pos: %d\n', ...
        start_pos, elements_rise, elements_fall, pos);
    
    curve_rising = 1;

    for counter = start_pos:max_elements
        %fprintf('Start pos: %d Change: %f\n', start_pos, change);

        if change > ref_voltage
            change = ref_voltage;
        end

        if change >= 0
            the_curve(counter) = change;
        end

        %if change <= ref_voltage
        if counter < (elements_rise + start_pos)
            curve_rising = 1;
            change = change + change_interval_rise;
        else
            if curve_rising == 1
                curve_rising = 0;
                %change = change - change_interval_fall;
            end

            change = change - change_interval_fall;
        end
    end

    createfigure('MuRF DAC Volt Curve');
    stairs(the_curve, 'b');
    hold on;
    plot(the_curve, 'co-');
    hold off;
    buf = sprintf('MuRF volt curve for %d timer ticks and pot position %.2f', ...
        max_elements, pot_pos);
    enhancefigure(buf, 'Timer Ticks', 'Volt');
    ylim([-0.3 ref_voltage + 0.2]);
    xticks = get(gca, 'XTick');
    
    if xticks(numel(xticks)) > max_elements
        xticks(numel(xticks)) = max_elements;
        set(gca, 'XTick', xticks);
    end
    
    xlim([0 xticks(numel(xticks)) + 2]);
    grid minor;

function [rise_percent, fall_percent] = get_pot_pos_value(pot_pos)
    start1 = 5;
    start2 = 4.7;
    dip1 = 1.7;
    dip2 = 1.65;
    inc_factor1 = 12;
    inc_factor2 = 13.5;
    max_pot_pos = 10;
   
    interval = (start1 - dip1) / (max_pot_pos / 2.0);
    interval2 = (start2 - dip2) / (max_pot_pos / 2.0);
    
    % TODO: Is this a better curve? Possible to test both cos and sin?
    %plot(sin(4.7:-0.1:-0.2))
    %plot((sin(4.7:-0.1:-0.2) + 1) * 25)
    %plot((sin(3.8:-0.085:-0.5) + 1) * 35, 'bo-')
    %plot((sin(4.7:-0.1:-0.3) + 1) * 28, 'ro-')
    
    if pot_pos <= 5
        rise_percent = 1 - cos(start1 - (interval * pot_pos)) * 3.5;
    else
        rise_percent = 1 - cos(dip1 + (interval * pot_pos)) * 3.5;
    end

    if pot_pos <= 5 
        fall_percent = 1 - cos(start2 - (interval2 * pot_pos)) * 3.5;
    else
        fall_percent = 1 - cos(dip2 + (interval2 * pot_pos)) * 3.5;
    end

    rise_percent = rise_percent * inc_factor1;
    fall_percent = fall_percent * inc_factor2;
    
    if rise_percent < 0
        rise_percent = 0;
    end
    
    if fall_percent < 0
        fall_percent = 0;
    end
    
    %fprintf('Rise: %f, Fall %f\n', rise_percent, fall_percent);
