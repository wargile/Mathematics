function [updateinterval] = updateinterval (bpm1, bpm2, lin_log)
%UPDATEINTERVAL Calculate interval values.
%   UPDATEINTERVAL(MIN_BPM, MAX_BPM, LIN_LOG) creates a SimpleClock CCP
%   LCD display update interval value curve, showing the change in
%   intervals from MIN_BPM to MAX_BPM.

    MAX_BPM = 6000;
    MIN_BPM = 60;
    LIN_LOG = 1;
    FIGURE_NAME = 'LCD Update Interval';
    
    if nargin == 1
        MAX_BPM = bpm1;
    end

    if nargin > 1
        MIN_BPM = bpm1;
        MAX_BPM = bpm2;
    end

    if nargin == 3
        LIN_LOG = lin_log;
    end
    
    if MAX_BPM <= MIN_BPM || MAX_BPM - MIN_BPM < 1
        error('MAX_BPM must be at least MIN_BPM + 1');
    end
    
    createfigure(FIGURE_NAME);

    bpm_value = MIN_BPM:((MAX_BPM - MIN_BPM) / 100):MAX_BPM;
    
    if LIN_LOG == 1
        updateinterval = ceil((bpm_value / 1000.0).^4);
        % NOTE: function power(x, y) and x.^y are equal
    else
        updateinterval = ceil((bpm_value / 1000.0).* 30);
    end
    
    stairs(bpm_value, updateinterval, 'b-');

    ticks = get(gca, 'XTick');
    ticks(1) = MIN_BPM;
    
    ticks(length(ticks)) = MAX_BPM;
    
    set(gca, 'XTick', ticks);
    
    ticks = get(gca, 'YTick');
    counter = 1;
    
    % Find number of ytick values that are below max(updateinterval)
    while true
        if ticks(counter) < max(updateinterval)
            counter = counter + 1;
        else
            break;
        end
    end
    
    % Dimension our array for number of yticks + 1
    myticks = zeros(1, counter);
    counter = 1;
    
    % Get the ytick values that are below max(updateinterval)
    while ticks(counter) < max(updateinterval)
        myticks(counter) = ticks(counter);
        counter = counter + 1;
    end
    
    % Add ytick value for max(updateinterval) to end of array
    myticks(counter) = max(updateinterval);
    myticks(1) = min(updateinterval);
    
    if max(updateinterval) > 1
        set(gca, 'YTick', myticks);
    end
    
    if mod(MIN_BPM, 1) > 0 || mod(MAX_BPM, 1) > 0
        buf = sprintf('LCD Update Interval - %.2f to %.2f BPM', ...
            MIN_BPM, MAX_BPM);
    else
        buf = sprintf('LCD Update Interval - %d to %d BPM', ...
            MIN_BPM, MAX_BPM);
    end
    
    enhancefigure(buf, 'BPM', 'Interval');
    axis tight;
    box off;
    grid;
