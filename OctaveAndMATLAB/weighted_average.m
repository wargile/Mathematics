% Demo of weighted average (= weighted mean)
% http://www.ehow.com/how_5328019_calculate-weighted-average.html
% http://www.investopedia.com/terms/w/weightedaverage.asp

% See: C:\coding\R\Coursera\IntroductionToDataScience\Week 6\Videos
%      Video 6-10-10 Ensembles, Bagging and Boosting

% ic<n>: income category, ic<n>_h: number of <income category> households
ic1 = 250000;
ic1_h = 15;
ic2 = 450000;
ic2_h = 4;
ic3 = 790000;
ic3_h = 1;

the_mean = (ic1 + ic2 + ic3) / 3;
disp('Mean:');
disp(the_mean);
%mean([income_category1, income_category2, income_category3])

weighted_avg = ((ic1_h * ic1) + (ic2_h * ic2) + (ic3_h * ic3)) / ...
    (ic1_h + ic2_h + ic3_h);
disp('Weighted average:');
disp(weighted_avg);

% Example:
% R> v <- c(3,1,2,1,4,10,2,2,3,5,6,7,4,4,10)
% R> table(v)
% R> sum(as.integer(names(table(v))) * table(v)) / sum(table(v))
v = [3,1,2,1,4,10,2,2,3,5,6,7,4,4,10];
h = hist(v);
wa = sum((sort(unique(v)) .* h(h > 0))) / sum(h);
disp(wa);
% Try the household example above
v = [repmat(250000, 1, 15), repmat(450000, 1, 4), repmat(790000, 1, 1)];
h = hist(v);
wa = sum((sort(unique(v)) .* h(h > 0))) / sum(h);
disp(wa);

% Compute Gini impurity for a set of items:
% http://en.wikipedia.org/wiki/Decision_tree_learning#Gini_impurity
% http://www.mathworks.se/help/stats/
%   compactclassificationensemble.predictorimportance.html
% http://www.uni-weimar.de/medien/webis/teaching/
%   lecturenotes/machine-learning/unit-en-decision-trees-impurity.pdf
v = [3,1,2,1,4,10,2,2,3,5,6,7,4,4,10];
h = hist(v);
h = h(h > 0);

disp(1 - sum(pow2(h))); % TODO: These should be the same...
disp(sum(h) - sum(pow2(h))); % TODO: These should be the same...
disp(sum(h .* (1 - h))); % TODO: These should be the same...
