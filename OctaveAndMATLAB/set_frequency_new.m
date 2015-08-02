function ret = set_frequency_new(desired_frequency, tmr_num)
%SET_FREQUENCY Give PIC timer registers for desired frequency
%   SET_FREQUENCY gives the prescaler and timer preload value for a
%   desired frequency in Hz and a timer number.

    tic;
    
    if nargin < 2
        error(['Missing input parameter(s). Usage: SET_FREQUENCY', ...
            ' (desired_frequency, timer_num)']);
    end

    % TODO: Add osc speed as parameter?
    TMR16_OVERFLOW = 65536;
    TMR8_OVERFLOW = 256;
    T_OSC = 2000000;
    postscaler_pos = 1; % Start off with postscaler 1 for timer 2
    frequency = 0;
    
    if (desired_frequency > T_OSC)
        error('The desired frequency is too large.');
    end
    
    PS_TMR0 = [1, 2, 4, 8, 16, 32, 64, 128, 256];
    PS_TMR1_TMR3 = [1, 2, 4, 8];
    PS_TMR2 = [1, 4, 16];
    POST_TMR2 = [1, 4, 16]; % TMR2 postscaler
    
    if nargin == 1
        tmr_num = 0;
    end
    	
    if tmr_num <= 1 || tmr_num == 3
        preload_val = 1;
        overflow = TMR16_OVERFLOW;
        tmr_bits = 16;
    else
        preload_val = TMR8_OVERFLOW - 1;
        overflow = TMR8_OVERFLOW;
        tmr_bits = 8;
    end

    switch tmr_num
        case 0
            prescalers = PS_TMR0;
            max_prescaler = 256;
            postscalers = 1;
        case {1, 3} % Note syntax! WRONG: [1, 3]
            prescalers = PS_TMR1_TMR3;
            max_prescaler = 8; 
            postscalers = 1;
        case 2
            prescalers = PS_TMR2;
            max_prescaler = 16; 
            postscalers = POST_TMR2;
        otherwise
            error(['Invalid timer number: ', num2str(tmr_num), ...
                '. Valid numbers are 0 to 3.']);
    end
    
    % Check if the desired frequency is possible to achieve
    if tmr_num == 2
        % Get lowest frequency with max postscaler (16)
        ret = get_frequency(8, tmr_num, max_prescaler, ...
            TMR8_OVERFLOW - 1, 16, false);
    else
        ret = get_frequency(8, tmr_num, max_prescaler, 1, 0, false);
    end
    
    if ret.frequency > desired_frequency
        fprintf('Warning: The desired frequency %.2f Hz', ...
            desired_frequency);
        fprintf(' is not possible to achieve.\nMinimum frequency for ');
		
		if ret.frequency < 1 % Display more decimal digits for f < 1
			fprintf('Timer %d is %.8f Hz. Exiting program.\n', ...
                tmr_num, ret.frequency);
		else
			fprintf('Timer %d is %.3f Hz. Exiting program.\n', ...
                tmr_num, ret.frequency);
		end
	
        return;
    end

    prescaler = prescalers(length(prescalers));
    prescaler_pos = length(prescalers);
    
    if tmr_num == 2
        postscaler = postscalers(length(postscalers));
    else
        postscaler = 1;
    end
    
    f_counter = 1;
    frequencies = zeros(2, length(prescalers));
    fprintf('Working...');
    
    while true
        old_frequency = frequency; % Keep old one for comparison
        
        %if tmr_num == 2
        %    frequency = T_OSC / postscaler / preload_val / prescaler;
        %else
            frequency = T_OSC / (overflow - preload_val) / prescaler;
        %end
        
        % TODO: Use and increase postscaler too if Timer 2

        if desired_frequency <= frequency
            frequencies(1, f_counter) = frequency;
            frequencies(2, f_counter) = (abs(desired_frequency - ...
                frequency) / frequency) * 100;
            
            f_counter = f_counter + 1;
            preload_val = overflow - 1; % Force restart
        end
    
        old_preload_val = preload_val;
        
        if preload_val == overflow - 1
            fprintf('.');
            preload_val = 1;
            
            if prescaler > 1
                prescaler_pos = prescaler_pos - 1;
                prescaler = prescalers(prescaler_pos);
            else
                break;
            end            
        else
            preload_val = preload_val + 1;
        end
    end

    % Return register info to caller
    format long;
    
    ret.desired_frequency = desired_frequency;
    ret.frequencies = frequencies;

    if abs(desired_frequency - frequency) < ...
        abs(desired_frequency - old_frequency)
        ret.actual_frequency = frequency;
        ret.tmr_preload_value = preload_val;
    else
        ret.actual_frequency = old_frequency;
        ret.tmr_preload_value = old_preload_val;
    end
    
    %if tmr_num == 2 % Get PR2 register value
    %    ret.tmr_preload_value = TMR8_OVERFLOW - ret.tmr_preload_value;
    %end
    
    ret.error_rate_in_precent = ...
        (abs(ret.desired_frequency - ret.actual_frequency) ...
        / ret.actual_frequency) * 100;
    ret.bpm = frequency * 60;
    ret.prescaler = prescaler;
    ret.timer_num = tmr_num;
    ret.timer_bits = tmr_bits;
    
    fprintf('Timer................: Timer %d (%d bits)\n', ...
        tmr_num, tmr_bits);
    fprintf('Desired frequency....: %.5f Hz (%.5f BPM)\n', ...
		ret.desired_frequency, ret.desired_frequency * 60);
    fprintf('Actual frequency.....: %.5f Hz (%.5f BPM)\n', ...
		ret.actual_frequency, ret.bpm);
    fprintf('Error rate...........: %.4f %%\n', ...
        ret.error_rate_in_precent);
    fprintf('Prescaler............: %d\n', ret.prescaler);
    fprintf('Timer %d preload value: %d\n\n', tmr_num, ...
        ret.tmr_preload_value);
    
    format short;
    
    toc;
end
