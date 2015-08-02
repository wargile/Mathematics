function [resolution_array, frequency_array, xlabels] = ...
    getrotencresolution(max_val, lin_log, do_print)
%GETROTENCRESOLUTION Get rotary encoder resolution.
%   GETROTENCRESOLUTION(MAX_VAL, LIN_LOG) gets rotary encoder
%   resolution values for a TMR value interval. If parameter
%   LIN_LOG = 0, curve is linear, otherwise logarithmic.
%
%   Example: getrotencresolution (64000, 1)
%   Result:  [ resolution_array, frequency_array, xlabels ]
%
%   Author: Terje B (tbak8@hotmail.com)
%
%   See also GETROTENCDIR

	tic;
	
    if nargin == 0
		max_val = 65535;
		lin_log = 1;
        do_print = false;
    end
	
    if nargin == 1
		lin_log = 1;
        do_print = false;
    end

    if nargin == 2
        do_print = false;
    end
    
	TMR16_MAX_VALUE = 65535;
	%TMR8_MAX_VALUE = 255;
	T_OSC = (8 * 1000000) / 4.0;
	PRESCALER = 4.0;
	MAX_VAL = max_val;
	RESOLUTION_STANDARD = 160; % The higher the finer curve
	LINEAR = 0;
	
    if max_val > TMR16_MAX_VALUE
		error(['Invalid timer value. Max value is ', ...
			num2str(TMR16_MAX_VALUE), '.']);
    end
    
    if max_val < 50
		error('Invalid timer value. Min value is 50');
    end
    
	resolution_array = zeros(1, MAX_VAL - 3);
	frequency_array = zeros(1, MAX_VAL - 3);
	counter = 1;
    
	for tmr_value = MAX_VAL:-1:4
		p = log(tmr_value - 2);
		
        if p == 0
            p = 0.1;
        end
    
		frequency = T_OSC / PRESCALER / tmr_value / 32.0;
		frequency_array(counter) = frequency;
		
        if lin_log == LINEAR
			% Linear (probably best solution after all...):
			resolution_array(counter) = ...
                round(RESOLUTION_STANDARD / (MAX_VAL / tmr_value));
        else
			% Logarithmic:
			resolution_array(counter) = round(RESOLUTION_STANDARD - ...
                (RESOLUTION_STANDARD / p)) + 30;
        end
		
        if resolution_array(counter) < 1
			resolution_array(counter) = 1;
        end
    
        counter = counter + 1;
	end

	createfigure('Rotary Encoder Resolution', false);

	% Plot frequency curve
	plot(frequency_array, 'c-');
	hold on;

	% Plot resolution curve
	h = stairs(resolution_array);
	% h = area(resolution_array);
	hold off;
	grid;
	
	set(h, 'Color', [0.29, 0.58, 0.52], 'LineWidth', 2);
	% set(h, 'facecolor', 'red');
	set(gca(), 'FontSize', 8);
	xlabel(['Frequency in Hz (maxcount: ', num2str(MAX_VAL), ...
		')'], 'FontSize', 8);
	ylabel('Resolution interval', 'FontSize', 8);
	
	if min(frequency_array) < max(resolution_array) + 10
		legend('Frequency', 'Resolution curve', 'Location', 'SouthWest');
	end
	
	if lin_log == LINEAR
		title('Linear resolution curve for rotary encoder', ...
            'FontWeight', 'bold', 'FontSize', 11)
	else
		title('Logarithmic resolution curve for rotary encoder', ...
			'FontWeight', 'bold', 'FontSize', 11)
	end
		
	ylim([min(resolution_array), max(resolution_array)] + 10);
	xlim([1, MAX_VAL + round(MAX_VAL / 150.0)]);
	max_intervals = 10;
	
	xtick_interval = floor(length(frequency_array) / max_intervals);
    xlabels = cell(1, max_intervals);
	% Preallocate
    p = 1; 
	
	for counter = 1:length(frequency_array)
		if mod(counter, xtick_interval) == 0
			xlabels{p} = sprintf('%.2f', frequency_array(counter));
			p = p + 1;
		end
	end
	
    set(gca(), 'XTick', floor(linspace(1, length(frequency_array), ...
		max_intervals)));
    set(gca(), 'XTickLabel', xlabels);

	box off;
    
	% Save our plot
    if do_print == true
        if ismatlab
            print('-djpeg90', 'getrotencresolution.jpg'); % 90% quality
        else
            setenv('GSC', 'GSC');
            % Set a dummy environment var as a fix for missing Ghostscript
            % causing 'warning: implicit conversion from matrix to
            % string' error
            print('-djpg', 'getrotencresolution.jpg');
            replot;
        end
    end

	toc;
end