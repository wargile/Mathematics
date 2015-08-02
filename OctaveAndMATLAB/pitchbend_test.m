function [bender_array] = pitchbend_test(varargin)
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
    bender_values = 0:BENDER_14BIT_MAX;
    
    byte1 = bitand(bender_values, 127);
    byte2 = bitand(bitshift(bender_values, -7), 127);
    bender_array = (GetBenderValue(byte1, byte2) - ...
        BENDER_MIDDLE_POS) / BENDER_INTERVAL;

    createfigure(FIG_NAME, false);
    
    plot(bender_array, 'c-');
  
    enhancefigure('MIDI PitchBend Values', 'MIDI Data (byte2 << 7)', ...
        'Note Value');  
    
	hold on;

	%h = plot(bender_array_floored, 'b-');
	h = stairs(floor(bender_array), 'b-');
	
    set(h, 'LineWidth', 2);

    xlim([0, BENDER_14BIT_MAX + 100]);
    ylim([BENDER_SEMITONES * -1, BENDER_SEMITONES]);
    set(gca, 'YTick', [BENDER_SEMITONES * -1, 0, BENDER_SEMITONES], ...
        'XTick', [0, BENDER_MIDDLE_POS, BENDER_14BIT_MAX]);

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
