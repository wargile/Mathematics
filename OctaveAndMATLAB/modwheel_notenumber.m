function h = modwheel_notenumber(rounds, max_notes, rising_curve)
%MODWHEEL_NEW Plots modwheel changes.
%
%   Usage: h = MODWHEEL_NEW(<notenumber>, [plotline color/linetype]) 

    FIG_NAME = 'MIDI Note Modwheel Curve';

    MAX_NOTES = max_notes;
	ROUNDS = rounds;
	INTERVAL = pi/32; %16;
	dac_values = zeros(1, ceil(((pi * ROUNDS) - ((-pi) * ROUNDS)) ...
		/ INTERVAL) * MAX_NOTES);
    dac_values_org = dac_values;
    
	p = 0;
    
    if rising_curve == true
        min_note = 1;
        max_note = MAX_NOTES;
        change = 1;
    else
        min_note = MAX_NOTES;
        max_note = 1;
        change = -1;
    end

	pos = -pi / 2; % Always start modulation curve at zero offset
	difference = 0;
	last_pos = 0;
	
	if rising_curve == true
		curve_change = -1;
	else
		curve_change = 1;
	end
    
    for notenumber = min_note:change:max_note
		%if notenumber > min_note % don't do this initially
			mydiff = (sin(last_pos) < sin(pos));
			
			if mydiff == 1
				fprintf("-> %f ", sin(pos));
				if sin(pos) > 0
					difference = sin(pos + INTERVAL)*curve_change;
				else
					difference = cos(pos + INTERVAL)*curve_change;
				end
			else
				fprintf("<- %f ", sin(pos));
				if sin(pos) < 0
					difference = cos(pos + INTERVAL)*curve_change;
				else
					difference = sin(pos + INTERVAL)*curve_change;
				end
			end
		%end
	
        for counter = 1:ceil(((pi * ROUNDS) - ((-pi) * ROUNDS)) / INTERVAL)
			%fprintf("Diff: %f pos: %f\n", ...
			%	sin(last_pos) < sin(pos), sin(pos));
			p = p + 1;
			difference = difference / (counter);
            
			last_pos = pos;
			
            if pos == pi
				pos = -pi;
			else
				pos = pos + INTERVAL;
            end
			
			dac_values(p) = sin(pos) + notenumber + difference;
            dac_values_org(p) = sin(pos);
        end
    end

    % Plot graph, create a new named figure
    createfigure(FIG_NAME, true);

    % To get a black plot background and white grid:
    %if ismatlab()
    %  colordef black
    %end
    
    % Get all active figures
    %figs = get(0, 'Children');
    % Get active figure in array
    %active_array = (figs' == gcf); % [0 1 0 0]
    % Close all but the active figure
    %close(figs(figs ~= gcf));
    % Find all figures
    %findall(0, 'Type', 'figure');
    
    if ishold()
        clf;
        cla;
        hold off;
    end
    
    if ismatlab() % Check if we're in MatLab. Code in ismatlab.m
        colordef white; % Use standard plot colors (error in Octave)
    end
    
    set(gca, 'Color', [1 1 1])
    set(gca, 'FontSize', 8);
    
    stairs(dac_values, 'b-');
    hold on;
    stairs(dac_values_org, 'Color', [0.57, 0.68, 0.99]);
    hold off;
    
    xlabel('Time/Phase', 'FontSize', 8);
    ylabel('MIDI Note Pitch', 'FontSize', 8);
    title('Modwheel Curve', 'FontWeight', 'bold', 'FontSize', 11)
    if rising_curve
        legend('MIDI Note Pitch', 'Location', 'NorthWest');
    else
        legend('MIDI Note Pitch', 'Location', 'NorthEast');
    end
        
    %set(gca, 'Color', [0.90 0.97 0.95])
	grid minor;
    set(gca, 'YGrid', 'on')
    set(gca, 'XGrid', 'on')
    box off;
    axis tight;
    set(gca, 'YLim', [min(dac_values) - notenumber - 1, max(dac_values) + 1]);
    my_xticks = zeros(1, max_notes);
    
    for counter = 1:max_notes
        my_xticks(counter) = ceil((((pi * ROUNDS) - ...
            ((-pi) * ROUNDS)) / INTERVAL) * counter) + 1;
    end

    set(gca, 'XTick', my_xticks);
    
    % Return data to caller
    if nargout > 0
        h = struct; % Define h as a struct
        h.dac_values = dac_values;
        h.dac_values_org = dac_values_org;
        h.array_size = length(dac_values);
    end
end
