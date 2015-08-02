function murf_stuff4(max_elements = 100, pot_pos_org = 4.5, ...
                    percent_rise = 55.0, percent_fall = 65.0)
% Testing more MuRF calc stuff in 2013! This looks tight so far...

volt_ref = 5.0;
max_pot_pos = 10;
createfigure('MuRF Stuff 2013');

%% Create subplot and find pot pos value for rise/fall percent curve

subplot(2, 1, 1);
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
plot(pos, rise_percent_at_pot_pos, 'ro');
plot(pos, fall_percent_at_pot_pos, 'bo');

grid;
enhancefigure('MuRF Stuff 2013', 'Timer ticks', 'Percent rise/fall');
box off;
xlim([0, (max_elements / 2.0) + 2]);
hold off;


%% Create subplot and find pot pos value for rise/fall volt curve

if pot_pos_org > 5
    percent_rise = rise_percent_at_pot_pos
    percent_fall = fall_percent_at_pot_pos
    %percent_rise = max_elements * rise_percent_at_pot_pos / 100.0
    %percent_fall = max_elements * fall_percent_at_pot_pos / 100.0
else
    percent_rise = fall_percent_at_pot_pos
    percent_fall = rise_percent_at_pot_pos
    %percent_rise = max_elements * fall_percent_at_pot_pos / 100.0
    %percent_fall = max_elements * rise_percent_at_pot_pos / 100.0
end

num_curve_elements_rise = floor(max_elements * percent_rise / 100.0)
if num_curve_elements_rise <= 0 % Avoid DIV/0 below
    num_curve_elements_rise = 1
end

num_curve_elements_fall = floor(max_elements * percent_fall / 100.0)
if num_curve_elements_fall <= 0 % Avoid DIV/0 below
    num_curve_elements_fall = 1
end

% NOTE: pot_pos_tt below is pot_pos in relation to max_elements
pot_pos_tt = floor(pot_pos_org * (max_elements / max_pot_pos))

% Find current pos in resolution
%pot_pos_tt = (realpow(pot_pos_org, 2) / (max_pot_pos / 2.0)) * ...
%    (max_elements / max_pot_pos)

volt_per_step_rise = sqrt(volt_ref) / num_curve_elements_rise

% TODO: Opposite for pot_pos > 5
if num_curve_elements_rise > pot_pos_tt
    volt_cutoff = abs(pot_pos_tt - num_curve_elements_rise) * volt_per_step_rise
else
    volt_cutoff = 0
end

if (volt_cutoff > 0)
    start_pos = 1
else
    start_pos = pot_pos_tt - num_curve_elements_rise + 1
end

if volt_cutoff > 0
    volt_per_step_fall = sqrt(volt_ref - volt_cutoff) / ...
        num_curve_elements_fall
else
    volt_per_step_fall = sqrt(volt_ref) / num_curve_elements_fall
end

subplot(2, 1, 2);
hold off;

% Plot with cutoff at zero pos
plot(realpow(volt_cutoff:volt_per_step_rise:sqrt(volt_ref), ...
             2), 'ro');

the_volt_array = zeros(1, max_elements);

% Plot with cutoff at start_pos for curve
% NOTE: This is the PIC timer tick loop!
% Rise curve
for pic_timer_tick = 1:floor(pot_pos_tt) + 1
    if pic_timer_tick < start_pos
        the_volt_array(pic_timer_tick) = 0;
    else
        the_volt_array(pic_timer_tick) = ...
            realpow(volt_cutoff + (volt_per_step_rise ...
                                   * (pic_timer_tick - start_pos)), 2);
    end
end
% Fall curve
for pic_timer_tick = floor(pot_pos_tt) + 1:max_elements
    temp_volt = sqrt(volt_ref) - (volt_per_step_fall ...
                               * (pic_timer_tick - (pot_pos_tt + 1)));
    
    if temp_volt > 0
        the_volt_array(pic_timer_tick) = realpow(temp_volt, 2);
    else
        the_volt_array(pic_timer_tick) = 0;
    end
end

hold on;
plot(the_volt_array, 'b.-');
%ylim([-0.1, volt_ref + 0.1]);
xlim([0, max_elements + 1]);
box off;
grid minor;
enhancefigure('', 'Timer ticks', 'Volt');

