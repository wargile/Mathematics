classdef MyClass
    properties(Constant, GetAccess = private)
        % Get/Set class properties
        MAX_MIDI_NOTE = 127;
        SEMITONES_IN_OCT = 12.0;
        VOLT_PR_NOTE = 1.0 / SEMITONES_IN_OCT; % Using 1V/OCT as standard
        REF_VOLTAGE_MIDI_RANGE = (MAX_MIDI_NOTE + 1) * VOLT_PR_NOTE;
        REF_VOLTAGE = 5.0;
        DAC_TEN_BIT = (2^10) - 1; % hex2dec('0x3ff'); 
        DAC_TWELVE_BIT = (2^12) - 1; % hex2dec('0xfff'); 
        DAC_SIXTEEN_BIT = (2^16) - 1; % hex2dec('0xffff'); 
        TMR8_OVERFLOW = (2^8) - 1;
        TMR16_OVERFLOW = ((TMR8_OVERFLOW + 1)^2) - 1;
        PITCH_CONCERT_A = 440;
        NOTENUMBER_CONCERT_A = 69; 
    end
    
    methods
        function obj = MyClass()
            % Do some init stuff...
        end
    
        function frequency = getNoteFrequency(obj)
            frequency = (2 ^ ((x - obj.NOTENUMBER_CONCERT_A) / ...
                obj.SEMITONES_IN_OCT)) * ...
                obj.PITCH_CONCERT_A;
        end
    end
end
