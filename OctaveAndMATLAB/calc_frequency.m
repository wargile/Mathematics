function [fo, fn] = calc_frequency (p_result, p_overflow, p_f_osc)
%CALC_FREQUENCY Calculate timer frequency.
%   CALC_FREQUENCY(CCP_RESULT, TMR_OVERFLOW, OSC_IN_MHZ) gets the
%   pulse frequency for a CCP RESULT, TMR<n> overflow and oscillator
%   speed.
%
%   Example: calc_frequency (32767, 1, 8)
%   Result:  [ old_result, new_result ]
%
%   Author: Terje B (tbak8@hotmail.com)
%
%   See also GETFREQ, GET_FREQUENCY

	init_result = p_result;
    overflow = p_overflow;
    f_osc_mhz = p_f_osc;
    f_osc = p_f_osc * 1000000;
    t_osc = f_osc / 4.0;
    tmr16_overflow = 65535;

    fprintf('CCP<n> result.....: %d\n', init_result);
    fprintf('TMR<n> overflow...: %d\n', overflow);
    fprintf('OSC speed.........: %d Mhz\n', f_osc_mhz);

    % Original PIC code variant...
    % -------------------------------------------------
    result = init_result + (overflow * tmr16_overflow);
    fo = (t_osc / result);
    % -------------------------------------------------

    % Our shining new solution...
    % -------------------------------------------------
    result = (init_result / tmr16_overflow) + overflow;
    fn = ((t_osc / result) / tmr16_overflow);
    % -------------------------------------------------
	
    fprintf('Old result........: %.2f Hz, BPM = %.2f\n', fo, fo * 60);
    fprintf('New result........: %.2f Hz, BPM = %.2f\n', fn, fn * 60);
end
