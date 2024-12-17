function plotFig9(config,snr,channelGroups)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 9\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 9\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

nChGroups = length(channelGroups.areaNames);
nConditions = length(config.conditions);

meanSNR = struct();
legendText = cell(1,6);
alpha = 0.05;
p_values = zeros(nConditions,nChGroups);

% Average over all 30 subjects
for j = 1:nConditions       % For each conditions
    meanSNR.original(j,:) = mean(snr.original{j});
    meanSNR.compensated(j,:) = mean(snr.compensated{j});

    % SNR difference
    meanSNR.diff(j,:) = meanSNR.compensated(j,:) - meanSNR.original(j,:);

    for i = 1:nChGroups     % For each channel group
        groupName = channelGroups.areaNames{i};
        legendText{i} = channelGroups.(groupName).name;
        channels = channelGroups.(groupName).chIdx;
        meanSNR.chGroups(j,i) = mean(meanSNR.diff(j,channels)');
        
        % Average over channels in group i
        snr_orig = mean(snr.original{j}(:,channels),2);
        snr_comp = mean(snr.compensated{j}(:,channels),2);
        [~, p] = ttest(snr_orig, snr_comp);
        p_values(j,i) = p;
    end
end

tickLabels = {'T-NR$_{\mbox{on}}$', 'M-NR$_{\mbox{on}}$', 'T-NR$_{\mbox{off}}$', 'M-NR$_{\mbox{off}}$'};

% Create a bar plot
fig = figure;
bar_handle = bar(meanSNR.chGroups);

x = zeros(nConditions, nChGroups);
for i = 1: nChGroups
    b = bar_handle(i);
    x(:,i) = b.XEndPoints;
end

xticks(1:nConditions)
set(gca, 'xticklabels', tickLabels,'FontSize',18)
set(gca, 'TickLabelInterpreter', 'latex')
ylabel('SNR difference [dB]');
set(gca, 'FontSize', 32);
title('SNR improvements after compensation','FontSize',40);

disp('Bonferroni corrected t-test by dividing by number of conditions')
legendText = {legendText{:},'Significant'};
hold on;
for i = 1:nConditions
    for ii = 1:nChGroups
        if p_values(i,ii) < alpha/(nConditions)
            x_coord = x(i,ii); % x-coordingate for the bar
            y_coord = meanSNR.chGroups(i,ii) + 0.015; % Slightly above the bar height
            % Plot the red 'x' marker
            plot(x_coord, y_coord, 'rx', 'MarkerSize', 16, 'LineWidth', 2);

        end
    end
end
hold off;
fig.OuterPosition = config.figPosition;
legend(legendText,'FontSize',28,'Location',[0.15, 0.7, 0.15, 0.1])

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure9.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure9.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure9.eps'), 'epsc');
end

end