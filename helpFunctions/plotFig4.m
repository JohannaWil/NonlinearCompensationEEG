function plotFig4(config,clusterInfo,data,t,time)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 4\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 4\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

% Number of subjects
nSubs = length(data.TRFdata.subjects);

close all;
fig = figure;
for i = 1:4 % For each condition (T-NRon, M-NRon, T-NRoff, M-NRoff)
    macc = squeeze(mean(clusterInfo.grandAvgOrig{i}.avg,1));
    vacc = squeeze(mean(clusterInfo.grandAvgOrig{i}.var,1));
    xacc = -1*[-fliplr(t),-t];
    yacc = [fliplr(macc-sqrt(vacc/nSubs)),macc+sqrt(vacc/nSubs)];
    h = fill(xacc,yacc',config.colors(i,:),'edgecolor','none'); hold on
    set(h,'facealpha',0.2), xlim([time.tmin,time.tmax]), axis square, grid on
    plot(-fliplr(-t),fliplr(macc),'color',config.colors(i,:),'linewidth',2)
    
end

% TRF data for shifted trials (control data)
resShifted = data.TRFdata.resShifted;
resShifted = resShifted - mean(resShifted,3);
meanShifted = squeeze(mean(resShifted))';
varShifted = squeeze(var(resShifted))';
macc =  mean(meanShifted');
vacc =  mean(varShifted');
xacc = -1*[-fliplr(t),-t];
yacc = [fliplr(macc-sqrt(vacc/nSubs)),macc+sqrt(vacc/nSubs)];
h = fill(xacc,yacc',config.colors(5,:),'edgecolor','none'); hold on
set(h,'facealpha',0.2), axis square, grid on
plot(-fliplr(-t),fliplr(macc),'color',config.colors(5,:),'linewidth',2)


%% Add significance data

valMax = 0.00036;
for i = 1:4 % For each condition (T-NRon, M-NRon, T-NRoff, M-NRoff)
    condition = clusterInfo.conditions{i};
    significant = clusterInfo.(condition).significantData.sigBinaryTime;
    indices_ones = find(significant == 1);

    for idx = indices_ones
        if idx ~= 59
            plot([t(idx),t(idx+1)],[valMax, valMax],'color',config.colors(i,:),'linewidth',4);
            hold on;
        end
    end
    valMax = valMax - 0.000022;

end

xlabel('Time [s]','FontSize',16)
ylabel('Amplitude [a.u.]','FontSize',16)
set(gca, 'FontSize', 16);
ylim([-0.0005,0.0004])
title('Grand average TRFs','FontSize',16)
legendText = {'','T-NR$_{\mbox{on}}$','','M-NR$_{\mbox{on}}$','','T-NR$_{\mbox{off}}$','', 'M-NR$_{\mbox{off}}$', '','TRF$_{\mbox{noise}}$'};
legend(legendText, 'Interpreter', 'latex','FontSize',14,'Location','SouthEast')


% Add text with components P1, N1, P2 and N2
x = [0.02, 0.1, 0.205, 0.26]; 
y = [8e-5, -2.9e-4, 2.5e-4, -8.5e-5]; 
text(x, y, {'P1','N1','P2','N2'}, 'FontSize', 12);

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure4.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure4.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure4.eps'), 'epsc');
end

end