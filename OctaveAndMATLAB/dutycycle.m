function dutycycle(varargin)
%DUTYCYCLE Just testing dutycycle code...

  INTERNAL_MIN_FREQUENCY = 2000;
  INTERNAL_MIN_DUTYCYCLE = 1;
  INTERNAL_MAX_DUTYCYCLE = 99;
  START_FREQUENCY = (INTERNAL_MIN_FREQUENCY / 5);
  
  max_count = START_FREQUENCY;
  duty_values = INTERNAL_MIN_DUTYCYCLE:INTERNAL_MAX_DUTYCYCLE;
  
  fprintf('MaxCount: %d.\n', max_count);
  
  for i = 1:length(duty_values)
    duty_result_32nd = ceil((max_count * duty_values(i)) / 100);
    fprintf('%.2f, ', duty_result_32nd);

    if mod(i, 8) == 0
      fprintf('\n');
    end
  end
  
  fprintf('\n');
end
