function [curstep, change] = stepengine(steps, direction, curstep, change)
    RUN = 0;
    SKIP = 1;
    RESET = 2;
    STOP = 3;
    
    FWD = 0;
    REV = 1;
    PND = 2;
    RND = 3;
    
    MAXSTEP = 8;
    MINSTEP = 1;
    DIR_FWD = 1;
    DIR_REV = -1;
    
    % TODO: Check for available steps needed here?
    
    while (1)
        if (curstep >= MINSTEP && curstep <= MAXSTEP)
            if (steps(curstep) == STOP)
                return;
            end

            if (steps(curstep) == RESET)
                if change == DIR_REV
                    curstep = MAXSTEP + 1;
                else
                    curstep = MINSTEP - 1;
                end
            
                return;
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
