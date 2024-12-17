function plotAbstractTRF(config,clusterInfo,data,t,time)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save TRFs for visual abstract\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot TRFs for visual abstract \nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
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


xlabel('Time [s]','FontSize',18)
ylabel('Amplitude [a.u.]','FontSize',18)
set(gca, 'FontSize', 18);
ylim([-0.00045,0.0003])
title('TRFs','FontSize',20)

legendText = {'','T-NR$_{\mbox{on}}$','','M-NR$_{\mbox{on}}$','','T-NR$_{\mbox{off}}$','', 'M-NR$_{\mbox{off}}$', '','TRF$_{\mbox{noise}}$'};
legend(legendText, 'Interpreter', 'latex','FontSize',16,'Location','SouthEast')


% Add text with components P1, N1, P2 and N2
x = [0.02, 0.1, 0.205, 0.26]; 
y = [8e-5, -2.9e-4, 2.5e-4, -8.5e-5]; 
text(x, y, {'P1','N1','P2','N2'}, 'FontSize', 14);

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"abstractTRF.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"abstractTRF.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'abstractTRF.eps'), 'epsc');
end
end