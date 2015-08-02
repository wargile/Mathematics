function [dac_array, velocity_array, volt_array] = ...
    dacvalues(notenumber, velocity)
%DACVALUES Creates DAC values for MIDI notes 0-127.
%
%   Syntax: [dac_array, velocity_array, volt_array] = 
%     DACVALUES([NOTENUMBER, VELOCITY])
%
%   The function calculates note, volt and velocity values for
%   10- and 12-bit DAC's for the MIDI note range (0-127) if no
%   argument is given, or for the NOTENUMBER argument.
%
%   http://en.wikipedia.org/wiki/CV/Gate
    
    % Some useful constants
    MAX_MIDI_NOTE = 128;
    VOLT_PR_NOTE = 1.0/12.0; 
    REF_VOLTAGE = MAX_MIDI_NOTE * VOLT_PR_NOTE; 
    DAC_TWELVE_BIT = 4096; % hex2dec('0xfff'); 
    DAC_TEN_BIT = 1024;

    %max_voltage_out = REF_VOLTAGE; 
    %max_dac_value_12bit = (max_voltage_out * ...
    % (DAC_TWELVE_BIT / REF_VOLTAGE)); 
    %max_dac_value_16bit = (max_voltage_out * ...
    % (DAC_SIXTEEN_BIT / REF_VOLTAGE));
	
    if nargin == 0
        % Create the DAC value arrayS
        dac_array = zeros(1, 128); 
        volt_array = zeros(1, 128);
        velocity_array = zeros(1, 128);
    
        for i = 0:127
            voltage_out = (i + 1) * VOLT_PR_NOTE;
            volt_array(i + 1) = voltage_out;
            dac_array(i + 1) = floor(voltage_out * ...
                (DAC_TWELVE_BIT / REF_VOLTAGE));
            velocity_array(i + 1) = floor(DAC_TEN_BIT / ...
                (MAX_MIDI_NOTE - i));
        end
        
        createfigure('DAC info');
        subplot(1, 3, 1);
        plot(dac_array, 'b-');
        axis tight;
        grid;
        enhancefigure('12-bit DAC MIDI note values', ...
            'MIDI note number', '12-bit DAC values');
        box off;
        subplot(1, 3, 2);
        plot(volt_array, 'r-');
        axis tight;
        grid;
        enhancefigure('Volt values', 'MIDI note number', 'Volt values');
        box off;        
        subplot(1, 3, 3);
        plot(velocity_array, 'm-');
        axis tight;
        grid;
        enhancefigure('10-bit DAC MIDI velocity values', ...
            'MIDI velocity value', '10-bit DAC velocity values');
        box off;        
    else
        % Return the values for the note number argument
        voltage_out = (notenumber - 21) * VOLT_PR_NOTE;
        voltage_vel_out = (127 - velocity) * VOLT_PR_NOTE;
        volt_array = voltage_out;
        dac_array = floor((voltage_out + 1) * ...
            (DAC_TWELVE_BIT / REF_VOLTAGE));
        velocity_array = floor((voltage_vel_out + 1) * ...
            (DAC_TWELVE_BIT / REF_VOLTAGE));
    end
    
