function ret = quantizer(minvolt, maxvolt, triangle)
%QUANTIZER Quantizes a value range
%
%   QUANTIZER quantizes a volt value range to nearest semitones.
%   Choose triangle (default) or sine curve
%
%   Params: minvolt, maxvolt, triangle [true|false]

    if nargin < 2
        error(['Usage: QUANTIZER(<minvolt>, <maxvolt>, ', ...
            '[triangle (true|false)])']);
    end
    
    if nargin < 3
        triangle = false;
    end
    
    if nargin < 4
        offset = 0;
    end
    
    if isnumeric(minvolt) == false || isnumeric(maxvolt) == false
        error('Error in input value(s).');
    end
    
    if minvolt >= maxvolt
        error('Min volt value must be smaller than max volt value');
    end
    
    if maxvolt < .005
        error('Max volt value can not be less than 0.005');
    end

    VOLT_REF = 5.0;
    DAC_12_BIT = 4095; % 0xfff;
    VOLT_PR_NOTE = 0.0833334;

    MIN_VOLT = minvolt;
    MAX_VOLT = maxvolt;
    FIG_NAME = 'Quantizer';
    
    if triangle % Create a triangle value range
        v = (MIN_VOLT:0.05:MAX_VOLT);
        volt_range = [v fliplr(v)]; % Merge with the reversed range
    else % Create a sine value range
        % volt_range = sin(MIN_VOLT:0.005:MAX_VOLT) * VOLT_REF;
        volt_range = (sin(-pi:0.005:pi) * ((MAX_VOLT - MIN_VOLT) / 2.0)) + ...
            ((MAX_VOLT - MIN_VOLT) / 2.0) + MIN_VOLT;
    end
    
    quantized = volt_range; % Dimension the result array
    quantized_volt_range = volt_range; % Dimension the result array

    %% Quantize volt curve
    
    for a = 1:length(volt_range)
       quantized(a) = ceil(volt_range(a) / VOLT_PR_NOTE) * ...
           (DAC_12_BIT / (VOLT_REF / VOLT_PR_NOTE));
       quantized_volt_range(a) = floor((volt_range(a) / VOLT_PR_NOTE) * ...
           (DAC_12_BIT / (VOLT_REF / VOLT_PR_NOTE)));
    end

    %% Plot graphs
    
    % Create a new named figure
    createfigure(FIG_NAME, true);
    clf; % Get rid of previous plot formatting (clf reset Octave error)
    
    % TIP: Fill whole plot window
    % axes('position', [0, 0, 1, 1]);

    h1 = subplot(2, 1, 1);
    h_plot = plot(volt_range, 'b-');
 	
    set(gca, 'FontSize', 8);
    set(gca,'Color', [0.95 0.96 0.95])
    %h_legend = legend('Quantized value', 'Volt range');
    %if h_legend > 0
    %    set(h_legend, 'FontSize', 8);
    %    set(h_legend, 'Color', [1 1 1])
    %end
    set(gca,'Color', [1 1 1])
    %set(gca, 'ytick', [floor(min(volt_range)), ceil(max(volt_range))]);
    grid;
    ylabel('Volt value');
    %xlabel('Volt data');
    set(gca, 'XColor', [.2 .2 .2], 'YColor', [.2 .2 .2]);
    
    if triangle == true
        legend('Volt data', 'Location', 'South');
    else
        legend('Volt data', 'Location', 'SouthEast');
    end
    
    %set(gca, 'XTick', ...
    %		 linspace(MIN_VOLT, MAX_VOLT, 5));
    box off;
    axis tight;

    if ismatlab()
        title('\it{Volt output}', 'FontWeight', 'bold', ...
            'FontSize', 10)
    else
        title('Volt output', 'FontWeight', 'bold', ...
            'FontSize', 10)        
    end
    
    hold off;
    h2 = subplot(2, 1, 2);
    h_plot = plot(quantized, 'b-');
    
    if ismatlab()
      set(h_plot, 'LineSmoothing', 'on');
    end
    
    hold on;
    h_plot = plot(quantized_volt_range, 'c-');

    if ismatlab()
      set(h_plot, 'LineSmoothing', 'on');
    end
    
    set(gca, 'FontSize', 8);
    set(gca, 'Color', [0.95 0.96 0.95])
    
    if triangle == true
        legend('Quantized DAC data', 'Base curve', 'Location', ...
               'South');
    else
        legend('Quantized DAC data', 'Base curve', 'Location', ...
               'SouthEast');
    end
    
    set(gca, 'Color', [1 1 1])
    xlabel(['Volt data (min DAC value: ' num2str(min(quantized)) ...
            ', max DAC value: ' num2str(max(quantized)) ')']);
    ylabel('DAC value');
    set(gca, 'XColor', [.2 .2 .2], 'YColor', [.2 .2 .2]);
    set(gca, 'YGrid', 'on')
    set(gca, 'XGrid', 'off')
    
    set(h1, 'YLim', [min(volt_range) - .1, max(volt_range) + .1]);
    axis tight;
    set(h2, 'YLim', [min(quantized_volt_range) - 100, ...
                     max(quantized_volt_range) + 100]);
    
    box off;
    
    if ismatlab()
      shading interp;
      title('\it{Quantized DAC output}', 'FontWeight', ...
        'bold', 'FontSize', 10);
    else
      title('Quantized DAC output', 'FontWeight', ...
        'bold', 'FontSize', 10);
    end

    disp('Quantized output sent to GnuPlot!');
    
    %% Return data to caller
    
    ret.quantized = quantized;
    ret.volt_range = volt_range;
end
