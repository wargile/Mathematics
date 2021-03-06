function [bender_array] = pitchbend(varargin)
%PITCHBEND Test MIDI pitchbend values.
%   PITCHBEND gives pitch bend values for the 14-bit pitch controller MIDI
%   data range. Parameter SEMI_TONES sets the pitch bend range (max 12
%   semitones).

%   http://www.midi.org/techspecs/midimessages.php
%   TODO: Profile this, and check floor(array) 

	tic;
	
    FIG_NAME = 'MIDI Bender Values';
	
	if nargin == 1
		if varargin{1} < 1 || varargin{1} > 12
			error('Invalid bender value. Valid values are 1 to 12.');
		else
			BENDER_SEMITONES = varargin{1};
		end
	else
		BENDER_SEMITONES = 12.0; % Default: Bend a whole octave
	end
		
    BENDER_14BIT_MAX = hex2dec('3fff'); % 16383;
    BENDER_MIDDLE_POS = (BENDER_14BIT_MAX + 1) / 2.0; % 8192/H2000
    BENDER_INTERVAL = ((BENDER_14BIT_MAX + 1) - BENDER_MIDDLE_POS) / ...
        BENDER_SEMITONES;
    
    %bender_array_floored = zeros(1, BENDER_14BIT_MAX);
    bender_array = zeros(1, BENDER_14BIT_MAX + 1);
    byte1 = 0;
	byte2 = 0;
	
    for i = 0:BENDER_14BIT_MAX
        %byte1 = bitand(i, 127);
        %byte2 = bitand(bitshift(i, -7), 127);
	
        bender_array(i + 1) = (GetBenderValue(byte1, byte2) - ...
            BENDER_MIDDLE_POS) / BENDER_INTERVAL;
			
        if byte1 == 127
			byte2 = byte2 + 1; % Increase MSB
			byte1 = 0; % Reset LSB
        else
			byte1 = byte1 + 1; % Increase LSB
        end
    end

    createfigure(FIG_NAME, false);
    
    bender_array(BENDER_14BIT_MAX + 1) = BENDER_14BIT_MAX + 1;
    
    plot(bender_array, 'c-');
    
    my_title = sprintf('MIDI PitchBend - range %d semitones', ...
        BENDER_SEMITONES);
    enhancefigure(my_title, 'MIDI Data (byte2 << 7)', ...
        'Note Value');  
    
    xlim([0, BENDER_14BIT_MAX + 100]);
    ylim([BENDER_SEMITONES * -1, BENDER_SEMITONES]);
    set(gca, 'YTick', [BENDER_SEMITONES * -1, 0, BENDER_SEMITONES], ...
        'XTick', [0, BENDER_MIDDLE_POS, BENDER_14BIT_MAX]);

	hold on;
	%h = plot(floor(bender_array), 'b-');
	h = stairs(floor(bender_array), 'b-');
	
    set(h, 'LineWidth', 2);
	legend('Values for DAC output', 'Note values', ...
        'Location', 'NorthWest');
	
	if ismatlab
		legend('boxon');
	else
		legend('boxoff');
	end
	
    box off;
	hold off;
    grid;
	
	toc;
end

function result = GetBenderValue(midi_byte1, midi_byte2)
    result = bitor(bitshift(midi_byte2, 7), midi_byte1);
end
