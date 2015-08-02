function [max_elements_rise, max_elements_fall, rise_interval, ...
    fall_interval] = murf_rise_fall(p_max_elements, p_pot_pos)
%MURF_RISE_FALL Create MuRF envelope curve
%   Parameters:
%     p_max_elements, p_pot_pos
%   Returns:
%     max_elements_rise, max_elements_fall, rise_interval, fall_interval

	ref_voltage = 5;
	%min_pot_pos = 0;
	max_pot_pos = 10;
	
	createfigure('MuRF Pot Pos Curve');
	clf;

	% FOR DEBUG START ---------------------------------------------------
	p_pot_pos_data = ([1:5 5:-1:1]);
	rise_percent = (50 - (((5 - p_pot_pos_data) * 50) / (max_pot_pos / 2)));
	fall_percent = (50 - (((5 - p_pot_pos_data) * 30) / (max_pot_pos / 2)));
	%rise_percent = 50 - (([50:-1:1 1:50].^2) / 50);
	%fall_percent = 50 - (([50:-1:1 1:50].^2) / 75);

	subplot(2, 1, 1);
	plot(rise_percent, 'b-');
	hold on;
	plot(fall_percent, 'r-');
	ylim([0, 55]);
	set(gca, 'YTick', [10, 20, 30, 40, 50]);
	set(gca, 'YGrid', 'on');
	box off;
	%grid;
	enhancefigure('MuRF Envelope Diff Curve', 'Pot Position', 'Percent');
	hold off;
	% FOR DEBUG END -----------------------------------------------------
	
	conv_pot_pos = p_pot_pos;
	
	if p_pot_pos > 5
		conv_pot_pos = 10 - p_pot_pos;
	end
	
	if p_pot_pos < 5
		rise_percent = (50 - (((5 - conv_pot_pos) * 50) / (max_pot_pos / 2)));
		fall_percent = (50 - (((5 - conv_pot_pos) * 34) / (max_pot_pos / 2)));
		%rise_percent = 50 - (((50 - (p_pot_pos * 10)).^2) / 50);
		%fall_percent = 50 - (((50 - (p_pot_pos * 10)).^2) / 75);
	else
		rise_percent = (50 - (((5 - conv_pot_pos) * 34) / (max_pot_pos / 2)));
		fall_percent = (50 - (((5 - conv_pot_pos) * 50) / (max_pot_pos / 2)));
		%rise_percent = 50 - (((50 - (p_pot_pos * 10)).^2) / 75);
		%fall_percent = 50 - (((50 - (p_pot_pos * 10)).^2) / 50);
	end

	max_elements = p_max_elements;
	
	max_elements_rise = round((max_elements * rise_percent) / 100);
	max_elements_fall = round((max_elements * fall_percent) / 100);
	
	if max_elements_rise < 1
		max_elements_rise = 1;
	end

	if max_elements_fall < 1
		max_elements_fall = 1;
	end

	if max_elements_rise + max_elements_fall > max_elements
		max_elements_fall = max_elements_fall - 1;
	end
	
	rise_interval = ref_voltage / max_elements_rise;

	fall_interval = ref_voltage / max_elements_fall;
	
	% -------------------------------------------------------------------
	% Find start pos
	curve_data = zeros(1, p_max_elements + 1);
	change = 0;
	counter = 0;
	curve_data(1) = 0; % Init - test only, starting curve at zero pos
	
	if p_pot_pos > 5
		start_pos = max_elements - (max_elements_rise + max_elements_fall);
		
		if start_pos < 1
			start_pos = 2;
		end
	else
		start_pos = 2;
	end

	fprintf('Start pos: %.2f Rise_interval: %.2f Fall_interval: %.2f\n', ...
		start_pos, rise_interval, fall_interval);
	
	% ------------------------------------------------------------
	% TODO: START - For-loops is instead of calling function
	% Do curve ascent
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
	% TODO: END - For-loops is instead of calling function
	% END --------------------------------------------------------------

	% FOR DEBUG START --------------------------------------------------
	% Display graph
	subplot(2, 1, 2);
	plot(curve_data, 'co-');
	hold on;
	stairs(curve_data, 'b');
	hold off;
	box off;    
	grid;
	xlim([-1, p_max_elements + 2]);
	ylim([-0.5, ref_voltage + 0.5]);
	set(gca, 'YTick', 0:5);
	enhancefigure('MuRF Envelope Curve', 'Time/Counter', 'Amplitude');
    % FOR DEBUG END ----------------------------------------------------
end

%function pos_in_curve = get_pot_pos(max_elements, pot_pos)
%	max_pos = 10;
%
%	pos_in_curve = (((sqrt(max_elements) / max_pos) * (pot_pos - 5))^2)*4;
%	
%	if pos_in_curve < 2
%		pos_in_curve = 2;
%	end
%end
