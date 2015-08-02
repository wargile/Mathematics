function [envelope_pos] = murf_envelope(interval, current_envelope_pos)
%MURF_ENVELOPE Create MuRF envelope curve
%   See also MURF, MURF_ENVELOPE_NEW.

	if nargin == 0
		interval = 0.2; 
	end

	min_pos = 1;
	max_pos = 10;
	max_amplitude = 5;
	envelope_pos = min_pos:interval:max_pos;
	%max_elements = numel(envelope_pos);
	% Or find numel this way:
	max_elements = ceil((max_pos - min_pos) / interval) + 1;
	
	
	if nargin < 2
		current_envelope_pos = floor(max_elements / 2);
	else
		current_envelope_pos = ceil(max_elements /  ...
			(max_pos / current_envelope_pos));
	end

	change_up = ((((-1) - (max_pos / 2.0) + envelope_pos).^2) / ...
		max_amplitude) + 0.25;
	change_down = ((((0.1) - (max_pos / 2.0) + envelope_pos).^2) / ...
		max_amplitude) + 0.25;
	
	subplot(2, 1, 1);
	stairs(change_up, 'r-');
	box off;
	grid;
	hold on;
	stairs(change_down, 'b-');
	hold off;
	%xlim([0, (10 / interval)]);
	set(gca, 'ytick', [1 2 3 4 5 ]);
	axis tight;

	enhancefigure('MuRF Rise/Fall Curve', 'Time', 'Rise and Fall');
	
	turn_around = 0;
	envelope_pos = zeros(1, max_elements);
	envelope_pos(1) = 0;
	%printf('%f-', envelope_pos);
	
	% Find num elements in curve for time slot placement
	change = 0;
	
	for counter = min_pos:1:max_elements + 1
		if change >= max_amplitude
			turn_around = 1;
		end

		if turn_around == 0
			change = change + change_up(current_envelope_pos);
		else
			change = change - change_down(current_envelope_pos);
		end

		if change > max_amplitude
			change = max_amplitude;
		end

		if change <= 0
			start_pos = counter;
			break;
		end
	end

	turn_around = 0;
	change = 0;
	start_pos = max_elements - start_pos; 
	
	% Create curve
	for counter = start_pos + 1:1:max_elements + 1
		if change >= max_amplitude
			turn_around = 1;
		end

		if turn_around == 0
			change = change + change_up(current_envelope_pos);
		else
			change = change - change_down(current_envelope_pos);
		end

		if change > max_amplitude
			change = max_amplitude;
		end

		if change < 0
			change = 0;
		end
		
		envelope_pos(counter) = change;
	end

	subplot(2, 1, 2);
	stairs(envelope_pos, 'm-');
	box off;
	grid;
	axis tight;
	enhancefigure('MuRF Envelope Curve', 'Amplitude', 'Time');
end
