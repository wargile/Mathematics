function [result] = stepengine_new()
    RUN = 0;
    SKIP = 1;
    RESET = 2;
    STOP = 3;
    
    FWD = 0;
    REV = 1;
    PND = 2;
    RND = 3;
    
    CH_1X32 = 0;
    CH_2X16 = 1;
    CH_4X8 = 2;
    
    MAXCHANNELS = 4;
    MAXSTEP = 8;
    MINSTEP = 1;
    DIR_FWD = 1;
    DIR_REV = -1;
    
    steps_found = 0;
    active_channel = 0;
    curstep = 22;
    channel_setup = CH_2X16;
    
    steps = zeros(1, MAXSTEP * MAXCHANNELS);
    active_channel = ceil(curstep / MAXSTEP);
    
    switch channel_setup
      case CH_1X32
        end_step = MAXCHANNELS * MAXSTEP;
        start_step = 1;
      case CH_2X16
        end_step = [(MAXCHANNELS * MAXSTEP) / 2, (MAXCHANNELS * MAXSTEP)];
        start_step = [1, ((MAXCHANNELS * MAXSTEP) / 2) + 1];
      case CH_4X8
        end_step = [MAXSTEP, MAXSTEP * 2, MAXSTEP * 3, MAXSTEP * ...
                    4];
        start_step = [1,  MAXSTEP + 1, (MAXSTEP * 2) + 1, ...
                      (MAXSTEP * 3) + 1];
    end
    
    result.start_step = start_step;
    result.end_step = end_step;
    result.active_channel = active_channel;
