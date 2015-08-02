function [curve_data] = murf_envelope_new(pot_pos, max_interval)
%MURF_ENVELOPE_NEW Create MuRF envelope curve
%   MURF_ENVELOPE_NEW creates the shape of the MuRF bandpass filter
%   envelope curve.
%
%   Parameters: rise_precent, fall_percent, max_interval
%   Returns: curve_data
%
%   See also MURF, MURF_ENVELOPE.

% TODO: What we need here is to go down to zero in x^2 curve,
%       for a smoother transition around pot pos 5
%       and get the DIFFERENCE between rise and fall curve,
%       and create rise/fall curve intervals based on that difference.
%
%       Also a problem with rise/fall ratio when max_interval changes.

	ref_voltage = 5;

	if nargin == 0
		max_interval = 100; % Units for DAC voltage curve
		pot_pos = 5; % Initial pot position (middle)
	end

	rise_fall_difference = get_pot_pos(max_interval, pot_pos) - ...
		get_pot_pos(max_interval - (max_interval / 2.2), pot_pos);
		
	% TODO: Try exp((1:5).+curve_difference) versus exp((1:5))
	if pot_pos < 5
		current_rise_curve = ref_voltage / ...
			(2 - rise_fall_difference);
		current_fall_curve = ref_voltage / ...
			(2 + rise_fall_difference);
	else
		current_rise_curve = ref_voltage / ...
			(2 + rise_fall_difference);
		current_fall_curve = ref_voltage / ...
			(2 - rise_fall_difference);
	end
    
	if current_rise_curve > ref_voltage
		current_rise_curve = ref_voltage;
	end
	
	if current_fall_curve > ref_voltage
		current_fall_curve = ref_voltage;
	end

	rise_intervals = max_interval / (ref_voltage / current_rise_curve);
	fall_intervals = max_interval / (ref_voltage / current_fall_curve);
	
	fprintf('Rise/fall Intervals: %.4f / %.4f Potpos: %.4f\n', ...
        rise_intervals, fall_intervals, ...
        get_pot_pos(max_interval, pot_pos) + 2);
	
	rise_inc = ref_voltage / rise_intervals;
	fall_inc = ref_voltage / fall_intervals;
	
	if rise_inc > ref_voltage
		rise_inc = ref_voltage;
	end

	if fall_inc > ref_voltage
		fall_inc = ref_voltage;
	end

	fprintf('Inc: %.4f / %.4f\n', rise_inc, fall_inc);
	
	curve_data = zeros(1, ceil(rise_intervals + fall_intervals));
	change = 0;
	%curve_data(1) = 0; % Init
	
	if pot_pos > 5
		start_pos = max_interval - ...
			ceil(rise_intervals + 1 + fall_intervals);
        
		if start_pos < 1
			start_pos = 1;
		end
	else
		start_pos = 1;
	end

	fprintf('Start pos: %.2f / %.2f / %.2f\n', ...
		start_pos, rise_intervals, fall_intervals);
	%start_pos = 1;
	counter = 0;
	
	% START ------------------------------------------------------------
	% Do rise
	for counter = start_pos:ceil(start_pos + rise_intervals)
		change = change + rise_inc;
		
		if change > ref_voltage
			change = ref_voltage;
		end
		
		curve_data(counter) = change;
	end
	
	temp_counter = counter;
	fprintf('Temp counter: %.2f\n', temp_counter);
	
	% Do fall
	for counter = temp_counter:(ceil(fall_intervals) + temp_counter - 1)
		change = change - fall_inc;
        
		if change >= 0
			curve_data(counter) = change;
		else
			curve_data(counter) = 0;
		end
	end
    % END --------------------------------------------------------------

	clf;
	plot(curve_data, 'co');
	hold on;
	stairs(curve_data, 'b');
	hold off;
	grid;
	xlim([0, max_interval + 2]);
	ylim([-0.5, ref_voltage + 0.5]);
	enhancefigure('MuRF Envelope Curve', 'Time', 'Amplitude');
end

function pos_in_curve = get_pot_pos(max_elements, pot_pos)
	max_pos = 10; % Envelope pot max setting

	pos_in_curve = (((sqrt(max_elements) / max_pos) * (pot_pos - 5))^2)*4;
	
	%if pos_in_curve < 2
	%	pos_in_curve = 2;
	%end
end
