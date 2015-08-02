function [steps] = swapsteps(steps)
	MAXSTEP = numel(steps);

    if numel(steps) <= 1
        return;
    end
    
	for counter = 1:floor(MAXSTEP / 2.0)
		temp = steps(counter);
		steps(counter) = steps(MAXSTEP - (counter - 1));
		steps(MAXSTEP - (counter - 1)) = temp;
	end

    display_steps(steps, MAXSTEP - 1)
end

function display_steps(steps, new_step)
    MAXSTEP = numel(steps);
    DIR_REV = -1;
    change = DIR_REV;
    
    if change == DIR_REV
        start = MAXSTEP;
        step_change = DIR_REV;
		active_step = MAXSTEP - (new_step - 1);
    end

    fprintf('Active step: %d, status: %d\n', new_step, steps(active_step));
end
