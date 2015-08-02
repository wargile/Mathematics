function [my_data_in, my_data_out] = fix_excel_data(varargin)
%FIX_EXCEL_DATA Tranform exported Excel data.

	filename_out = 'c:/coding/octave/fix_excel_data.mat';
	
	if nargin == 0
		filename_in = 'c:/coding/ruby/app_data_old.txt';
	else
		filename_in = varargin{1};
	end
	
	% Get data in tab-delimited flat file format
	if ismatlab
		my_data = load(filename_in, '-ascii'); %#ok<*NASGU>
	else
		my_data = load('-ascii', filename_in);
	end

    if ismatlab
        save(filename_out, 'my*', '-mat');
        % NOTE: Filename var not working, use function mode ()
        % save filename_out my* -mat
    else
        save('-mat7-binary', filename_out, 'my*');
        % NOTE: Filename var not working, use function mode ()
        % save -mat7-binary filename_out my*
    end
	
	clear my_data;
	
	my_loaded_data = load(filename_out);

	my_data_in = my_loaded_data.my_data;
	my_data_out = zeros(length(my_data_in) / 4, 4);
	row_counter = 1;
	p = 1;
	
	% Transform the flat array to four cols
	for i = 1:length(my_data_in)
		my_data_out(row_counter, p) = my_data_in(i);
		p = p + 1;
		
		if mod(i, 4) == 0
			p = 1;
			row_counter = row_counter + 1;
		end
	end
end
