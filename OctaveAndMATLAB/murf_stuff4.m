function murf_stuff4(resolution = 100, pot_pos = 4.5, curve_peak = 3.5, ...
                     curve_multiplier_rise = 3.5, curve_multiplier_fall ...
                     = 4.5)

createfigure('MurF Stuff #4');
hold off;
clf;

subplot(2, 1, 1);
hold on;

% NOTE: Resolution needs to be an even number
volt_ref = 5.0;
max_pot_value = 10;
curve_end = max_pot_value / 2.0;
curve_dip_end_rise = 1.2;
curve_dip_end_fall = 1.2; %1.05;
multiplier = resolution / max_pot_value;
interval = max_pot_value / resolution;
interval_drop_rise = (curve_peak - curve_dip_end_rise) / ((curve_peak - curve_end) ...
                                                * (resolution / max_pot_value))
interval_drop_fall = (curve_peak - curve_dip_end_fall) / ((curve_peak - curve_end) ...
                                                * (resolution / max_pot_value))


% Plot rise curves
plot(realpow(0:interval:curve_peak, 2) * curve_multiplier_rise, 'r.-');
plot(realpow(0:interval:curve_peak, 2) * curve_multiplier_fall, 'b.-');

% Plot fall curves
plot((curve_peak * multiplier + 1):(curve_end * multiplier + 1), ...
     realpow(curve_peak:interval_drop_rise:curve_dip_end_rise, 2) * curve_multiplier_rise, 'r.-');

plot((curve_peak * multiplier + 1):(curve_end * multiplier + 1), ...
     realpow(curve_peak:interval_drop_fall:curve_dip_end_fall, 2) * curve_multiplier_fall, 'b.-');


% Plot rise and fall pos in curve
if pot_pos <= curve_peak
    percent_rise_at_pot_pos = realpow(interval * (pot_pos * multiplier), 2) * ...
        curve_multiplier_rise
    percent_fall_at_pot_pos = realpow(interval * (pot_pos * multiplier), 2) * ...
        curve_multiplier_fall
else
    percent_rise_at_pot_pos = ...
        realpow(curve_peak + (interval_drop_rise * ((pot_pos - curve_peak) * multiplier)), ...
                2) * curve_multiplier_rise
    percent_fall_at_pot_pos = ...
        realpow(curve_peak + (interval_drop_fall * ((pot_pos - curve_peak) * multiplier)), ...
                2) * curve_multiplier_fall
end

% Plot percent rise at pot_pos
plot(pot_pos * multiplier + 1, percent_rise_at_pot_pos, 'b*')
plot(pot_pos * multiplier + 1, percent_fall_at_pot_pos, 'r*');

xlim([0, resolution / 2 + 1]);
box off;
grid minor;
hold off;
enhancefigure('MuRF Stuff #4', 'Resolution ticks', ['Rise and fall ' ...
                    'percents (' num2str(percent_rise_at_pot_pos), ', ' ...
                    num2str(percent_fall_at_pot_pos), ')']);


%% BETTER CODE! Get rise and fall curve to meet at same dip pos:

subplot(2, 1, 2);
hold on;
peak_pos = curve_peak % From input param
curve_peak_rise = 7
curve_peak_fall = 10
curve_dip = 1.5
elements = ceil(peak_pos * (resolution / max_pot_value))
% IMPORTANT! ceil above

% Rise curve before curve peak
curve_peak = curve_peak_rise
curve_end = curve_peak
interval = sqrt(curve_end) / elements
plot(realpow(0:interval:sqrt(curve_end), 2), 'r.-')

% Fall curve before curve peak
curve_peak = curve_peak_fall
curve_end = curve_peak
interval = sqrt(curve_end) / elements
plot(realpow(0:interval:sqrt(curve_end), 2), 'b.-')

elements = ceil(((max_pot_value / 2.0) - peak_pos) * (resolution / ...
                                                 max_pot_value))
% IMPORTANT! ceil above

% Rise curve after curve peak
curve_peak = curve_peak_rise
curve_end = curve_dip
interval = (sqrt(curve_peak) - sqrt(curve_end)) / elements
plot(ceil(peak_pos * (resolution / max_pot_value) + 1): ...
     ceil(peak_pos * (resolution / max_pot_value) + elements + 1), ...
     realpow(sqrt(curve_peak):-interval:sqrt(curve_end), 2), 'r.-')

% Fall curve after curve peak
curve_peak = curve_peak_fall
curve_end = curve_dip
interval = (sqrt(curve_peak) - sqrt(curve_end)) / elements
plot(ceil(peak_pos * (resolution / max_pot_value) + 1): ...
     ceil(peak_pos * (resolution / max_pot_value) + elements + 1), ...
     realpow(sqrt(curve_peak):-interval:sqrt(curve_end), 2), 'b.-')


grid
xlim([0, (resolution / 2.0) + 2])
ylim([0, curve_peak + 1])
box off
hold off;

pot_pos = 4.2

if pot_pos <= peak_pos
    %percent_rise = interval * (pot_pos * (resolution / max_pot_value))
else
    % Do calc
end

    
