function plotFig7b(config,rawResiduals,labels)
if config.saveFigures
    fprintf('****************************************************************\nPlot and save figure 7b\n****************************************************************\n');
else
    fprintf('****************************************************************\nPlot figure 7b\nDo not save figure (update config.saveFigures to save figure)\n****************************************************************\n');
end



fprintf('---------------------------------------\nPerform paired t-test for each channel\n---------------------------------------\n');

% Names of the conditions
    % T: Target speech
    % M: Masker speech
    % NRon: Noise reduction turned on
    % NRoff: Noise reduction turned off
captions = {'T-NR$_{\mbox{ON}}$','M-NR$_{\mbox{ON}}$','T-NR$_{\mbox{OFF}}$', 'M-NR$_{\mbox{OFF}}$'};    
printText = {'T-NRon','M-NRon','T-NRoff', 'M-NRoff'};    

nConditions = length(captions);         % Number of conditions
nCh = size(rawResiduals.data{1},3);     % Number of channels
alpha = 0.05;

fig = figure;
subFigs = [1:3,5:6,9];  % Positions in the figure to plot the results
subFigIdx = 1;          % Subplot figure index
currFig = 1;            % Current figure index


for i = 1:nConditions % For each condition

    % Extract residuals for condition i
    data1 = rawResiduals.data{i};

    % Array to store p-values for each channel
    p_values = zeros(1, nCh); 
    
    for j = 1:nConditions
        
        % Extract residuals for condition j
        data2 = rawResiduals.data{j};

        for channel = 1:nCh
            channel_data1 = squeeze(data1(:, :, channel)); % Extract data for channel from dataset 1
            channel_data2 = squeeze(data2(:, :, channel)); % Extract data for channel from dataset 2

            % Compute differences between datasets
            differences = channel_data1 - channel_data2;
            
            % Perform paired t-test
            [~, p_values(channel)] = ttest(differences(:));
            
        end
        
        % Apply Bonferroni correction for multiple comparisons
        p_values_corrected = p_values * nCh;
        
        % Assign channels
            % value 0 (corrected p-value > alpha -> not significant)
            % value 1 (corrected p-value < alpha -> significant)
        significant_channels = zeros(1, nCh);
        significant_channels(p_values_corrected < alpha) = 1;
        
        % Plot results for interesting conditions
        if ismember(currFig,[2:4,7:8,12])   
            disp([printText{i},' and ',printText{j},': Print results'])
            subplot(3,3,subFigs(subFigIdx))
            plot_topography(labels, significant_channels, false, '10-20',true, false,1000);
            hcb=colorbar;
            hcb.FontSize = 10;
            clim([0, 1])
            colorbar('Ticks',[0,1], 'TickLabels',{'0','1'},'FontSize',14)
            title({captions{i}, captions{j}}, 'Interpreter', 'latex','FontSize',18);

            subFigIdx = subFigIdx + 1; 
            hold on;

        else
            % Corrected p-values for these condition combinations are
            % computed, but not plotted
          disp([printText{i},' and ',printText{j}])
        end
        currFig = currFig + 1;
    end
    disp('---------------------------------------')
end
sgtitle('Statistiacally significance t-tests','FontSize',36)
fig.OuterPosition = config.figPosition;

if config.saveFigures
    saveas(fig,fullfile('results',config.saveFolder,"figure7b.jpeg"))
    saveas(fig,fullfile('results',config.saveFolder,"figure7b.eps"))
    saveas(fig, fullfile('results', config.saveFolder, 'figure7b.eps'), 'epsc');
end
end







