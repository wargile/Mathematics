function polyphony(varargin)
%POLYPHONY Does 4-voice poly handling
%
% POLYPHONY simulates 4-voice poly handling for Midi2CV
  
  global poly_status;
  global poly_counters;
  global fp;
  global max_poly;

  poly_status = zeros(1, 4);
  poly_counters = zeros(1, 4);
  max_poly = 4;

  if nargin == 0
    fp_midi = fopen('c:/coding/c_kode/polyphoney2.txt');
  else
    if ischar(varargin{1})
      fp_midi = fopen(varargin{1});
    else
      error('Invalid file name.');
    end
  end
	
  if fp_midi == -1
    error('Unable to open input file.');
  end

  fp = fopen('c:/coding/octave/polyphoney.html', 'w');

  if fp == -1
    error('Unable to output file.');
  end

  disp('Creating HTML output...');

  fprintf(fp, '<html><body>\n');
  fprintf(fp, '<style>\n');
  fprintf(fp, 'body { background: #f2f5f2 }\n');
  fprintf(fp, 'h1, h2, h3 { font-family: verdana, arial; }\n');
  fprintf(fp, ['th { background: #e8e8e8; border: ', ...
      '1px solid #ccc; padding: 5px }\n']);
  fprintf(fp, ['table { font-family: verdana, arial; ', ...
      'font-size: 10px; border-collapse: collapse; ', ...
      'border: 1px solid #ccc; }\n']);
  fprintf(fp, ['.noteinfo { background: #eff6f6; border: ', ...
      '1px solid #ccc; padding: 3px; }\n']);
  fprintf(fp, ['.inactive_note { border: 1px solid #ccc; ', ...
      'background: #fff; color: #ccc; padding: 3px }\n']);
  fprintf(fp, ['.active_note { background: #d0ede0; ', ...
      'font-weight: normal; color: #000; border: ', ...
      '1px solid #ccc; padding: 3px; }\n']);
  fprintf(fp, '</style>\n');
  fprintf(fp, ['<h3>4-voice polyphony test, MatLab version', ...
      '-- Copyright &copy; T. Bakkel&oslash;kken 2010-2012</h3>\n']);

  fprintf(fp, ['<p>Note info: Note number, note status, poly ', ...
               'buffer status, note position in poly buffer', ...
               '</p><table>\n']);
  fprintf(fp, ['<tr class="noteinfo"><th colspan=3>', ...
      'Note info</th><th ', ...
      'colspan=40>4-voice polyphony</th></tr>\n']);

  % Read in all note messages from file

  buf = fgets(fp_midi);

  while ischar(buf)
    pos = strfind(buf, ',');
    midiStatus = str2double(buf(1:pos - 1));
    midiNote = str2double(buf(pos + 1: ...
      length(buf) - pos));

    UpdatePoly(midiStatus, midiNote);

    buf = fgets(fp_midi);
  end
  
  fprintf(fp, '</table></body></html>');

  fclose(fp);
  fclose(fp_midi);

  disp('Done!');
end

function UpdatePoly(message, notenumber)
  global poly_status;
  global poly_counters;
  global fp;
  global max_poly;

  note_on = 1;
  note_off = 0;
  RESET_VALUE = 0;

  % Poly handling START

  if message == note_off
    for i = 1:max_poly
      % Reset counter and value in notenumber slot
      if poly_status(i) == notenumber
        poly_status(i) = RESET_VALUE; % Reset
        poly_counters(i) = RESET_VALUE;
      end
      
      % Decrease counter if counter > 1
      if poly_counters(i) > 1
        poly_counters(i) = poly_counters(i) - 1;
      end
    end
  end

  if message == note_on
    for i = 1:max_poly
      if (poly_counters(i) == RESET_VALUE) || ...
        (poly_counters(i) == max_poly)
        poly_status(i) = notenumber;
        break;
      end
    end

    for i = 1:max_poly
      % Set counter = 1 if counter == max_poly
      if poly_counters(i) == max_poly
        poly_counters(i) = 1;
      else
        % Increase counter if counter ~= max_poly
        if (poly_status(i) > RESET_VALUE)
          poly_counters(i) = poly_counters(i) + 1;
        end
      end
    end
  end

  % Poly handling END

  if message == note_on
    n = 'ON';
  else
    n = 'OFF';
  end

  fprintf(fp, ['<tr><td class="noteinfo">', ...
               '%d, %s</td><td class="noteinfo">%d, %d, %d, %d ', ...
               '</td><td class="noteinfo">', ...
               'Counters: %d, %d, %d, %d</td>'], ...
          notenumber, n, poly_status(1), poly_status(2), ...
          poly_status(3), poly_status(4), ...
          poly_counters(1), poly_counters(2), ...
          poly_counters(3), poly_counters(4));

  for i = 1:40
    found = 0;

    for p = 1 : max_poly
      if (poly_status(p) == i)
        fprintf(fp, '<td class="active_note">%03d</td>', ...
          poly_status(p));
        found = 1;
        break;
      end
    end

    if (found == 0)
      fprintf(fp, '<td class="inactive_note">%03d</td>', i);
    end
  end

  fprintf(fp, '</tr>\n');
end
