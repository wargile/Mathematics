function [rise, fall] = murf_envelope_pow_curve(curve_elements, peak_pos, ...
    rise_or_fall, release_hold)
%MURF_ENVELOPE_POW_CURVE Calculate pot_pos rise and fall pow curve
    
    % Create rise and fall and combine data in plot
    rise = do_pow_curve(curve_elements, peak_pos, ...
        rise_or_fall, release_hold);
    fall = do_pow_curve(curve_elements, peak_pos, 0, 0);
    subplot(1, 2, 2);
    plot([rise.the_curve fall.the_curve], 'm.-');
    grid;
    axis tight;
    ylim([0 5]);
    box off;
    enhancefigure('MuRF Math.Pow Curve, data combined', ...
        'Timer ticks', 'Amplitude')    

function [ret] = do_pow_curve(curve_elements, peak_pos, ...
    rise_or_fall, release_hold)
    
    RISE = 1;
    %FALL = 0;
    
    if rise_or_fall == RISE
        curve_start = 0;
        curve_end = 5;
        change = 1;
    else
        curve_start = 5;
        curve_end = 0;
        change = -1;
    end
    
    interval = abs(curve_start - curve_end) / curve_elements;

    if peak_pos < curve_elements
        if rise_or_fall == RISE
            curve_start = interval * (curve_elements - peak_pos);
        else
            curve_end = interval * (curve_elements - peak_pos);
        end
        
        curve_elements = peak_pos;
    end

    the_curve = zeros(1, curve_elements);
    the_straight_curve = zeros(1, curve_elements);

    curve_pos = 0;
    advance = 0;

    createfigure('MuRF Math.Pow Curve');
    
    subplot(1, 2, 1);
    
    % Create the curved curve...
    for counter = curve_start:(interval * change):curve_end;
        pos_rise = curve_start + (advance * change);
        advance = advance + interval;
            
        if pos_rise > curve_end && rise_or_fall == RISE
            pos_rise = curve_end;
        end
        
        % Add to plot curves
        curve_pos = curve_pos + 1;
        the_curve(curve_pos) = realpow(pos_rise, 2) / ...
            max(curve_start, curve_end);
        the_straight_curve(curve_pos) = pos_rise; 
    end
    
    plot(the_curve, 'bo-');
    hold on;
    plot(the_straight_curve, 'c.-');
    
    if release_hold == 1
        hold off;
    end
    
    axis tight;
    xlimit = get(gca, 'XLim');
    
    if max(xlimit) < curve_elements
        xlim([min(xlimit) + 1, max(xlimit)]);
    end
    
    enhancefigure('MuRF Math.Pow Curve', 'Timer ticks', 'Amplitude')    
    ylim([0 5]);
    box off;
    grid on;
    
    % Return our stuff...
    ret.interval = interval;
    ret.curve_start = curve_start;
    ret.curve_end = curve_end;
    ret.curve_elements = curve_elements;
    ret.peak_pos = peak_pos;
    ret.the_curve = the_curve;
    ret.the_straight_curve = the_straight_curve;
    