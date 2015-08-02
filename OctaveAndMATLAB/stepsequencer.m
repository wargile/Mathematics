function [cur_step_ret, change_ret] = ...
    stepsequencer(dir_in, cur_step, step_status, change_in)
% Testing step sequencer logic once again...
%
% cur_step = 0;
% change = 1;
% [cur_step, change] = stepsequencer(2, cur_step, [0,0,0,0,0,0,0,0],
%   change)

FWD = 0;
REV = 1;
PND = 2;
RND = 3;
RUN = 0;
SKIP = 1;
RESET = 2;
STOP = 3;
MAX_STEPS = 8;
DIR_FWD = 1;
DIR_REV = -1;
OFFSET = 1; % TODO: 0 for C
END_OUT = OFFSET - 1;
direction = dir_in; % TODO: Just use in param
change_ret = change_in; % TODO: Just use in param

if (change_ret == DIR_REV)
    change = DIR_REV; % TODO: Just use in param
else
    change = DIR_FWD;
end

%fprintf('Current step: %d, step status: %d\n', cur_step, steps(1, cur_step));

%for (counter = start_step:change:stop_step)
%    fprintf('%d:[%d] ', counter, steps(1, counter));
%end
%fprintf('\n');

% TEST: Reverse step status array of PND and REV dir
if (direction == PND && change == DIR_REV)
    step_status = fliplr(step_status);
end
    
if (cur_step > END_OUT)
    if (step_status(1, cur_step) == STOP)
        cur_step_ret = cur_step;
        return;
    end
    
    if (step_status(1, cur_step) == RESET)
        cur_step_ret = END_OUT;
        return;
    end
end

cur_step_ret = END_OUT; % Default
change_direction = 0; % Default

while (1)
    cur_step = cur_step + 1;
    
    if (cur_step > MAX_STEPS)
        change_direction = 1; % For PND modem change direction
        cur_step = END_OUT;
        break;
    end
    
    if (step_status(1, cur_step) == RUN || step_status(1, cur_step) == STOP)
        break;
    end

    if (step_status(1, cur_step) == RESET)
        cur_step = END_OUT;
        break;
    end
end

cur_step_ret = cur_step;

if (direction == PND && change_direction == 1)
    change_ret = change_ret * -1;
end
