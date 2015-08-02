% Just one more MuRF curve calculation test...

CURRENT_POT_POS = 1.5;

curve_start = -pi / 2;
curve_stop = pi + 0.5;

curve_start_fall = (-pi / 2) + 1;
curve_stop_fall = pi + 0.5;

resolution = 50; % Half of complete run
pot_pos = 10;

hold off;
clf;

plot(sin(curve_start:((curve_stop + abs(curve_start))/resolution):curve_stop) ...
     * 30 + 30, 'bo');

hold on;

plot(sin(curve_start_fall:((curve_stop_fall + abs(curve_start_fall))/resolution):curve_stop_fall) ...
     * 30 + 30, 'ro');


cur_pos_x = CURRENT_POT_POS * ((resolution * 2) / pot_pos);
cur_pos = curve_start + ((curve_stop + abs(curve_start))/resolution) * ...
          cur_pos_x; 

hold on;
percent_rise = (sin(cur_pos) * 30 + 30);

plot(cur_pos_x + 1, percent_rise, 'r*');

grid;

curve_pos = (sin(cur_pos) - sin(cur_pos + 0.0001)) * -1;

if (curve_pos < 0)
    fprintf('Position is in MIDDLE part of curve.\n');
else
    fprintf('Position is in LEFT part of curve.\n');
end

fprintf('Percent rise: %.2f, curve_pos difference: %f\n', percent_rise, ...
        curve_pos);

max_resolution = resolution * 2;
