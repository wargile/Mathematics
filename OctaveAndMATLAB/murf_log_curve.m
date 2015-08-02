% Testing MuRF envelope pot curve
% http://en.wikipedia.org/wiki/Envelope_(mathematics)

%close all;

createfigure('MuRF curve 1');
subplot(1, 2, 1);
a = [1:0.1:40, 40:-0.1:20, 20:0.1:40, 40:-0.1:1];
plot(log(a), 'b')
hold on;
a = [1:0.1:40, 40:-0.1:20, 20:0.1:40, 40:-0.1:1];
plot(log10(a), 'r')
box off;
axis tight;
grid;
hold off;

max_elements = 100;
diff = (2.2 * 2) / max_elements;
subplot(1, 2, 2);
a = -2.2:diff:2.2; % NOTE: 2.2 = 11/5
b = sin(a.^2);
%b = sin(a.^2).* cos(a.^2);
plot((b + 1).*25);
box off;
axis tight;
grid;

max_pot_pos = 10;

diff_rise_1_to_4 = (5 - 1) / 40;
diff_rise_4_to_5 = (5 - 3) / 10;
diff_fall_1_to_4 = (4.5 - 0) / 40;
diff_fall_4_to_5 = (4.5 - 3) / 10;

% TEST START: Get current pot pos rise and fall percent
current_pot_pos = 4.25;
% Pos 0-4
if current_pot_pos <= 4
    p_pot_pos_data_rise = (5 - 1) / 4;
    p_pot_pos_data_fall = (4.5 - 0) / 4;
end
% Pos 4-5
if current_pot_pos > 4 && current_pot_pos <= 5 
    p_pot_pos_data_rise = (5 - 3) / 1;
    p_pot_pos_data_fall = (4.5 - 3) / 1;
end
% Pos 5-6
if current_pot_pos > 5 && current_pot_pos <= 6
    p_pot_pos_data_rise = (5 - 3) / 1;
    p_pot_pos_data_fall = (4.5 - 3) / 1;
end
% Pos 6-10
if current_pot_pos > 6
    p_pot_pos_data_rise = (5 - 1) / 4;
    p_pot_pos_data_fall = (4.5 - 0) / 4;
end
% TEST END: Get current pot pos rise and fall percent

% TODO: Subtract intervals from start positions to avoid doubles
p_pot_pos_data_rise = ...
    ([(1:diff_rise_1_to_4:5) ((5 - diff_rise_4_to_5):-diff_rise_4_to_5:3) ...
    ((3 + diff_rise_4_to_5):diff_rise_4_to_5:5) ...
    ((5 - diff_rise_1_to_4):-diff_rise_1_to_4:1)])
p_pot_pos_data_fall = ...
    ([(0:diff_fall_1_to_4:4.5) ((4.5 - diff_fall_4_to_5):-diff_fall_4_to_5:3) ...
    ((3 + diff_fall_4_to_5):diff_fall_4_to_5:4.5) ...
    ((4.5 - diff_fall_1_to_4):-diff_fall_1_to_4:0)])

rise_percent = (50 - (((5 - p_pot_pos_data_rise) * 50) / ...
    (max_pot_pos / 2)));
fall_percent = (50 - (((5 - p_pot_pos_data_fall) * 50) / ...
    (max_pot_pos / 2)));
%rise_percent = 50 - (([50:-1:1 1:50].^2) / 50);
%fall_percent = 50 - (([50:-1:1 1:50].^2) / 75);

createfigure('MuRF curve 2');
enhancefigure('MuRF envelope curve', 'Rate', 'Amplitude');
%subplot(1, 3, 3);
plot(rise_percent, 'bo-');
hold on;
plot(fall_percent, 'ro-');
hold off;
box off;
%set(gca, 'XTick', 1:11);
axis tight;
grid;

% CHECK THIS:
createfigure('MuRF curve 3');
enhancefigure('MuRF envelope curve', 'Rate', 'Amplitude');
max_elements = 10;
start1 = 5;
start2 = 4.75;
interval = (start1 - 2.2) / (max_elements / 2.0);
%interval2 = (start2 - 2.2) / (max_elements / 2.0);
interval2 = (start2 - 2.2) / (max_elements / 2.0);

a = 1 - cos(start1:-interval:2.2) * 4;
b = 1 - cos((2.2 + interval):interval:start1) * 4;

%c = 1 - cos(start2:-interval2:2.2) * 4;
%d = 1 - cos((2.2 + interval2):interval2:start2) * 4;
c = 1 - cos(start2:-interval2:2.2) * 4;
d = 1 - cos((2.2 + interval2):interval2:start2) * 4;

plot([c.*10 d.*10], 'ro-');
%plot([c d], 'ro-');
hold on;
plot([a.*10 b.*10], 'bo-');
%plot([a b], 'bo-');
box off;
hold off;

xticks = ones(1, 11);

for counter = 2:11
    xticks(counter) = xticks(counter - 1) + (max_elements / 10);
end

set(gca, 'XTick', xticks);
set(gca, 'YTick', [0 10 20 30 40 50]);
%set(gca, 'YTick', [0 1 2 3 4 5]);
grid;
