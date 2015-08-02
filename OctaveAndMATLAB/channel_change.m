function [current_channel] = ...
        channel_change(channel_setup, channel_enabled, current_channel)
% Testing channel setup for 4-channel step sequencer
%
% Usage: current_channel = channel_change(1, [1,1,0,1],
%        current_channel);

    CHANNEL_SETUP_1x32 = 1;
    CHANNEL_SETUP_2x16 = 2;
    CHANNEL_SETUP_4x8 = 3;
    NO_CHANNEL = 0;
    MAX_CHANNELS = 4;
    
    %if (current_channel == NO_CHANNEL)
    %    current_channel = current_channel + 1;
    %end
    
    old_ch = current_channel;
    
    switch channel_setup
      case CHANNEL_SETUP_1x32
        while true
            if (current_channel < MAX_CHANNELS)
                current_channel = current_channel + 1;
            else
                current_channel = 1;
            end
            
            if (current_channel == old_ch)
                if (current_channel ~= NO_CHANNEL)
                    if (channel_enabled(current_channel) == 0)
                        current_channel = NO_CHANNEL;
                    end
                end
                
                break;
            end
                
            if (channel_enabled(current_channel) == 1)
                break; 
            end
        end
      case CHANNEL_SETUP_2x16
        if (mod(current_channel, 2) > 0) % We're on ch 1 or 3
            if (channel_enabled(current_channel + 1) == 1)
                current_channel = current_channel + 1;
            else
                if (channel_enabled(current_channel) == 0)
                    current_channel = NO_CHANNEL;
                end
            end
        else % We're on ch 2 or 4
            if (channel_enabled(current_channel - 1) == 1)
                current_channel = current_channel - 1;
            else
                if (channel_enabled(current_channel) == 0)
                    current_channel = 0;
                end
            end
        end
      case CHANNEL_SETUP_4x8
        if (channel_enabled(current_channel) == 0)
            current_channel = NO_CHANNEL;
        end
    end
