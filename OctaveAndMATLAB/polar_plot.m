function [data] = polar_plot(radius, theta)
%See: A practical Intro to Programming and Problem solving, section 15.2
%See: http://en.wikipedia.org/wiki/Polar_coordinate_system

	%data.z1 = 3 + 4i;
	%data.r = abs(data.z1);
	%data.theta = angle(data.z1);
	%data.r * exp(i * data.theta);
	
	%createfigure('Polar Coordinates', false);
	
	%plot3(data.z1, '*', 'MarkerSize', 10);
	%grid;
	
	%enhancefigure('Polar Plot', 'real part', 'imaginary part');
    
    %Find cartesian x and y from polar coordinates:
    x = radius * cos(theta);
    y = radius * sin(theta);
    
    fprintf('Cartesian: x = %f, y = %f\n', x, y);
    
    data.cartesian_x = x;
    data.cartesian_y = y;

    %Find polar coordinates from caretsian x and y coordinates:
    radius = sqrt(y^2 + x^2);
    
    if x > 0
        theta = atan(y / x);
    end
    
    if x < 0 && y >= 0
        theta = atan(y / x) + pi;
    end
    
    if x < 0 && y < 0
        theta = atan(y / x) - pi;
    end
    
    if x == 0 && y > 0
        theta = pi / 2;
    end
    
    if x == 0 && y < 0
        theta = -(pi / 2);
    end
    
    if x == 0 && y == 0
        theta = 0;
    end
    
    fprintf('Polar: Theta = %f, radius = %f\n', radius, theta);
    
    data.radius = radius;
    data.theta = theta;
end
