function getkeyname(notenumber) 
%GETKEYNAME Gets the key/note name for a MIDI note number (0-127).
%   Syntax: getkeyname(notevalue 0-127)
%
%   GETKEYNAME gets the key/note name for a MIDI note number (0-127).

    if nargin ~= 1 || ischar(notenumber)
        error('Usage: getkeyname(notenumber 0-127)');
    end
    if length(notenumber) > 1 % string
        error('Notenumber must be between 0 and 127');
    end
    if (notenumber < 0) || (notenumber > 127) 
        error('Notenumber must be between 0 and 127');
    end

    noteletters = { 'C', 'C#', 'D', 'D#', 'E', 'F', ...
        'F#', 'G', 'G#', 'A', 'A#', 'B' };

    frequency = (2 ^ ((notenumber - 69) / 12)) * 440;
    % 69 = A4 note (C4 is middle C).
    % 440Hz is the frequency of the A4 note.

    fprintf('The key name for MIDI note no. %d is: %s%d\n', ...
        notenumber, noteletters{mod(notenumber, 12) + 1}, ...
        floor((notenumber / 12) - 1));
    fprintf('The Volt value (1V/oct) is: %.2fV\n', ...
        notenumber * 0.0833333333333333333);
    fprintf('The frequency  is: %.2fHz\n', frequency);
end

