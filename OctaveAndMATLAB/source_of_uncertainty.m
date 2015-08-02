function [curve_data, random_curve_data] = source_of_uncertainty(varargin)
%SOURCE_OF_UNCERTAINTY Test random code for PIC project.
%
%   SOURCE_OF_UNCERTAINTY tests random code in various modes for the PIC
%   'Source of Uncertainty' module/project.
%
%   Parameters:
%     1) Rounds: Minimum 1
%     2) Random phase: true/false
%     3) Increase frequency: true/false
%     4) ADC value: Increase value - greater random variations
%     5) Follow baseline: true/false
%     6) Complex shape: true/false
%
%   Examples:
%
%   Follow baseline, even frequency, 1 turn:
%     [cd, rcd] = source_of_uncertainty(1, false, false, 2.5, true, false);
%   Do not follow baseline, increase frequency, 3 turns, complex shape:
%     [cd, rcd] = source_of_uncertainty(3, false, true, 2.5, false, true);

%   Copyright (C) Terje B. 2007-2011

	tic;
	
	FIG_NAME = 'Source of Uncertainty';
    %DAC_12BIT_MAX = hex2dec('fff'); % 12-bit: 4095
	%ADC_10BIT_MAX = hex2dec('fff'); % 10-bit: 1023
	VOLT_REF = 5.0;
	interval = 0.03;
	complex_shape = false;
	
	rnd_time = false;
	rounds = 1;
	inc_freq = false;
	adc_value = (VOLT_REF / 5); % Default: No ADC-input
	follow_baseline = true;
	
	if nargin > 0
		rounds = varargin{1};
	end
		
	if nargin > 1
		rnd_time = varargin{2};
	end

	if nargin > 2
		inc_freq = varargin{3};
	end

	if nargin > 3
		adc_value = (VOLT_REF / varargin{4}) / 2;
	end

	if nargin > 4
		follow_baseline = varargin{5};
	end

	if nargin > 5
		complex_shape = varargin{6};
	end

	if rounds <= 0
		error('Rounds value must be larger than zero.');
	end
	
	MAX_ELEMENTS = ceil((((pi - (pi * -1)) / interval) * rounds) ...
		+ (rounds - 1));
		
	mod_interval = 1; % Always force pitch change on init
	curve_pos = -pi;
	random_curve_data = zeros(1, MAX_ELEMENTS); 
	curve_data = zeros(1, MAX_ELEMENTS);
	
	for counter = 1:MAX_ELEMENTS
		curve_data(counter) = sin(curve_pos);

		if complex_shape == true
			curve_shape = sin(curve_pos) + cos(curve_pos * 4); % TODO: var
		else
			curve_shape = sin(curve_pos);
		end
		
		if mod(counter, mod_interval) == 0 % Change pitch
			rand_value = ((rand() * curve_shape) / adc_value);
	
			if follow_baseline == false
				random_curve_data(counter) = curve_shape - rand_value;
			else
				random_curve_data(counter) = rand_value;
			end
		
			if rnd_time == true
				mod_interval = ceil(rand() * 4);
			end
		else % Do not change pitch
			if counter > 1
				random_curve_data(counter) = ...
                random_curve_data(counter - 1);
			end
		end
		
		if (curve_pos == pi)
			curve_pos = -pi;
		else
			curve_pos = curve_pos + interval;
		end
	
		% Increase interval size to increase curve frequency
		if inc_freq == true
			interval = interval + (rounds / 25000.0);
		end
	end

	createfigure(FIG_NAME, false);
    
	%stairs(random_curve_data, 'b-');
	[xs, ys] = stairs(1:MAX_ELEMENTS, random_curve_data);
	% No plot when using two params, just return x and y data
	
	if ismatlab
        % TODO: Plot both curves in one plot call in MatLab
        h = plot(1:MAX_ELEMENTS, curve_data, 'Color', [0.52, 0.63, 0.72]);
        hold on;
		plot(xs, ys, 'b-');
        hold off;
    else
    	% Plot both curves in one plot call
		h = plot(1:MAX_ELEMENTS, curve_data, 'Color', [0.66, 0.77, 0.85], ...
			xs, ys, 'b-');
	end

    set(h(1), 'LineWidth', 1);
	
	if ismatlab % Set plot background color if we're in MatLab
		set(gca, 'Color', [0.92, 0.99, 1]);
	end

	enhancefigure(FIG_NAME, 'Phase/Timing', 'Pitch');
	
    % Find positive/negative value transitions, and xtick them
	my_xticks = find(diff(sign(curve_data)));
    
    if rounds < 4
        set(gca, 'XTick', [0 my_xticks MAX_ELEMENTS]);
    end
	
	%axis tight; % Checked with profiler - slower than xlim
	xlim([1, MAX_ELEMENTS]);
	
    if abs(max(curve_data)) > abs(max(random_curve_data))
        max_curve_data = max(curve_data);
    else
        max_curve_data = max(random_curve_data);
    end
    
    if abs(min(curve_data)) > abs(min(random_curve_data))
        min_curve_data = min(curve_data);
    else
        min_curve_data = min(random_curve_data);
    end
            
    ylim([min_curve_data - 0.5, max_curve_data + 0.5]);
        
    if min_curve_data < -1 && max_curve_data > 1
        set(gca, 'YTick', [min_curve_data, -1, 0, 1, max_curve_data]);
    else
        set(gca, 'YTick', [-1, 0, 1]);
    end
    
    grid;
	
	toc;
end
