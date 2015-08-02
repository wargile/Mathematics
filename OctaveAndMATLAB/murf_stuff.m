function murf_stuff(max_elements = 100, pot_pos_org = 4.5, ...
                    percent_rise = 55)
% Testing more MuRF calc stuff in 2013...

%max_elements = 100;
%pot_pos_org = 4.5;
volt_ref = 5;

%% Create subplot and find pot pos value for rise/fall volt curve

num_curve_elements = floor(max_elements * percent_rise / 100.0) - 1
max_pot_pos = 10;
pot_pos = floor(pot_pos_org * (max_elements / max_pot_pos))

if (pot_pos <= num_curve_elements)
    start_pos = 1
else
    start_pos = pot_pos - num_curve_elements + 1
end

volt_per_step_rise = sqrt(volt_ref) / num_curve_elements;

if pot_pos - percent_rise < 0
    volt_cutoff_rise = abs(pot_pos - num_curve_elements) * volt_per_step_rise
else
    volt_cutoff_rise = 0
end

createfigure('MuRF Stuff 2013');
clf;
subplot(2, 1, 1);

% Plot without cutoff
plot(start_pos:num_curve_elements + start_pos, ...
     realpow(0:volt_per_step_rise:sqrt(volt_ref), 2), 'b.');
hold on;

% Plot with cutoff
%num_curve_elements + ...
%     start_pos
%realpow(volt_cutoff_rise:volt_per_step_rise:sqrt(volt_ref), 2)
%plot((num_curve_elements - pot_pos + 1):num_curve_elements + 1, ...
%     realpow(volt_cutoff_rise:volt_per_step_rise:sqrt(volt_ref), 2), 'mo');
%plot((num_curve_elements - pot_pos + start_pos):num_curve_elements + ...
%     start_pos, ...
%     realpow(volt_cutoff_rise:volt_per_step_rise:sqrt(volt_ref), 2), 'mo');

% Plot cutoff at zero pos
plot(realpow(volt_cutoff_rise:volt_per_step_rise:sqrt(volt_ref), 2), 'ro');

% Find and plot current pot pos
volt_value_at_pot_pos = ...
    realpow(volt_cutoff_rise + (volt_per_step_rise * pot_pos), 2)

plot(abs(pot_pos - num_curve_elements) + pot_pos + 1, ...
     volt_value_at_pot_pos, 'm*');

ylim([-0.5, volt_ref + 0.5]);
box off;
grid;
enhancefigure('MuRF Stuff 2013', 'Timer ticks', 'Volt');


%% Create subplot and find pot pos value for rise/fall percent curve

subplot(2, 1, 2);
% NOTE: Using same values for curve below and above max_pot_pos / 2
inc_rise = 35;
inc_fall = 28;
start_rise = 4.2;
end_rise = -0.8;
start_fall = 4.7;
end_fall = -0.705;
interval_rise = ((start_rise + abs(end_rise)) / ...
                 (max_elements / 2)) * -1;
interval_fall = ((start_fall + abs(end_fall)) / ...
                 (max_elements / 2)) * -1;

% Plot percent rise
plot((sin(start_rise:interval_rise:end_rise) + 1) * ...
      inc_rise, 'r.-');
hold on;

% Plot percent fall
plot((sin(start_fall:interval_fall:end_fall) + 1) * ...
      inc_fall, 'b.-');

% START CODE TO FIND PERCENT_RISE AND PERCENT_FALL
if pot_pos_org < 5
    pot_pos_temp = pot_pos_org;
    pos = ceil(pot_pos_org * (max_elements / max_pot_pos) + 1);
else
    pot_pos_temp = max_pot_pos - pot_pos_org;
    pos = ceil((max_pot_pos - pot_pos_org) * (max_elements / max_pot_pos) + 1);
end

pot_pos_intervals_rise = ((start_rise + abs(end_rise)) * ...
                          pot_pos_temp) / (max_pot_pos / 2.0);
        
rise_percent_at_pot_pos = (sin(start_rise - ...
                               pot_pos_intervals_rise) + 1) * inc_rise
        
pot_pos_intervals_fall = ((start_fall + abs(end_fall)) * ...
                          pot_pos_temp) / (max_pot_pos / 2.0);

fall_percent_at_pot_pos = (sin(start_fall - ...
                               pot_pos_intervals_fall) + 1) * inc_fall
% END CODE TO FIND PERCENT_RISE AND PERCENT_FALL

% Plot pos
plot(pos, rise_percent_at_pot_pos, 'bo');
plot(pos, fall_percent_at_pot_pos, 'ro');

grid;
enhancefigure('', 'Timer ticks', 'Percent rise/fall');
box off;
xlim([0, (max_elements / 2.0) + 2]);
hold off;

