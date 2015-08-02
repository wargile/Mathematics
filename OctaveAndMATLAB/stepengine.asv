function [curstep, change] = stepengine(steps, direction, curstep, change)
    RUN = 0;
    %SKIP = 1;
    RESET = 2;
    STOP = 3;
    
    %FWD = 0;
    %REV = 1;
    PND = 2;
    RND = 3;
    
    MAXSTEP = 8;
    MINSTEP = 1;
    %DIR_FWD = 1;
    DIR_REV = -1;
    steps_found = 0;
    %counter = 0;
    
    % Check for available steps
    for counter = MINSTEP:MAXSTEP
        if (steps(counter) == RUN || steps(counter) == STOP) 
            steps_found = steps_found + 1;
        end
    end
    
    if (steps_found == 0)
        curstep = MINSTEP - 1; % TODO: Direction handling here?
        return;
    end
    
    % RND mode
    if (direction == RND)
        % TODO: END OUT on step_counter == MAXSTEP
        if (curstep >= MINSTEP && curstep <= MAXSTEP)
            if (steps(curstep) == STOP) % TODO: Stop on STOP or not
                return;
            end
        end
    
        while (1)
            curstep = randi(MAXSTEP);
            
            if (steps(curstep) == RUN || steps(curstep) == STOP)
                return;
            end
        end
    end    
    
    % Other modes
    while (1)
        if (curstep >= MINSTEP && curstep <= MAXSTEP)
            if (steps(curstep) == STOP)
                break;
            end

            if (steps(curstep) == RESET)
                if change == DIR_REV
                    curstep = MAXSTEP + 1;
                else
                    curstep = MINSTEP - 1;
                end
            
                break;
            end
        end

        curstep = curstep + change;
  
        if (curstep == MAXSTEP + 1)
            if direction == PND
                change = DIR_REV;
                curstep = MAXSTEP;
            else
                break;
            end
        end

        if (curstep == MINSTEP - 1)
            break;
        end

        if (steps(curstep) == RUN || steps(curstep) == STOP)
            break;
        end
    end
    
    if (curstep < MINSTEP || curstep > MAXSTEP)
        fprintf('END OUT signalled.\n');
    end
    