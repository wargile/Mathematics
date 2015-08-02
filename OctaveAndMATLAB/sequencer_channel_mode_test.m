function sequencer_channel_mode_test()
% Testings...
  mode_4x8  = [[1 1 1 1]
			   [2 2 2 2]
			   [3 3 3 3]
			   [4 4 4 4]];
  mode_2x16 = [[1 2 1 2]
			   [1 2 1 2]
			   [3 4 3 4]
			   [3 4 3 4]];
  mode_1x32 = [[1 2 3 4]
			   [1 2 3 4]
			   [1 2 3 4]
			   [1 2 3 4]];

  steps = [[1 2 3 4 5 6 7 8][8 7 6 5 4 3 2 1][1 3 2 4 5 7 6 8][1 3 5 7 2 4 6 8]];

  selected_mode = 1;
  
  switch selected_mode
	case 1
	  parallell_runs = [1][2][3][4];
    case 2
	  parallell_runs = [1 3][2 4];
    case 4
	  parallell_runs = [1 2 3 4];
	otherwise
	  parallell_runs = [1 2 3 4];
  end
end

  
