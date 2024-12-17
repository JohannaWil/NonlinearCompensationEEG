function plotFig7a(config,compData,labels)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 7a\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 7a\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

nCombinations = length(compData.residuals);
nSubs = length(compData.subjects);

% Reshape residuals from compensated datares_comp = cell(1,nCombinations);
for comp = 1:nCombinations
    res_temp = compData.residuals{comp};
    for s = 1:nSubs
        res_comp{comp}(s,:) = mean(res_temp{s}); % Average over trials
    end
end

fig = figure;

% Target with noise reduction turned on
subplot(2,2,1)
res = mean(abs(res_comp{1}));   % Average over subjects
plot_topography(labels, res, true, '10-20',false, false,1000)
hold on
hcb=colorbar;
hcb.FontSize = 10;
minmax(1) = min(res);
minmax(2) = max(res);
clim([minmax(1), minmax(2)])
title('T-NR$_{\mbox{on}}$', 'Interpreter', 'latex','FontSize',16)


% Masker with noise reduction turned on
subplot(2,2,2)
res = mean(abs(res_comp{2}));   % Average over subjects
plot_topography(labels, res, true, '10-20',false, false,1000)
hold on
hcb=colorbar;
hcb.FontSize = 10;
clim([minmax(1), minmax(2)])
title('M-NR$_{\mbox{on}}$', 'Interpreter', 'latex','FontSize',16)

% Target with noise reduction turned off
subplot(2,2,3)
res = mean(abs(res_comp{3}));   % Average over subjects
plot_topography(labels, res, true, '10-20',false, false,1000)
hold on
hcb=colorbar;
hcb.FontSize = 10;
minmax(1) = min(res);
minmax(2) = max(res);
clim([minmax(1), minmax(2)])
title('T-NR$_{\mbox{off}}$', 'Interpreter', 'latex','FontSize',16)

% Masker with noise reduction turned off
subplot(2,2,4)
res = mean(abs(res_comp{4}));   % Average over subjects
plot_topography(labels, res, true, '10-20',false, false,1000)
hold on
hcb=colorbar;
hcb.FontSize = 10;
clim([minmax(1), minmax(2)])
title('M-NR$_{\mbox{off}}$', 'Interpreter', 'latex','FontSize',16)

sgtitle('Average residuals [$\mu$V]', 'Interpreter', 'latex','FontSize',20)

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure7a_reply.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure7a_reply.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure7a.eps'), 'epsc');
end
end