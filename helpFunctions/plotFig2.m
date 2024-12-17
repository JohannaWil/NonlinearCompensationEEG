function plotFig2(yhat_ch,y_ch,y_ch_new,label,xBoarders,time,meanVal,meanVal2,tlim,f,config)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 2\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 2\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end


h = [];

fig = figure;
subplot(2,2,1)
plot(yhat_ch,y_ch,'b.')
hold on
xline(xBoarders,'k','LineWidth',3)
h(1) = plot(nan, nan, 'b.', 'MarkerSize', 30, 'DisplayName', 'Datapoints');
h(2) = plot(nan, nan, 'k-','LineWidth',3, 'DisplayName', 'Bins');
xlabel('Predicted $$\hat{y}$$','Interpreter','Latex','FontSize',22)
ylabel('Measured $$y$$','Interpreter','Latex','FontSize',22)
title('1: Measured vs predicted EEG data','FontSize',24)

subplot(2,2,2)
plot(time,meanVal,'b*', 'MarkerSize',20)
hold on
xline(xBoarders,'k','LineWidth',3)
plot(tlim,f,'g','LineWidth',2)
h(1) = plot(nan, nan, 'b*', 'MarkerSize', 30, 'DisplayName', 'Mean value');
h(2) = plot(nan, nan, 'k-','LineWidth',3, 'DisplayName', 'Bins');
h(3) = plot(nan, nan, 'g-','LineWidth',3, 'DisplayName', 'Linear trend');
xlabel('Predicted $$\hat{y}$$','Interpreter','Latex','FontSize',22)
ylabel('Measured $$y$$','Interpreter','Latex','FontSize',22)
title('2: Mean value in each bin','FontSize',24)

subplot(2,2,3)
plot(yhat_ch,y_ch,'.b')
hold on
plot(yhat_ch,y_ch_new,'.r')
xline(xBoarders,'k','LineWidth',3)
h(1) = plot(nan, nan, 'b.', 'MarkerSize', 30, 'DisplayName', 'Datapoints');
h(2) = plot(nan, nan, 'r.', 'MarkerSize', 30, 'DisplayName', 'Compensated datapoints');
h(3) = plot(nan, nan, 'k-','LineWidth',3, 'DisplayName', 'Bins');
xlabel('Predicted $$\hat{y}$$','Interpreter','Latex','FontSize',22)
ylabel('Measured $$y$$','Interpreter','Latex','FontSize',22)
title('3: After the binning method','FontSize',24)

subplot(2,2,4)
plot(time,meanVal,'b*', 'MarkerSize',20)
hold on
plot(time,meanVal2,'r*', 'MarkerSize',20)
xline(xBoarders,'k','LineWidth',3)
plot(tlim,f,'g','LineWidth',2)
h(1) = plot(nan, nan, 'b.', 'MarkerSize', 30, 'DisplayName', 'Original');
h(2) = plot(nan, nan, 'r.', 'MarkerSize', 30, 'DisplayName', 'Compensated');
h(3) = plot(nan, nan, 'k-','LineWidth',3, 'DisplayName', 'Bins');
h(4) = plot(nan, nan, 'b*', 'MarkerSize', 30, 'DisplayName', 'Original mean');
h(5) = plot(nan, nan, 'r*', 'MarkerSize', 30, 'DisplayName', 'Compensated mean');
h(6) = plot(nan, nan, 'g-','LineWidth',3, 'DisplayName', 'Linear trend');
legend(h,'FontSize',20,'Location','NorthWest')
xlabel('Predicted $$\hat{y}$$','Interpreter','Latex','FontSize',22)
ylabel('Measured $$y$$','Interpreter','Latex','FontSize',22)
title('4: After the binning method','FontSize',24)

sgtitle(['Nonlinearity compensation method for channel ',label],'FontSize',32)
fig.OuterPosition = config.figPosition;

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure2.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure2.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure2.eps'), 'epsc');
end
end