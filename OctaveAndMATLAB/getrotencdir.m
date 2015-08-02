function direction = getrotencdir(gcprev, gcnext)
%GETROTENCDIR Get rotary encoder direction value.
%   GETROTENCDIR gets the direction value (forward or reverse) for a
%   rotary encoder using 2-bit graycode.
%
%   Syntax: getrotencdir(gcprev, gcnext)
%   Example: getrotencdir('01', '11');
%
%   See also: GETROTENCRESOLUTION

    %% Check arguments
    if (nargin ~= 2)
        error('Usage: getrotencdir(gcprev, gcnext)');
    end
    
    if isnumeric(gcprev) || isnumeric(gcnext)
        error('Inputs must be string values.');
    end
    
    if (strcmp(gcprev, gcnext) == 1)
        error('Input strings must be different values.');
    end
    
    if length(gcprev) ~= 2 || length(gcnext) ~= 2 
        error(['Invalid input string(s). ', ...
            'Valid string values are ''00'' and ''01''.']); 
    end
    
    if gcprev(1) + gcprev(2) > ('1' + '1') || ...
            gcnext(1) + gcnext(2) > ('1' + '1')
        error(['Invalid input string(s). ', ...
            'Valid string values are ''00'' and ''01''.']); 
    end  

    % 2-bit gray code:
    % A B
    % 0 0
    % 0 1
    % 1 1
    % 1 0

    % Rev: 0-1-3-2-0-1-3-2
    % Fwd: 2-3-1-0-2-3-1-0

    %% Convert string arguments to integers and check values
    gcprev_a = str2double(gcprev(1));
    gcprev_b = str2double(gcprev(2));
    gcnext_a = str2double(gcnext(1));
    gcnext_b = str2double(gcnext(2));

    if gcprev_a > 1 || gcprev_b > 1 || gcnext_a > 1 || gcnext_b > 1
        error(['Invalid input arguments. ', ...
            'Valid string values are ''00'' and ''01''.']);
    end

    CW = 1;
    CCW = 0;

    oldrotaryvalue = bitor(gcprev_b, (bitshift(gcprev_a, 1)));
    rotaryvalue = bitor(gcnext_b, (bitshift(gcnext_a, 1)));

    if bitxor(oldrotaryvalue, rotaryvalue) > 2
        error('Wrong gray code number pair.');
    end

    %% Find and display encoder direction
    if (xor(bitand(oldrotaryvalue, 1), ...
            (bitand(bitshift(rotaryvalue, -1), 1))) == CW)
        direction = CW; 
        fprintf('Direction is CW.\n');
    elseif (xor(bitand(oldrotaryvalue, 1), ...
            (bitand(bitshift(rotaryvalue, -1), 1))) == CCW)
        direction = CCW; 
        fprintf('Direction is CCW.\n');
    else
        fprintf(['Unable to detect direction from ', ...
            'inputs ''%s'' and ''%s''.\n'], gcprev, gcnext);
    end
end