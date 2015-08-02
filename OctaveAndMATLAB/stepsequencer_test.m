function [channel_active] = stepsequencer_test()
% Testing step sequencer logic once again...
FWD = 0;
REV = 1;
PND = 2;
RND = 3;
DIR_FWD = 1;
DIR_REV = -1;
MAX_CHANNELS = 4;
MAX_STEPS = 8;
CH_4X8 = 3;
CH_2X16 = 2;
CH_1X32 = 1;
OFFSET = 1; % TODO: 0 for C
END_OUT = OFFSET - 1;
NO_CHANNEL = OFFSET - 1;
steps = zeros(MAX_CHANNELS, MAX_STEPS);
channel_status = ones(1, MAX_CHANNELS); % Which channels are available
channel_active = zeros(1, MAX_CHANNELS); % Which channels are active
counter = 0;
direction = PND;

ch_config = CH_1X32;
change = 1;
cur_step = 0;
current_channel = 4; % TODO: Should be 0 on init? Change change_channel.m?
counter = 0;

steps(1,OFFSET:MAX_STEPS) = [2,1,0,1,0,1,1,1];
steps(2,OFFSET:MAX_STEPS) = [2,0,0,1,0,1,0,0];
steps(3,OFFSET:MAX_STEPS) = [1,2,0,1,0,1,2,0];
steps(4,OFFSET:MAX_STEPS) = [1,1,1,1,1,1,2,0];

%fp = fopen('StepSequencer.html', 'w+');
current_channel = channel_change(CH_1X32, channel_status, current_channel);

if (current_channel ~= NO_CHANNEL)
    channel_active(current_channel) = 1;
end

while (counter < 34)
    counter = counter + 1;
    
    % Change step status
    if (counter == 7)
        steps(2,OFFSET:MAX_STEPS) = [1,0,0,1,0,1,0,1];
        steps(3,OFFSET:MAX_STEPS) = [1,0,0,1,0,1,2,0];    
    end
    
    [cur_step, change] = stepsequencer(direction, cur_step, ...
                                       steps(current_channel,:), ...
                                       change);
    
    if (cur_step == END_OUT)
        % Don't change ch if PND and REV dir
        if (direction == PND && change == DIR_REV)
            % Do nuthin'...
        else
            change = DIR_FWD; % TODO: Need to test dir REV etc.
            fprintf('[Ch %d] END OUT\n', current_channel);
            
            current_channel = channel_change(CH_1X32, ...
                                             channel_status, ...
                                             current_channel);
        
            if (current_channel ~= NO_CHANNEL)
                channel_active(current_channel) = 1;
            end
        
            % TODO: Get change/direction, etc. for new channel
            
            [cur_step, change] = stepsequencer(direction, cur_step, ...
                                               steps(current_channel,:), ...
                                               change);
        end
        
    end

    if (cur_step ~= END_OUT)
        if (change == DIR_FWD)
            fprintf('[Ch %d] Step %d\n', ...
                    current_channel, cur_step);
        else
            fprintf('[Ch %d] Step %d\n', ...
                    current_channel, MAX_STEPS - (cur_step - 1));
        end
    end
end

%fclose(fp);
