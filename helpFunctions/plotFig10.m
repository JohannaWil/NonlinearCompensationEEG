function plotFig10(config,data)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 10\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 10\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

names = data.folderNames;
nSubs = length(names);
nConditions = 2;            % NRon and NRoff
alpha = 0.05;               % Significance level

% Separate correct (1) and incorrect (0) answers data for each
% subject s and condition (NRon and NRoff)
dataON = cell(1, nSubs);
dataOFF = cell(1, nSubs);
for s = 1:nSubs
    dataON{s} = data.data.(names{s}).NRon(:,3)';
    dataOFF{s} = data.data.(names{s}).NRoff(:,3)';
end


% Initialize arrays to store data
Subject = [];
Condition = [];
Correct = [];
nTrials = 0; % Initiate number of trials
for s = 1:nSubs
    nTrialsON = length(dataON{s});      % Number of trials for subject s with NRon
    nTrialsOFF = length(dataOFF{s});    % Number of trials for subject s with NRoff

    if nTrials == 0 && nTrialsON == nTrialsOFF
        nTrials = nTrialsON;
    end

    Subject = [Subject; repmat(s, nTrialsON + nTrialsOFF, 1)];
    Condition = [Condition; ones(nTrialsOFF, 1); 2 * ones(nTrialsON, 1)];
    Correct = [Correct; dataOFF{s}';dataON{s}'];
end

clear nTrialsON nTrialsOFF dataON dataOFF

% Create a table for the data
dataAll = table(Subject, Condition, Correct, 'VariableNames', {'Subject', 'Condition', 'Correct'});

% Convert Condition to categorical
dataAll.Condition = categorical(dataAll.Condition);

% Calculate percentage of correct responses per subject and condition
groupedData = varfun(@mean, dataAll, 'GroupingVariables', {'Subject', 'Condition'}, 'InputVariables', 'Correct');
groupedData.Properties.VariableNames{'mean_Correct'} = 'PercentageCorrect';
%groupedData.PercentageCorrect = groupedData.PercentageCorrect;

% Convert 'Condition' to categorical if not already
groupedData.Condition = categorical(groupedData.Condition);

% Compute group (grand-average ± SEM) performance
groupStats = varfun(@mean, groupedData, 'GroupingVariables', 'Condition', 'InputVariables', 'PercentageCorrect');
groupStats.Properties.VariableNames{'mean_PercentageCorrect'} = 'GroupMean';

% Compute standard error of the mean (SEM)
groupStd = varfun(@std, groupedData, 'GroupingVariables', 'Condition', 'InputVariables', 'PercentageCorrect');
groupStd.Properties.VariableNames{'std_PercentageCorrect'} = 'GroupStd';

% Compute the number of observations per condition
groupCounts = varfun(@numel, groupedData, 'GroupingVariables', 'Condition', 'InputVariables', 'PercentageCorrect');

% Compute SEM: SEM = Std / sqrt(Number of Observations)
groupStats.SE = groupStd.GroupStd ./ sqrt(groupCounts.GroupCount);

% Get unique subjects and conditions
uniqueSubjects = unique(groupedData.Subject);       % Get unique subjects
uniqueConditions = unique(groupedData.Condition);   % Get unique conditions


%% Compute p-value for the difference between NRoff and NRon

% Extract the average percentage (over trials) for each subject and each
% condition (NRoff and NRon)
correctOFF = groupedData.PercentageCorrect(groupedData.Condition == uniqueConditions(1));
correctON = groupedData.PercentageCorrect(groupedData.Condition == uniqueConditions(2));

% Perform a paired two-sample t-test
[h, pValueDiff, ~, stats] = ttest(correctOFF,correctON);

% Statistically significant classification performance
% Compute the statistically significant threshold (St)
success_threshold = binoinv(1 - alpha, nSubs, 1/nConditions);   % Binomial inverse cumulative distribution

% Compute the percentage score threshold
chanceLevel = (success_threshold) / nSubs;  

% Display results
fprintf('Statistically significant threshold score: %.3f%%\n', chanceLevel*100);
fprintf('Grand average ± standard deviation (%%):\n');
fprintf('\tNRoff: %.2f ± %.2f\n', groupStats.GroupMean(1)*100, groupStats.SE(1)* 100);
fprintf('\tNRon: %.2f ± %.2f\n', groupStats.GroupMean(2)*100, groupStats.SE(2)*100);
fprintf('***************************************\n');
fprintf('Statistics for difference between NRoff and NRon (alpha = 0.05):\n');
fprintf('\tP-value: %.4f\n', pValueDiff);
fprintf('\tt-statistic: %.4f\n', stats.tstat);
fprintf('\tDegrees of freedom: %.4f\n', stats.df);
fprintf('\tTest decision (h): %.4f\n', h);
if h == 1
    fprintf('\t\t-> NRoff and NRon are signficiantly different!');
elseif h == 0
    fprintf('\t\t-> NRoff and NRon are not signficiantly different.');
end


%%
% Colors for increase and decrease accuracy between NRoff and NRon
increaseColor = config.colors(5,:);
decreaseColor = config.colors(2,:);



% Initialize table to store results
results = table();

% Create figure for plotting
fig = figure;
hold on;

% Loop over each subject
for subjIdx = 1:nSubs
    subject = uniqueSubjects(subjIdx);

    subjData = groupedData(groupedData.Subject == subject, :);
    
    % Extract data for the current subject
    subjDataAll = dataAll(dataAll.Subject == subject, :);

    % Ensure there are exactly 2 conditions
    if height(subjData) == 2
        % Extract accuracy for each condition
        acc1 = subjData.PercentageCorrect(subjData.Condition == uniqueConditions(1))*100;
        acc2 = subjData.PercentageCorrect(subjData.Condition == uniqueConditions(2))*100;

         scatter([1,1], acc1, 'filled', ...
             'MarkerEdgeColor', [0.7 0.7 0.7], 'MarkerFaceColor', [0.7 0.7 0.7]);

          scatter([2,2], acc2, 'filled', ...
             'MarkerEdgeColor', [0.7 0.7 0.7], 'MarkerFaceColor', [0.7 0.7 0.7]);

        
        % Determine line color based on accuracy change
        if acc2 > acc1
            lineColor = increaseColor;
        else
            lineColor = decreaseColor;
        end

       
        % Plot horizontal line for the subject
        plot([1, 2], [acc1, acc2], 'Color', lineColor, 'LineWidth', 1.5);

        % Perform binomial test
        % Extract number of trials and number of successes for each condition
        nTrialsOFF = height(subjDataAll(subjDataAll.Condition == uniqueConditions(1), :));
        nCorrectOFF = sum(subjDataAll.Correct(subjDataAll.Condition == uniqueConditions(1)));
        
        nTrialsON = height(subjDataAll(subjDataAll.Condition == uniqueConditions(2), :));
        nCorrectON = sum(subjDataAll.Correct(subjDataAll.Condition == uniqueConditions(2)));
        
        % Perform binomial test
        % Calculate p-value for observing nCorrect or more successes in
        % nTrials with NRoff
        pValueOFF = 1 - binocdf(nCorrectOFF - 1, nTrialsOFF, chanceLevel);

        % Calculate p-value for observing nCorrect or more successes in
        % nTrials with NRon
        pValueON = 1 - binocdf(nCorrectON - 1, nTrialsON, chanceLevel);
        
        % Store results in the table
        results = [results; table(subject, nTrialsOFF, nCorrectOFF, pValueOFF, ...
                                  nTrialsON, nCorrectON, pValueON, ...
                                  'VariableNames', {'Subject', 'nTrialsOFF', 'nCorrectOFF', 'PValueOFF', ...
                                                     'nTrialsON', 'nCorrectON', 'PValueON'})];
    end
end

% Plot group mean performance with error bars
errorbar(1:2, groupStats.GroupMean*100, groupStats.SE*100, 'ko-', 'MarkerFaceColor', 'k', 'LineWidth', 2.5);

% Add horizontal dashed line for chance level
yline(chanceLevel*100, 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 1.5);

% Add labels and title to the plot
ylabel('Percent correct (%)','FontSize',14);
xticks([1,2]);
tickLabels = {'NR$_{\mbox{off}}$', 'NR$_{\mbox{on}}$'};
set(gca, 'xticklabels', tickLabels,'FontSize',18)
set(gca, 'TickLabelInterpreter', 'latex')
xlim([0.9, 2.1]);
ylim([0, 120]);
title('Behavioral performance','FontSize',18);
grid on;

% Add significance annotations
if pValueDiff < 0.005
    pValueName = 'p < 0.005';
elseif pValueDiff < 0.01
    pValueName = 'p < 0.01';
elseif pValueDiff < 0.05
    pValueName = 'p < 0.05';
end
annotation('textbox', [0.4, 0.9, 0.2, 0], 'String', pValueName, 'FontSize', 12,...
    'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'Color', 'k','EdgeColor', 'none');
plot([1 2], [105 105], 'k-', 'LineWidth', 1.5);
plot([1 1], [102 105], 'k-', 'LineWidth', 1.5);
plot([2 2], [102 105], 'k-', 'LineWidth', 1.5);

% Add legends
emptyStrings{1} = repmat({''}, 1, 3);
emptyStrings{2} = repmat({''}, 1, 19);
emptyStrings{3} = repmat({''}, 1, 125);
legendEntries = [{'Trial-averaged individual accuracy'}, {emptyStrings{1}{:}}, ...
    {'Increased accuracy'},{emptyStrings{2}{:}}, {'Decreased accuracy'},...
    {emptyStrings{3}{:}},{'Grand average','Statistically significant threshold'}];%Chance level

legend(legendEntries, 'Location', 'south','FontSize',12);

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure10.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure10.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure10.eps'), 'epsc');
end

end