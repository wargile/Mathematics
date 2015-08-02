% Scale test

% Author: tbak <tbak@EG11233>
% Created: 2011-09-28

function [ret] = scale_test()
    SEMI_TONES = 12;
    %my_array = [1 0 0 1 0 0 0 1 0 0 1 0 0 0 1];
    my_array = [1 0 0 0 1 0 0 1 0 0 0 0];
    %my_array = [1 0 0 0 1];
    my_length = numel(my_array);
    chord_length = SEMI_TONES;
    my_total_length = 24;
    p = 0;
    counter = 0;
    noteletters = { 'C', 'Db', 'D', 'Eb', 'E', 'F', ...
        'Gb', 'G', 'Ab', 'A', 'Bb', 'B' };
    
    for i = 1:my_total_length
        if p == my_length
            if my_length > SEMI_TONES
                p = mod(p, SEMI_TONES) + 1;
            else
                p = 1;
            end
        else
            p = p + 1;
        end

        if p < SEMI_TONES % <= ?
            counter = counter + 1;
        else
            counter = mod(p, SEMI_TONES);
        end
    
        if my_array(p) == 1
            fprintf('%d: %d-%d %s%d\n', counter, i, my_array(p), ...
                noteletters{counter}, ceil(i / SEMI_TONES));
        else
            fprintf('%d: %d-%d\n', counter, i, my_array(p));
        end
    end

    fprintf('\n');
end
