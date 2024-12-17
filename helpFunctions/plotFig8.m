function plotFig8(config,TRFdata,t,channelGroups)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 8\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 8\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

ymin = 0;
ymax = 7e-8;
nChGroups = length(channelGroups.areaNames);

targetLegend = {'T-NR$_{\mbox{on}}$ original','T-NR$_{\mbox{on}}$ compensated','T-NR$_{\mbox{off}}$ original', 'T-NR$_{\mbox{off}}$ compensated'};
maskerLegend = {'M-NR$_{\mbox{on}}$ original','M-NR$_{\mbox{on}}$ compensated','M-NR$_{\mbox{off}}$ original', 'M-NR$_{\mbox{off}}$ compensated'};

fig = figure;
for ii = 1:nChGroups
    groupName = channelGroups.areaNames{ii};
    subplot(2,3,ii)
    for i = [1,3]
        vacc = TRFdata.varaiance.original{i,ii};
        plot(-fliplr(-t),fliplr(vacc),'color',config.colors(i,:),'linewidth',2)
        hold on
        vacc = TRFdata.varaiance.compensated{i,ii};
        plot(-fliplr(-t),fliplr(vacc),'--','color',config.colors(i,:),'linewidth',2)

    end

    if ismember(ii,4:6)
        xlabel('Time [s]','FontSize',20)
    end
    if ismember(ii,[1,4])
        ylabel('Amplitude [a.u.]','FontSize',20)
    end
    set(gca, 'FontSize', 20);
    ylim([ymin,ymax])
    grid on
    title(channelGroups.(groupName).name,'FontSize',26)
end
sgtitle('TRF variance target speech', 'Interpreter', 'latex','FontSize',44)
fig.OuterPosition = config.figPosition;
legend(targetLegend, 'Interpreter', 'latex','FontSize',28,'Location',[0.75, 0.25, 0.15, 0.1])

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure8a.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure8a.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure8a.eps'), 'epsc');
end


%%
ymax2 = 1.5e-8;

fig = figure;
for ii = 1:nChGroups
    groupName = channelGroups.areaNames{ii};
    subplot(2,3,ii)
    for i = [2,4]
        vacc = TRFdata.varaiance.original{i,ii};    
        plot(-fliplr(-t),fliplr(vacc),'color',config.colors(i,:),'linewidth',2)
        hold on
        vacc = TRFdata.varaiance.compensated{i,ii};
        plot(-fliplr(-t),fliplr(vacc),'--','color',config.colors(i,:),'linewidth',2)

    end
    if ismember(ii,4:6)
        xlabel('Time [s]','FontSize',20)
    end
    if ismember(ii,[1,4])
        ylabel('Amplitude [a.u.]','FontSize',20)
    end
    set(gca, 'FontSize', 20);
    ylim([ymin,ymax2])
    grid on
    title(channelGroups.(groupName).name,'FontSize',26)
end
sgtitle('TRF variance masker speech', 'Interpreter', 'latex','FontSize',44)

fig.OuterPosition = config.figPosition;
legend(maskerLegend, 'Interpreter', 'latex','FontSize',28,'Location',[0.75, 0.27, 0.15, 0.1])

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure8b.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure8b.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure8b.eps'), 'epsc');
end


end