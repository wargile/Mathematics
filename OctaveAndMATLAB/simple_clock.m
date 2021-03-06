function [trig_signals] = simple_clock()
%SIMPLE_CLOCK Create a trigger chart
%   See also: accelerator

%   Copyright (C) Terje B. 2011

    MAX_INTERVALS = 5;
    VAL = 2; % NOTE: Minimum value = 2
    MAX_STEPS = VAL * 16;
    FIG_NAME = 'Simple Clock';
    
    trig_signals = zeros(MAX_INTERVALS, MAX_STEPS);
    steps = [VAL, VAL * 2, VAL * 4, VAL * 8, VAL * 16];
    step_values = [VAL * 32, VAL * 16, VAL * 8, VAL * 4, VAL * 2];
    % step_colors = {'b', 'r', 'g', 'm', 'c'};
    my_colors = [0.57, 0.85, 0.92; ...
        0.67, 0.75, 0.85; ...
        0.77, 0.85, 0.75; ...
        0.87, 0.75, 0.65; ...
        0.97, 0.85, 0.55];
    
    for counter = 1:MAX_STEPS
        for p = 1:MAX_INTERVALS
            if mod(counter - 1, (steps(p) / 2)) == 0 % Trig off
                trig_signals(p, counter) = step_values(p) * -1;
            end
			
            if mod(counter - 1, steps(p)) == 0 % Trig on
                trig_signals(p, counter) = step_values(p);
            end
        end
    end

    createfigure(FIG_NAME, false);
	%cm_old = colormap; % Save current colormap
    %cm = colormap(jet); % IMPORTANT, must be AFTER createfigure!

    hold on;
        
    for p = 1:MAX_INTERVALS
        h = bar(trig_signals(p,:));
        %h = stem(trig_signals(p,:), '-');
        %set(h, 'facecolor', step_colors{p});
        %set(h, 'facecolor', cm((p * 7) + 12, 1:3));
        set(h, 'facecolor', my_colors(p, 1:3));
        %set(h(1), 'basevalue', -2);
    end

    hold off;
    title(FIG_NAME, 'FontWeight', 'bold', 'FontSize', 11, ...
        'Color', 'black')    

    set(gca, 'FontSize', 8, 'FontWeight', 'normal');
	grid off;
    box off;

	ylim([-((VAL * 32) + 2), (VAL * 32) + 2]);
	xlim([0, MAX_STEPS + 1]);
    ylabel('Triggers');
    xlabel('Time');
	
    if MAX_STEPS <= 32 
		set(gca, 'XTick', 1:MAX_STEPS);
    end

	%colormap(cm_old); % Restore default colormap
end