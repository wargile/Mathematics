function ret = set_frequency(desired_frequency, tmr_num, create_settings)
%SET_FREQUENCY Give PIC timer registers for desired frequency
%   SET_FREQUENCY gives the prescaler and timer preload value for a
%   desired frequency in Hz and a timer number.
%
%   Usage: SET_FREQUENCY(desired_frequency, tmr_num, create_settings)
%
%   See also GETFREQ, CALC_FREQUENCY, GET_FREQUENCY

    tic;

    % TODO: Add osc speed as parameter?
    TMR16_OVERFLOW = 65536;
    TMR8_OVERFLOW = 256;
    T_OSC = 2000000;
    % TODO: Add individual prescalers for all timers, see get_frequency.m
    prescaler_pos = 1;  % Start off with prescaler 1
    postscaler_pos = 1;
    frequency = 0;
    
    if (desired_frequency > T_OSC)
        error('The desired frequency is too large.');
    end
    
    PS_TMR0 = [1, 2, 4, 8, 16, 32, 64, 128, 256];
    PS_TMR1_TMR3 = [1, 2, 4, 8];
    PS_TMR2 = [1, 4, 16];
    POST_TMR2 = 1:16; % TMR2 postscaler
    
    if nargin == 1
        tmr_num = 0;
		create_settings = true;
    end
	
	if nargin == 2
		create_settings = true;
	end
    	
    if tmr_num <= 1 || tmr_num == 3
        preload_val = TMR16_OVERFLOW - 1;
        overflow = TMR16_OVERFLOW;
        tmr_bits = 16;
        postscalers = 1;
    else
        preload_val = TMR8_OVERFLOW - 1;
        overflow = TMR8_OVERFLOW;
        tmr_bits = 8;
        postscalers = POST_TMR2;
    end

    switch tmr_num
        case 0
            prescalers = PS_TMR0;
            max_prescaler = 256;
        case {1, 3} % Note syntax! WRONG: [1, 3]
            prescalers = PS_TMR1_TMR3;
            max_prescaler = 8; 
        case 2
            prescalers = PS_TMR2;
            max_prescaler = 16;
			max_postscaler = 16;
        otherwise
            error(['Invalid timer number: ', num2str(tmr_num), ...
                '. Valid numbers are 0 to 3.']);
    end
    
    % Check if the desired frequency is possible to achieve
    if tmr_num == 2
        % Get lowest frequency with max postscaler (16)
        ret = get_frequency(8, tmr_num, max_prescaler, TMR8_OVERFLOW - 1, ...
			16, false);
    else
        ret = get_frequency(8, tmr_num, max_prescaler, 1, 0, false);
    end
    
    if ret.frequency > desired_frequency
        fprintf('Warning: The desired frequency %.2f Hz', ...
            desired_frequency);
        fprintf(' is not possible to achieve.\nMinimum frequency for ');
        fprintf('Timer %d is %.2f Hz. Exiting program.\n', tmr_num, ...
            ret.frequency);
        return;
    end

    prescaler = prescalers(prescaler_pos);
    postscaler = postscalers(postscaler_pos);
	
	settings_filename = sprintf('Timer%dsettings.txt', tmr_num);

    fprintf('Calculating settings...');
    
    while true
        old_frequency = frequency; % Keep old one for comparison
        
        frequency = T_OSC / (overflow - preload_val) / prescaler ...
            / postscaler;

        if desired_frequency >= frequency
            fprintf(' done!\n');
			
			if create_settings == false
				fprintf('\n');
			end
			
            break;
        end 
        
        old_preload_val = preload_val;
        
        if preload_val == 1
            fprintf('.');
            preload_val = overflow - 1;
            
            if tmr_num ~= 2 % Just change prescaler
				if prescaler < max_prescaler
					prescaler_pos = prescaler_pos + 1;
					prescaler = prescalers(prescaler_pos);
				else
					break;
				end
            else % Change postscaler and prescaler
				if prescaler == max_prescaler
					prescaler = 1;
					prescaler_pos = 1;
					
					if postscaler < max_postscaler
						postscaler_pos = postscaler_pos + 1;
						postscaler = postscalers(postscaler_pos);
					else
						break;
					end
				else
					prescaler_pos = prescaler_pos + 1;
					prescaler = prescalers(prescaler_pos);
				end
            end % END if tmr_num ~= 2
        else
            preload_val = preload_val - 1;
        end % END if preload_val == 1 
    end % END while true

    % Return register info to caller
    format long;
    
    ret.desired_frequency = desired_frequency;

    if abs(desired_frequency - frequency) < ...
        abs(desired_frequency - old_frequency)
        ret.actual_frequency = frequency;
        ret.tmr_preload_value = preload_val;
    else
        ret.actual_frequency = old_frequency;
        ret.tmr_preload_value = old_preload_val;
    end
    
    if tmr_num == 2 % Get PR2 register value
        ret.tmr_preload_value = TMR8_OVERFLOW - ret.tmr_preload_value;
    end
    
    ret.error_rate_in_precent = ...
        (abs(ret.desired_frequency - ret.actual_frequency) ...
        / ret.actual_frequency) * 100;
    ret.bpm = frequency * 60;
    ret.prescaler = prescaler;
	
	if tmr_num == 2
		ret.postscaler = postscaler;
	end
	
    ret.timer_num = tmr_num;
    ret.timer_bits = tmr_bits;
	ret.interrupt_period = 1.0 / ret.actual_frequency;


	% Create PIC register settings START
	if create_settings == true
		fprintf('Creating output file...');
		fp_out = fopen('set_frequency_settings.c', 'w');
		fp_in = fopen(settings_filename, 'r');
		
		if fp_in == 0 || fp_out == 0
			error 'Unable to open input/output file(s).';
		end
	
		%counter = 0;
		
		while true
			buf = fgets(fp_in);
			%counter = counter + 1;
			
			%if mod(counter, 5) == 0
			%	fprintf('.');
			%end
			
            if buf == -1
				break;
            end
			
            if length(buf) > 1
                buf = strrep(buf, '{tmr_preload}', ...
                    num2str(ret.tmr_preload_value));

                for counter = 1:4
                    buf = strrep(buf, sprintf('{postscaler_ps%d}', ...
                        counter - 1), ...
                        num2str(bitget(ret.postscaler - 1, counter)));
                end

                if ~ismatlab
                    fputs(fp_out, buf); % Octave only
                else
                    fprintf(fp_out, buf);
                end
            end
		end
	
		fclose(fp_in);
		fclose(fp_out);
		fprintf(' done! Saved as: %s\n\n', settings_filename);
	end
	% Create PIC register settings END
	
    
    fprintf('Timer................: Timer %d (%d bits)\n', ...
        tmr_num, tmr_bits);
    fprintf('Desired frequency....: %.5f Hz (%.5f BPM)\n', ...
		ret.desired_frequency, ret.desired_frequency * 60);
    fprintf('Actual frequency.....: %.5f Hz (%.5f BPM)\n', ...
		ret.actual_frequency, ret.bpm);
    fprintf('Error rate...........: %.2f%%\n', ...
        ret.error_rate_in_precent);
	fprintf('Interrupt period.....: %.8f sec\n', ret.interrupt_period);
    fprintf('Prescaler............: %d\n', ret.prescaler);
	
	if tmr_num == 2
		fprintf('Postscaler...........: %d\n', ret.postscaler);
		fprintf('Timer %d PR2 value....: %d\n\n', tmr_num, ...
			ret.tmr_preload_value);
	else
		fprintf('Timer %d preload value: %d\n\n', tmr_num, ...
			ret.tmr_preload_value);
	end

    format short;
    
    toc;
end
