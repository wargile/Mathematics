function [cutoff_volt, cutoff_steps] = ...
    murf_getcutoffvolt(resolution, peak, percent_fall)
    % Better routine for finding cutoff volt
    volt_ref = 5.0;
    cutoff_steps = 0;
    cutoff_volt = 0;

    if (nargin ~= 3)
        error('Usage: murf_getcutoffvolt(resolution, peak, percent_fall)');
    end
    
    if (peak >= resolution)
        error('Resolution must be larger than peak value.');
    end

    volt_pr_step_fall = volt_ref / percent_fall;
    
    if (resolution - peak - percent_fall < 0)
        cutoff_steps = abs(resolution - peak - percent_fall);
        cutoff_volt = (cutoff_steps + 1) * volt_pr_step_fall;
        
        plot(volt_ref:-volt_pr_step_fall:cutoff_volt, 'b.-');
        hold on;
        plot((volt_ref:-volt_pr_step_fall:cutoff_volt).^2 / volt_ref, 'co-')
        grid minor;
        
        plot(resolution - peak, cutoff_volt, 'r*')
        cutoff_volt = cutoff_volt^2 / volt_ref;
        plot(resolution - peak, cutoff_volt, 'r*')
        
        ylim([-0.5 volt_ref + 0.5]);
        xlim([0, resolution - peak + 1]);
        hold off;
        box off;
    else
        disp('Cutoff volt is 0, plot not created.');
    end

