% c:\coding\octave\stephandling
% Author: tbak <tbak@EG13908>
% Created: 2012-07-24

function [ ret ] = stephandling ()

    counter = 0;
    steps = [0 1 0 1 1 3 1 0];
    new_step = 0;
    
    for counter = 1:10
        oldsteps = steps;
        % TODO: Change step status here
        new_step = findnextstep(steps, oldsteps, new_step);
        
        if new_step == 0
            new_step = findnextstep(steps, oldsteps, new_step);
        end
        
        fprintf('New step: %d\n', new_step);
    end
    
endfunction

function [new_step] = findnextstep(steps, oldsteps, old_step)
    
    new_step = old_step;
    
    if old_step >= 1 && old_step <= 8
        if oldsteps(old_step) == 3 && steps(old_step) == 2
            new_step = 0;
            return;
        end
    
        if steps(old_step) == 3 % STOP
            return;
        end
    end

    while (1)
        if new_step < 8
            new_step = new_step + 1;
        else
            new_step = 1;
        end
    
        if steps(new_step) == 2
            new_step = 0;
            return;
        end
        
        if new_step == old_step
            return;
        end
        
        if steps(new_step) == 0 || steps(new_step) == 2
            return;
        end
    end
    
endfunction
