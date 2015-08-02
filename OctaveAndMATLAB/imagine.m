function [image_data, I, row, col] = imagine(max_number)
    if max_number < 16
        error 'Invalid number!'
    end
    
	if mod(sqrt(max_number), 1) > 0
		error 'Invalid number!'
	end

	% Get unique random numbers
	image_data = fifteen(max_number);
	
	% Transform all values to below 1
    image_data = image_data / max_number;

	createfigure('Imagine', false);
	% Display the image in a subplot
	subplot(1, 2, 1);
	title('Imagine');
    
    imagesc(image_data);
    colorbar('NorthOutside');
    
	% colormap( [jet(); flipud( jet() );0 0 0] );
	% colormap('default');
    axis off % Remove axis ticks and numbers
    axis image 
    
	hold on;
	% Find elements with values above 0.95
    [row, col] = find(image_data > 0.95);
    	
	% Plot the finds over the image
	plot(col, row, 'bo');
    
	hold off;
	
	% Another example: Create a 'chessboard'
	b = zeros(8);
	w = ones(8);
	tile = [b w; w b];
	I = repmat(tile, 8, 8);
	% Display the image in a subplot
	subplot(1, 2, 2);
	title('Chessboard');
    
    imagesc(I);

    axis off % Remove axis ticks and numbers
    axis image 
    
    colormap('hot');
	% bone, autumn, summer, winter, spring, cool, copper,
	% flag, gray, hot, hsv, jet, ocean, pink, prism,
	% rainbow, contrast
	
	% set(gcf,'renderer','opengl')
	% set(0,'DefaultLineLineSmoothing','on')
	% set(0,'DefaultPatchLineSmoothing','on')
end
