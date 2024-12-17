function TRFdata = plotFig5(config,data,time,clusterInfo)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 5\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 5\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end

resOrig = data.TRFdata.resOrig;
resNew = data.TRFdata.resNew;
channelGroups = data.channelGroups;
nChGroups = length(channelGroups.areaNames);
nSubs = size(resOrig{1},1);

TRFdata = struct();
nConditions = length(config.conditions); %(T-NRon, M-NRon, T-NRoff, M-NRoff)

% Average over all 30 subjects
for i = 1:nConditions
    meanOrig{i} = squeeze(mean(resOrig{i}))';
    varOrig{i} = squeeze(var(resOrig{i}))';
    meanNew{i} = squeeze(mean(resNew{i}))';
    varNew{i} = squeeze(var(resNew{i}))';
end

% TRF data for shifted trials (control data)
resShifted = data.TRFdata.resShifted;
resShifted = resShifted - mean(resShifted,3);
meanShifted = squeeze(mean(resShifted))';
varShifted = squeeze(var(resShifted))';

tmin = time.tmin;
tmax = time.tmax;
ns = time.nsamples;
t = linspace(tmin,tmax,ns);


%% Plot Figure 5a

% ymin = -0.000085;
% ymax = 0.0001;
legendText = {'','T-NR$_{\mbox{on}}$','','','','','','','','','','','','','','','','','','','M-NR$_{\mbox{on}}$','','','',''...
    '','','','','T-NR$_{\mbox{off}}$','','M-NR$_{\mbox{off}}$','','TRF$_{\mbox{noise}}$'};

fig = figure;
for ii = 1:nChGroups
    groupName = channelGroups.areaNames{ii};
    channels = channelGroups.(groupName).chIdx;
    valMax = 0.0004;
    subplot(2,3,ii)
    for i = 1:nConditions
        condition = clusterInfo.conditions{i};
        significant = clusterInfo.(groupName).(condition).significantData.sigBinaryTime;
        indices_ones = find(significant == 1);
        macc =  mean(meanOrig{i}(:,channels)');
        vacc =  mean(varOrig{i}(:,channels)');
        xacc = -1*[-fliplr(t),-t];
        yacc = [fliplr(macc-sqrt(vacc/nSubs)),macc+sqrt(vacc/nSubs)];
        % ymax = max(ymax,max(macc+sqrt(vacc/nSubs)));
        % ymin = min(ymin,min(macc-sqrt(vacc/nSubs)));
        h = fill(xacc,yacc',config.colors(i,:),'edgecolor','none'); hold on
        set(h,'facealpha',0.2), xlim([tmin,tmax]), axis square, grid on
        plot(-fliplr(-t),fliplr(macc),'color',config.colors(i,:),'linewidth',2)

        for idx = indices_ones
            plot([t(idx),t(idx+1)],[valMax, valMax],'color',config.colors(i,:),'linewidth',3);
            hold on;
        end
        valMax = valMax - 0.00003;

        TRFdata.varaiance.original{i,ii} = vacc;
        TRFdata.varaiance.compensated{i,ii} = mean(varNew{i}(:,channels)');

        % N1 peak
        temp = macc(18:22); %[80 120]ms
        acc_tmp = min(temp); % N1 peak
        acc_tmpIdx = find(acc_tmp == macc); %Idx of N1 peak
        TRFdata.N1.amplitude(i,ii) = acc_tmp;
        TRFdata.N1.latency(i,ii) = t(acc_tmpIdx);

        % P2 peak
        temp = macc(27:35); %[170 225]ms
        acc_tmp = max(temp); % P2 peak
        acc_tmpIdx = find(acc_tmp == macc); %Idx of P2 peak
        TRFdata.P2.amplitude(i,ii) = acc_tmp;
        TRFdata.P2.latency(i,ii) = t(acc_tmpIdx);
    end

    macc =  mean(meanShifted(:,channels)');
    vacc =  mean(varShifted(:,channels)');
    xacc = -1*[-fliplr(t),-t];
    yacc = [fliplr(macc-sqrt(vacc/nSubs)),macc+sqrt(vacc/nSubs)];
    % ymax = max(ymax,max(macc+sqrt(vacc/nSubs)));
    % ymin = min(ymin,min(macc-sqrt(vacc/nSubs)));
    h = fill(xacc,yacc',config.colors(5,:),'edgecolor','none'); hold on
    set(h,'facealpha',0.2), xlim([tmin,tmax]), axis square, grid on
    plot(-fliplr(-t),fliplr(macc),'color',config.colors(5,:),'linewidth',2)

    if ismember(ii, [4, 5, 6])
        xlabel('Time [s]','FontSize',18)
    end
    if ismember(ii, [1,4])
        ylabel('Amplitude [a.u.]','FontSize',18)
    end

    set(gca, 'FontSize', 18);
    ylim([-0.0004,0.00045])
    title(channelGroups.(groupName).name,'FontSize',22)

end
fig.OuterPosition = config.figPosition;
sgtitle('Average TRFs: Target speech','FontSize',36)
legend(legendText, 'Interpreter', 'latex','FontSize',24,'Location',[0.595, 0.46, 0.11, 0.15])


if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure5a.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure5a.fig"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure5.eps'), 'epsc');
end


TRFdata.channelGroups = channelGroups;
TRFdata.conditions = config.conditions;


%% Plot Figure 5b

legendText = {'','','','','','','','','M-NR$_{\mbox{on}}$','','M-NR$_{\mbox{off}}$','','TRF$_{\mbox{noise}}$'};

ymin = -0.000085;
ymax = 0.0001;

nChGroups = length(channelGroups.areaNames);

fig2 = figure;
for ii = 1:nChGroups % For each channel group
    groupName = channelGroups.areaNames{ii};
    channels = channelGroups.(groupName).chIdx;
    valMax = 0.00008;
    subplot(2,3,ii)
    for i = 1:4
        if i == 2 || i == 4 % Masker TRFs
            condition = clusterInfo.conditions{i};
            significant = clusterInfo.(groupName).(condition).significantData.sigBinaryTime;
            indices_ones = find(significant == 1);
            
            for idx = indices_ones
                plot([t(idx),t(idx+1)],[valMax, valMax],'color',config.colors(i,:),'linewidth',5);
                
                hold on;
            end
            valMax = valMax - 0.000008;
            macc =  mean(meanOrig{i}(:,channels)');
            vacc =  mean(varOrig{i}(:,channels)');
            xacc = -1*[-fliplr(t),-t];
            yacc = [fliplr(macc-sqrt(vacc/nSubs)),macc+sqrt(vacc/nSubs)];
            ymax = max(ymax,max(macc+sqrt(vacc/nSubs)));
            ymin = min(ymin,min(macc-sqrt(vacc/nSubs)));
            h = fill(xacc,yacc',config.colors(i,:),'edgecolor','none'); hold on
            set(h,'facealpha',0.2), xlim([tmin,tmax]), axis square, grid on
            plot(-fliplr(-t),fliplr(macc),'color',config.colors(i,:),'linewidth',2)
        end
        
    end
    macc =  mean(meanShifted(:,channels)');
    vacc =  mean(varShifted(:,channels)');
    xacc = -1*[-fliplr(t),-t];
    yacc = [fliplr(macc-sqrt(vacc/nSubs)),macc+sqrt(vacc/nSubs)];
    ymax = max(ymax,max(macc+sqrt(vacc/nSubs)));
    ymin = min(ymin,min(macc-sqrt(vacc/nSubs)));
    h = fill(xacc,yacc',config.colors(5,:),'edgecolor','none'); hold on
    set(h,'facealpha',0.2), xlim([tmin,tmax]), axis square, grid on
    plot(-fliplr(-t),fliplr(macc),'color',config.colors(5,:),'linewidth',2)
    
    if ismember(ii, [4, 5, 6])
        xlabel('Time [s]','FontSize',18)
    end
    if ismember(ii, [1,4])
        ylabel('Amplitude [a.u.]','FontSize',18)
    end
    set(gca, 'FontSize', 18);
    ylim([ymin,ymax])
    title(channelGroups.(groupName).name,'FontSize',22)
    
end
sgtitle('Average TRFs: Masker speech and noise level','FontSize',36)
fig2.OuterPosition = config.figPosition;
legend(legendText, 'Interpreter', 'latex','FontSize',24,'Location',[0.58, 0.36, 0.11, 0.14])

if config.saveFigures
    saveas(fig2,fullfile('results',config.saveFolder,"figure5b.jpeg"))
    saveas(fig2,fullfile('results',config.saveFolder,"figure5b.fig"))
end

end