function [result] = get_frequency (osc, tmr_num, ps, tmr_value, ...
    tmr2_postscaler, do_display)
%GET_FREQUENCY Calculate frequency and BPM.
%   GET_FREQUENCY (OSC_IN_MHZ, TMR_NUM, PRESCALER, TMR_VALUE, POSTSCALER)
%   gets the frequency and BPM for a given oscillator speed, timer number,
%   prescaler, postscaler (if timer 2) and timer value.
%
%   Example: get_frequency(8, 2, 1, 127, 16, true)
%   Returns: [result]
%
%   See also GETFREQ, CALC_FREQUENCY.

%   Author: Terje B (tbak8@hotmail.com)
%   Copyright (C) Terje B 2011

    if osc < 1 || osc > 40
		error 'Invalid oscillator value. Valid values are 1 to 40.';
    end
    
    if nargin < 6
        do_display = true;
    end

	T_OSC = ((osc * 1000000) / 4);
	t_unit = 1 / T_OSC;
    PS_TMR0 = [1, 2, 4, 8, 16, 32, 64, 128, 256];
    PS_TMR1_TMR3 = [1, 2, 4, 8];
    PS_TMR2 = [1, 4, 16];
    POSTSCALER_TMR2 = [1, 4, 16];
    	
    if tmr_num <= 1 || tmr_num == 3
		TMR_OVERFLOW = 65536;
    else
		TMR_OVERFLOW = 256;
    end

    switch tmr_num
        case 0
            prescaler = PS_TMR0;
        case {1, 3} % Note syntax! WRONG: [1, 3]
            prescaler = PS_TMR1_TMR3;
        case 2
            prescaler = PS_TMR2;
        otherwise
            error(['Invalid timer number: ', num2str(tmr_num), ...
                '. Valid numbers are 0 to 3.']);
    end

    if tmr_value > (TMR_OVERFLOW - 1)
		error(['Invalid timer value. Max value is ', ...
            num2str(TMR_OVERFLOW - 1), '.']);
    end

    if ~ismember(ps, prescaler)
		error(['Invalid prescaler value: %d. ', ...
            'Valid values are%s.'], ps, sprintf(' %d', prescaler));
    end
	
	% Set values for display and returning structure to caller
    if tmr_num ~= 2
        result.frequency = T_OSC / ps / (TMR_OVERFLOW - tmr_value);
    else
        if ~ismember(tmr2_postscaler, POSTSCALER_TMR2)
            error(['Invalid postscaler value: %d. ', ...
                'Valid values are%s.'], tmr2_postscaler, ...
                sprintf(' %d', POSTSCALER_TMR2));
        end
        
        % NOTE: PR2 value for Timer 2, not preload
        result.frequency = T_OSC / ps / tmr_value / tmr2_postscaler;
    end
    
	result.bpm = result.frequency * 60.0;
	result.timer_no = tmr_num;
	result.timer_val = tmr_value;
	result.f_osc = osc;
	result.t_osc = osc / 4.0;
	result.interrupt_period_sec = t_unit * TMR_OVERFLOW;
	result.tcy = t_unit * 1000000;
	result.prescaler = ps;
    
    if tmr_num == 2
        result.postscaler = tmr2_postscaler;
    end
	
    if do_display
        fprintf('Timer....................: TMR%d\n', result.timer_no);
        fprintf('F_OSC....................: %d Mhz\n', result.f_osc);
        fprintf('T_OSC....................: %d Mhz\n', result.t_osc);
        fprintf('Prescaler................: 1:%d\n', result.prescaler);
        
        if tmr_num == 2
            fprintf('Postscaler...............: 1:%d\n', ...
                tmr2_postscaler);
        end
        
        fprintf('TMR%d value...............: %d\n', result.timer_no, ...
            result.timer_val);
        fprintf('TCY......................: %.3f us\n', result.tcy);
        fprintf('Interrupt period (sec)...: %.8f\n\n', ...
            result.interrupt_period_sec);
        fprintf('Frequency................: %.2f Hz  (%.2f BPM)\n', ...
            result.frequency, result.bpm);
    end
end
