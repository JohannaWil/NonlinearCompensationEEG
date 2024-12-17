function plotFig6(config,TRFpeaksData,channelGroups)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 6\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 6\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

nChGroups = length(channelGroups.areaNames);

legNames = cell(1,nChGroups);
for i = 1:nChGroups
    groupName = channelGroups.areaNames{i};
    legNames{i} = channelGroups.(groupName).name;
end

tickLabels = {'T-NR$_{\mbox{on}}$','M-NR$_{\mbox{on}}$','T-NR$_{\mbox{off}}$','M-NR$_{\mbox{off}}$'};

fig = figure;
subplot(2,2,1)
bar(abs(TRFpeaksData.N1.amplitude))
xticks(1:4)
set(gca, 'xticklabels', tickLabels,'FontSize',24)
set(gca, 'TickLabelInterpreter', 'latex')
title('Amplitude N1-peak','Interpreter', 'latex','FontSize',30)
ylabel('Amplitude [a.u.]','FontSize',24)
ylim([0,0.00036])
grid on

subplot(2,2,2)
bar(TRFpeaksData.P2.amplitude)
xticks(1:4)
set(gca, 'xticklabels', tickLabels,'FontSize',24)
set(gca, 'TickLabelInterpreter', 'latex')
title('Amplitude P2-peak','Interpreter', 'latex','FontSize',30)
ylabel('Amplitude [a.u.]','FontSize',24)
ylim([0,0.00036])
grid on

subplot(2,2,3)
bar(TRFpeaksData.N1.latency)
xticks(1:4)
set(gca, 'xticklabels', tickLabels,'FontSize',24)
set(gca, 'TickLabelInterpreter', 'latex')
title('Latency N1-peak','Interpreter', 'latex','FontSize',30)
ylabel('Time [s]','FontSize',24)
ylim([0.07,0.125])
grid on

subplot(2,2,4)
bar(TRFpeaksData.P2.latency)
xticks(1:4)
set(gca, 'xticklabels', tickLabels,'FontSize',24)
set(gca, 'TickLabelInterpreter', 'latex')
title('Latency P2-peak','Interpreter', 'latex','FontSize',30)
ylabel('Time [s]','FontSize',24)
ylim([0.17,0.24])
grid on

fig.OuterPosition = config.figPosition;
legend(legNames,'FontSize',24,'Location',[0.81, 0.75, 0.15, 0.1])

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure6.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure6.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure6.eps'), 'epsc');
end
end