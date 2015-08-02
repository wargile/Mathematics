function murfy(resolution, pot_pos)
% MuRF code -- Copyright (C) Terje B. 2012
%
% - At pot_pos change: Keep old pot_pos "locked" until curve is done
% - At resolution change: Update resolution pos/grid immediately
    
    max_pot_pos = 10.0;
    volt_ref = 5.0;

    createfigure('MuRF DAC Volt Curve');

    fprintf('------------------\n');

    pot_pos_org = pot_pos;

    if (pot_pos > max_pot_pos / 2.0)
        pot_pos = max_pot_pos - pot_pos;
    end

    % Get rise and fall steps for pot_pos
    [percent_rise, percent_fall] = create_rise_fall_percent_curve(pot_pos)

    % Convert the percents to number of steps in resolution
    percent_rise = (percent_rise * resolution) / 100.0
    percent_fall = (percent_fall * resolution) / 100.0


    %% Get the cutoff volt for the fall curve
    cutoff = get_cutoff_volt_for_fall_curve(resolution, volt_ref, max_pot_pos, ...
                                                    pot_pos, percent_fall, ...
                                                    percent_rise)

    %% Get peak position for current resolution
    peak = get_peak_pos_in_resolution(resolution, volt_ref, max_pot_pos, ...
                                                  pot_pos)


    %% Plot the complete volt curve. TODO: Pot_pos > max_pot_pos / 2
    % START Plot the full volt curve. TODO: Put in function
    if (cutoff > 0)
        start_pos = 0
    else
        start_pos = peak - percent_rise
    
        if (start_pos < 0)
            start_pos = 0;
        end
    end

    curve = zeros(1, resolution + 1);

    if (percent_rise == 0)
        volt_pr_step_rise = volt_ref; % (volt_ref - cutoff) / 1
        peak = 0.0001; % 1; % TODO: Optimal solution for div/0 issue?
    else
        volt_pr_step_rise = (volt_ref - cutoff) / (peak - start_pos)
    end

    volt_pr_step_fall = volt_ref / percent_fall

    if (volt_pr_step_fall < volt_ref)
        volt_pr_step_fall = volt_ref;
    end
    
    if (volt_pr_step_rise < volt_ref)
        volt_pr_step_rise = volt_ref;
    end
    
    for counter = 1:resolution + 1
        if counter < max_pot_pos / 2.0
            resolution_pos = counter * (resolution / max_pot_pos);
        else
            resolution_pos = (max_pot_pos - pot_pos_org) * (resolution / ...
                                                        max_pot_pos);
        end
        
        curve(counter) = get_volt_value(counter, ...
                                        peak, cutoff, percent_fall, ...
                                        percent_rise, start_pos, volt_ref);
    end
    % END Plot the full volt curve. Is put in function get_volt_value()


    %% Testing volt function
    if pot_pos_org < max_pot_pos / 2.0
        resolution_pos = pot_pos_org * (resolution / max_pot_pos);
    else
        resolution_pos = (max_pot_pos - pot_pos_org) * (resolution / ...
                                                        max_pot_pos);
    end
    
    volt = get_volt_value(resolution_pos, peak, cutoff, percent_fall, ...
                                        percent_rise, start_pos, volt_ref)
    
    subplot(2,1,1);
    
    if (pot_pos_org <= max_pot_pos / 2.0)
        plot(curve, 'c');
        hold on;
        stairs(curve, 'b');
    else
        plot(fliplr(curve), 'c');
        hold on;
        stairs(fliplr(curve), 'b');
    end

    plot(pot_pos_org * (resolution / max_pot_pos), volt, 'r*');

    hold off;
    axis tight;
    ylim([-0.6 volt_ref + 0.5]);
    box off;
    grid;

    enhancefigure(['DAC Volt Curve for resolution ', num2str(resolution), ...
                   ' and pot pos ', num2str(pot_pos_org)], ...
                  'Resolution steps', 'DAC Volt Value');


    %% Plot the volt curves
    %subplot(4,1,2);
    %volt_pr_step_rise = (volt_ref - cutoff) / percent_rise;
    %volt_pr_step_fall = (volt_ref - cutoff) / percent_fall;
    %plot((cutoff:volt_pr_step_rise:volt_ref).^2 / volt_ref, 'b.-');
    %hold on;
    %plot((volt_ref:-volt_pr_step_fall:cutoff).^2 / volt_ref, 'r.-');
    %hold off;
    %axis tight;
    %ylim([0 volt_ref]);
    %grid;
    
    %subplot(4,1,3);
    %curve_rise = cutoff:volt_pr_step_rise:volt_ref;
    %curve_fall = (volt_ref - volt_pr_step_fall):-volt_pr_step_fall:cutoff;
    %plot([curve_rise curve_fall].^2 / volt_ref, 'b.-');
    %axis tight;
    %ylim([0 volt_ref]);
    %grid;
    

    %% Calculate and plot the rise and fall percent curves
    rcurve = zeros(1, volt_ref / 0.1);
    fcurve = zeros(1, volt_ref / 0.1);
    counter = 1;
    
    for pos = 0:0.1:volt_ref
        [rp, fp] = create_rise_fall_percent_curve(pos);
        rcurve(counter) = rp;
        fcurve(counter) = fp;
        counter = counter + 1;
    end
    
    subplot(2,1,2);
    plot(rcurve, 'b.-');
    hold on;
    plot(fcurve, 'r.-');
    hold off;
    axis tight;
    box off;
    grid;
    

% -- Functions start --

%% Function to calculate and plot the rise and fall percent curves
function[rp, fp] = create_rise_fall_percent_curve(pot_pos)
    curve_break = 4.0; % TODO: Percent calc
    pos_rise = pot_pos;
    pos_fall = pot_pos;
    
    if (pot_pos > curve_break)
        dip_rise = 1.6; % End of curve dip
        dip_fall = 1.02;
        
        advance = abs(curve_break - pot_pos);
        ratio_rise = (curve_break - dip_rise);
        pos_rise = curve_break - (advance * ratio_rise);
        ratio_fall = (curve_break - dip_fall); % / 1.0; % /1 = interval 4 to 5
        pos_fall = curve_break - (advance * ratio_fall);
    end
    
    rp = (pos_rise * 1.9)^2;
    fp = (pos_fall * 2.8)^2 + 1; % 10


%% Function to get the curve peak pos in resolution for pot_pos
function [pos_in_resolution] = ...
    get_peak_pos_in_resolution(resolution, volt_ref, max_pot_pos, pot_pos)
    pos_in_resolution = (pot_pos^2 / (max_pot_pos / 2.0)) * (resolution / max_pot_pos);


%% Function to get the cutoff volt on fall curve
function [cutoff] = ...
    get_cutoff_volt_for_fall_curve(resolution, volt_ref, max_pot_pos, ...
                                               pot_pos, percent_fall, percent_rise)

    volt_pr_step_fall = volt_ref / percent_fall;
    
    peak_pos = get_peak_pos_in_resolution(resolution, volt_ref, max_pot_pos, ...
                                                      pot_pos);
    
    if (resolution - peak_pos - percent_fall < 0)
        cutoff_steps = abs(resolution - peak_pos - percent_fall);
        cutoff = cutoff_steps * volt_pr_step_fall;
    else
        cutoff = 0;
    end
    


%% Function to get the volt_value for a pot_pos 
function [volt] = get_volt_value(resolution_pos, peak, cutoff, percent_fall, ...
                                               percent_rise, start_pos, volt_ref)
    
    if (percent_rise == 0)
        volt_pr_step_rise = volt_ref; % (volt_ref - cutoff) / 1.0
        peak = 0.0001; % TODO: Optimal solution for div/0 issue?
    else
        volt_pr_step_rise = (volt_ref - cutoff) / (peak - start_pos)
    end
    
    volt_pr_step_fall = volt_ref / percent_fall
    
    if (resolution_pos < start_pos)
        volt = 0;
    else
        if (resolution_pos < peak)
            volt = (cutoff + (volt_pr_step_rise * (resolution_pos - ...
                                                   start_pos)))^2 / volt_ref;
        else
            if (resolution_pos <= peak + percent_fall)
                volt = (volt_ref - (volt_pr_step_fall * (resolution_pos - ...
                                                         peak)))^2 ...
                       / volt_ref;
            else
                volt = 0;
            end
            
            % Ensure DAC volt = volt_ref at peak pos
            if (resolution_pos == round(peak) && volt < volt_ref)
                volt = volt_ref;
            end
        end
    end
