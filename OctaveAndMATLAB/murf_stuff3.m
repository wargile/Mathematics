function murf_stuff3(resolution = 100, pot_pos = 4.5)

% NOTE: Resolution needs to be an even number
volt_ref = 5.0;
max_pot_value = 10;
parabola_start = -1;
parabola_end = 0.8;
parabola_highvalue = 80;
parabola_lowvalue = 50;
power = 2.1;
intervals = (parabola_end - parabola_start) / resolution * 2.0;

% Get peak pos in resolution
peak_pos_in_resolution = (realpow(pot_pos, 2) / (max_pot_value / 2.0)) * ...
    (resolution / max_pot_value)

% Get parabola value at pot_pos
parabola_lowvalue_at_pot_pos = parabola_lowvalue - ...
    realpow(parabola_start + (intervals * peak_pos_in_resolution), 2) * ...
    parabola_lowvalue

parabola_highvalue_at_pot_pos = parabola_highvalue - ...
    realpow(parabola_start + (intervals * peak_pos_in_resolution), 2) * ...
    parabola_highvalue

clf;

subplot(2, 1, 1);
% Plot parabola
%plot(realpow(parabola_start:intervals:parabola_end, 2), 'b.-');
hold on;

% Plot parabola upside down
plot(parabola_lowvalue - ...
     (realpow(parabola_start:intervals:parabola_end, 2) * parabola_lowvalue), ...
     'r.-');

% Plot a taller parabola upside down
plot(parabola_highvalue - ...
     (realpow(parabola_start:intervals:parabola_end, 2) * parabola_highvalue), ...
     'c.-');

plot(peak_pos_in_resolution + 1, parabola_lowvalue_at_pot_pos, 'mo');

plot(peak_pos_in_resolution + 1, parabola_highvalue_at_pot_pos, 'mo');

grid
ylim([0, parabola_highvalue + 2]);
xlim([0, resolution / 2.0 + 1]);
box off;

rise_elements = parabola_lowvalue_at_pot_pos
fall_elements = parabola_highvalue_at_pot_pos

subplot(2, 1, 2);
plot(realpow(0:(sqrt(volt_ref) / rise_elements):sqrt(volt_ref), 2), 'b.-');
hold on;
plot(realpow(sqrt(volt_ref):-(sqrt(volt_ref) / fall_elements):0, 2), 'r.-');
box off;
grid;
hold off;
