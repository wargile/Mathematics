function ret = getvoct(keyname)
%GETVOCT Gets volt and frequency values for a keyname.
%
%   GETVOCT gets the 1V/OCT, Hz/V, frequency and pitch value
%   for keyname from 'C-1' to 'G9'.
%   Example: ret = GETVOCT('G#4'); ret = GETVOCT('D-1').
%
%   See also: GETFREQ, GETKEYNAME, GET_FREQUENCY, CALC_FREQUENCY

    if nargin ~= 1
        error('syntax: ret = getvoct(''keyname'')');
    end

    if isnumeric(keyname)
        error('Inputs must be string values.');
    end

    keyname = strtrim(keyname);

	legal_values = 'CDEFGAHB0123456789-#';

	for i = 1:length(keyname)
		if isempty(strfind(legal_values, upper(keyname(i))))
		   error('Invalid character(s) in keyname.');
 		end
	end

    if length(keyname) > 4 || length(keyname) < 2
        error('Keyname length must be more than 1 and less than 5');
    end

    if length(keyname) >= 3
        a = strfind(keyname, '-');
        b = strfind(keyname, '#');
        if isempty(a) && isempty(b) % test for empty matrix []1x0
            error('Max keyname is ''G9''.\n');
        end
    end

    voltpernote = 1/12; % 0.08333334V pr. semitone in 1V/OCT mode
    hzpervolt = 55; % 1V = 55Hz in Hz/V mode
    ret.notenumber = 0;

    noteletters = { 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', ...
                    'A', 'A#', 'B' };

    if length(keyname) == 4
        key = keyname(1:2);
        number = str2double(keyname(3:4));
    % elseif (length(keyname) == 3) & (strfind(keyname, '-') > 0)
    % NOTE: Single & operator is correct here (comparing a boolean
    % and a matrice of logical 0/1 (strfind))
    elseif (length(keyname) == 3) && ~isempty(strfind(keyname, '-'))
        key = keyname(1:1);
        number = str2double(keyname(2:3));
    % elseif (length(keyname) == 3) & (strfind(keyname, '#') > 0)
    elseif (length(keyname) == 3) && ~isempty(strfind(keyname, '#'))
        key = keyname(1:2);
        number = str2double(keyname(3:3));
    else
        key = keyname(1:1);
        number = str2double(keyname(2:2));
    end

    if number > 9
        error('Max. keyname is ''G9'' (MIDI note no. 127).');
    end

    % Ucase the note letter
    key(1) = upper(key(1));
    keyname(1) = key(1);

    % B and H are equal, so handle both in input
    if strcmp(key(1), 'H') == 1
        key(1) = 'B';
    end

    %for n = 1:length(noteletters)
    %    if (strcmp(noteletters{n}, key) == 1)
    %        ret.notenumber = n;
    %        break;
    %    end
    %end
    ret.notenumber = find(strcmp(noteletters, key));

    if ret.notenumber > 0
        ret.notenumber = (number * 12) + (ret.notenumber + 11);

        if ret.notenumber > 127
            error('Max. keyname is ''G9'' (MIDI note no. 127).');
        end

        %ret.voltoctave = voltpernote * (ret.notenumber - 21);
        ret.voltoctave = voltpernote * ret.notenumber;
        % A1 IS NOTE NR. 1 (12 + 9 SEMITONES ABOVE MIDI NOTE 0 (C-1))
        ret.frequency = (2 ^ ((ret.notenumber - 69) / 12.0)) * 440;
        % Get the pitch (= MIDI note number) from the frequency found
        ret.pitch = 12 * log2(ret.frequency / 440.0) + 69;
        ret.volthz = ret.frequency / hzpervolt;

        fprintf(['\nThe 1V/OCT value for key name %s (MIDI note %d) ', ...
            'is %.8f V.\n'], keyname, ret.notenumber, ret.voltoctave);
        fprintf('The Hz/V value is %.8f V.\n', ret.volthz);
        % 69 = note number for concert pitch 440 Hz (note A4)
        fprintf('The frequency is %.8f Hz.\n', ret.frequency);
        fprintf('The pitch is %.0f.\n\n', ret.pitch);
        % NOTE: '%.0f' used because of '%d' oddity on pitch value 42
    else
        error('Invalid keyname: ''%s''.', keyname);
    end
end
