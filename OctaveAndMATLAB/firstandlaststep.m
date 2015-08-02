function [num_steps, step_status_ret, active_step_boundary, ...
    is_stopped, is_reset] = firstandlaststep(current_step, direction)
% Getting step intervals for sequencer code
% Params: current_step - the step to test from
%         direction - FORWARD (1) or REVERSE (-1)
%
% TODO: EndOut is triggered after last ACTIVE step, whatever that is

  NO_STEP = 4; RUN = 0; SKIP = 1; RESET = 2; STOP = 3; %#ok<NASGU>
  FIRST_STEP = 2;
  % LAST_STEP = 9;
  FORWARD = 1;
  REVERSE = -1;
  STEP_MAX = 10;
  STEP_MIN = 1;
  step_status = [NO_STEP, SKIP, RESET, RUN, STOP, SKIP, RUN, RUN, SKIP, NO_STEP];
  step_types = {'RUN', 'SKIP', 'RESET', 'STOP', 'NO_STEP'};

  step_status_ret = cell(1, STEP_MAX);

  for i = 1:length(step_status)
    step_status_ret{i} = step_types{step_status(i) + 1};
  end

  if nargin < 1
    current_step = FIRST_STEP;
  end

  if nargin < 2
    direction = FORWARD;
  end

  if nargin == 1 || nargin == 2
	if current_step < STEP_MIN || current_step > STEP_MAX - 2
	  error 'Invalid current step.';
    end
  end

  if nargin == 2
	if direction ~= FORWARD && direction ~= REVERSE
	  error 'Invalid direction. Use 1 (FWD) or -1 (REV).';
    end
  end

  if direction == FORWARD
    max = STEP_MAX - 1; min = current_step + 1; change = FORWARD;
  else
    max = STEP_MIN + 1; min = current_step + 1; change = REVERSE; 
  end

  %fprintf('--- Min: %d max: %d change %d\n', min, max, change);
  is_stopped = 0;
  is_reset = 0;
  end_out = 0;

  for i = min:change:max
    [active_step_boundary, is_stopped, is_reset, current_step] = ...
      get_interval(step_status, i, max, change);

    %fprintf('isStopped: %d %d %d\n', is_stopped, active_step_boundary(1), ...
	%	   active_step_boundary(2));

    fprintf('Step boundary: %d %d CurStep: [%d]\n', active_step_boundary(1), ...
			active_step_boundary(2), current_step);

    %if is_stopped == 1
	%   break;
    %end
  end

  is_stopped = 0;

  [active_step_boundary, is_stopped, is_reset, current_step] = ...
    get_interval(step_status, min, max, change);

  num_steps = get_number_of_enabled_steps(step_status, ...
    min, max, change);
end

function [step_boundary, is_stopped, is_reset, current_step] = ...
		 get_interval(step_status, min, max, change)
  RUN = 0; RESET = 2; STOP = 3;
  FIRST_STEP = 1;
  LAST_STEP = 2;
  FORWARD = 1;
  REVERSE = -1;

  if change == REVERSE
	step_boundary = [9, 9];
    current_step = 9;
  else
	step_boundary = [0, 0];
    current_step = 0;
  end

  first = 1;
  is_stopped = 0;
  is_reset = 0;

  %fprintf('min: %d max: %d change %d\n', min, max, change);
  
  for step_counter = min:change:max
	%fprintf('Step status: %d\n', step_status(step_counter));

    if (step_status(step_counter) == RESET)
	  is_reset = 1;
      break;
    end

    if step_status(step_counter) == RUN || ...
      step_status(step_counter) == STOP
      if first == 1
        step_boundary(FIRST_STEP) = step_counter - 1;
        first = 0;
        current_step = step_counter - 1;
		% TODO: Put is_stopped = 1 here if step = STOP? Depends on usage later!
      end

      step_boundary(LAST_STEP) = step_counter - 1;

      if step_status(step_counter) == STOP
        is_stopped = 1;
        break;
      end
    end
  end
end

function [num_steps] = get_number_of_enabled_steps ...
         (step_status, min, max, change)
  RUN = 0; RESET = 2; STOP = 3;

  num_steps = 0;

  %fprintf('Start: %d, stop: %d, change: %d\n\n', min, max, change);

  for i = min:change:max
	if step_status(i) == RESET
	  break;
	end

    if step_status(i) == RUN || step_status(i) == STOP
	  num_steps = num_steps + 1;
    end
  end

end

% TODO: Really needed??
function [current_step, change, end_out, is_stopped, is_reset] = ...
		 get_next_step(step_status, current_step, turn_around, direction, change)
  DIRECTION_FORWARD = 1;
  DIRECTION_REVERSE = -1;
  end_out = 0;

  while 1
    if step_status(current_step) == RESET
	   is_reset = 1;
	   break;
	 end

    if current_step == active_interval(2) && direction ~= PENDULUM % TODO: REVISE!
      current_step = active_interval(1);
	  end_out = 1;
      break;
    end

    if current_step == active_interval(2) && direction == PENDULUM
      if turn_around == 1
        if change == DIRECTION_FORWARD
		  change = DIRECTION_REVERSE;
		else
		  change = DIRECTION_FORWARD;
		end

        turn_around = 0;
      else
        turn_around = turn_around + 1;
      end
    end
    
	if turn_around == 0
      current_step = current_step + change;
    end 
                
    if step_status(current_step) == RUN || step_status(current_step) == STOP
	  if step_status(current_step) == STOP
        is_stopped = 1;
      end

      break;
    end
  end
end

function plot_sequencer_run()
  % TODO: Get code from sequencer.m
end
