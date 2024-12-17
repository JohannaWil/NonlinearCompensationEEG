function clusterInfo = computeSignificane(config,data,labels,time,withChGroups,channelGroups)

% Permutation test based on t-statistics
% Fieldtrip: https://www.fieldtriptoolbox.org/tutorial/eventrelatedstatistics/

resOrig = data.TRFdata.resOrig;
resShifted = data.TRFdata.resShifted;
resShifted = resShifted - mean(resShifted,3);
conditions = config.conditions;
% Conditions:
%   Ton:    Target speech with noise reduction turned on
%   Mon:    Masker speech with noise reduction turned on
%   Toff:   Target speech with noise reduction turned off
%   Moff:   Masker speech with noise reduction turned off


% Number of permutations
numrandomization = config.numrandomization;

% Minimal number of neighbouring channels
minnbchan = config.minnbchan;

% Grand average for original EEG data, all 4 conditions
grandAvgOrigAll = cell(1,length(conditions));

% Grand average for EEG data with shifted trials (control data), all 4 conditions
grandAvgShiftAll = cell(1,length(conditions));

timeTestSig = [0 time.tmax];

nSubs = size(resOrig{1},1);             % Number of subjects

if ~withChGroups % When NOT dividing into channel groups

    for cond = 1:length(conditions)  % For each condition
        condition = conditions{cond};
        disp(['Condition: ',condition])
        disp('-------------------------------------------------------')

        % TRF data from the original (meansured) EEG data
        resOrig1 = resOrig{cond};

        subOrig = cell(1,nSubs);    % Original TRFs from measured EEG data
        subShift = cell(1,nSubs);   % Control TRFs with shifted trials
        t = linspace(time.tmin,time.tmax,time.nsamples);

        for s = 1:nSubs     % For each subject

            subOrig{s}.avg = squeeze(resOrig1(s,:,:));
            subOrig{s}.label = labels;
            subOrig{s}.fsample = 64;
            subOrig{s}.time = t;
            subOrig{s}.dimord = 'chan_time';

            subShift{s}.avg = squeeze(resShifted(s,:,:));
            subShift{s}.label = labels;
            subShift{s}.fsample = 64;
            subShift{s}.time = t;
            subShift{s}.dimord = 'chan_time';

        end

        % Grand average EEG
        cfg = [];
        cfg.channel   = 'all';
        cfg.latency   = 'all';
        cfg.parameter = 'avg';
        grandAvgOrig  = ft_timelockgrandaverage(cfg, subOrig{:});
        grandAvgShift  = ft_timelockgrandaverage(cfg, subShift{:});
        grandAvgOrigAll{cond} =  grandAvgOrig;
        grandAvgShiftAll{cond} =  grandAvgShift;

        cfg = [];
        cfg.method      = 'template';                         % try 'distance' as well
        cfg.template    = 'biosemi64_neighb.mat';                % specify type of template
        cfg.layout      = 'biosemi64.lay';                % specify layout of channels
        cfg.feedback    = 'yes';                              % show a neighbour plot
        neighboursEEG      = ft_prepare_neighbours(cfg, grandAvgOrig); % define neighbouring channels


        % note that the layout and template fields have to be entered because at the earlier stage
        % when ft_timelockgrandaverage is called the field 'grad' is removed. It is this field that
        % holds information about the (layout of the) channels.


        %So far we predefined a time window over which the effect was averaged, and
        %tested the difference of that between conditions. You can also chose to not
        %average over the predefine time window, and instead cluster simultaneously
        %over neighbouring channels and neighbouring time points within your time
        %window of interest . From the example below, we now find a channel-time
        %cluster is found from 0.33 s until 0.52 s in which p < 0.05.

        cfg = [];
        cfg.channel     = 'EEG';
        cfg.neighbours  = neighboursEEG; % defined as above
        cfg.latency     = timeTestSig;
        cfg.avgovertime = 'no';
        cfg.parameter   = 'avg';
        cfg.method      = 'montecarlo';
        cfg.statistic   = 'ft_statfun_depsamplesT';
        cfg.alpha       = 0.05;
        cfg.correctm    = 'cluster';
        cfg.correcttail = 'prob';
        cfg.numrandomization = numrandomization;%'all';  % there are 10 subjects, so 2^10=1024 possible permutations
        cfg.minnbchan        = minnbchan;      % minimal number of neighbouring channels

        Nsub = nSubs;
        cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
        cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
        cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
        cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number

        stat = ft_timelockstatistics(cfg, subOrig{:}, subShift{:});

        close all;

        % make a plot
        cfg = [];
        cfg.highlightsymbolseries = ['*','*','.','.','.'];
        cfg.layout = 'biosemi64.lay';
        cfg.contournum = 0;
        cfg.markersymbol = '.';
        cfg.alpha = 0.05;
        cfg.comment          = 'xlim';
        cfg.commentpos       = 'title';
        cfg.parameter='stat';
        cfg.zlim = [-5 5];
        cfg.highlightcolorpos = [0, 0.4470, 0.7410];
        cfg.highlightcolorneg = [0.8500, 0.3250, 0.0980];

        disp('-------------------------------------------------------')
        disp('-------------------------------------------------------')
        posClusterExists = false;
        negClusterExists = false;

        if isfield(stat,"posclusters")
            nPosClusters = length(stat.posclusters);
            for j = 1:nPosClusters
                if stat.posclusters(j).prob < 0.05
                    posClusterExists = true;
                end
            end
        end

        if isfield(stat,"negclusters")
            nNegClusters = length(stat.negclusters);
            for j = 1:nNegClusters
                if stat.negclusters(j).prob < 0.05
                    negClusterExists = true;
                end
            end
        end



        if posClusterExists || negClusterExists
            ft_clusterplot(cfg, stat);
        else
            disp('No significant cluster exists')
        end

        close all;
        clusterInfo.(condition).stats = stat;
        clusterInfo.(condition).labels = labels;


        disp('-------------------------------------------------------')
        disp('-------------------------------------------------------')
    end

    clusterInfo.cfg.nPermutations = numrandomization;
    clusterInfo.cfg.minNrNeighCh = minnbchan;
    clusterInfo.nCh = 64;
    clusterInfo.time = t;
    clusterInfo.cfg.timeTestSig = timeTestSig;
    clusterInfo.conditions = {'Ton','Mon','Toff','Moff'};
    clusterInfo.grandAvgOrig = grandAvgOrigAll;
    clusterInfo.grandAvgShift = grandAvgShiftAll;

    for cond = 1:4
        condition = conditions{cond};
        significantData = loadSignificantData(condition,t);
        clusterInfo.(condition).significantData = significantData;
    end
    fname = [config.datadir,'\significanceData_user.mat'];
    save(fname,'clusterInfo')




else % WITH channel groups

    nChGroups = length(channelGroups.areaNames);
    for ii = 1:nChGroups
        groupName = channelGroups.areaNames{ii};
        disp('----------------------------------------------------------')
        disp('***** NEW GROUP *****')
        disp(['Group: ',groupName])
        disp('----------------------------------------------------------')

        channelsIdx = channelGroups.(groupName).chIdx;
        channels = channelGroups.(groupName).ch;


        for cond = 1:4
            condition = conditions{cond};
            disp(['Condition: ',condition])
            disp('-------------------------------------------------------')
            resOrig1 = resOrig{cond};
            nSubs = size(resOrig1,1);
            subOrig = cell(1,nSubs);
            subShift = cell(1,nSubs); %control
            t = linspace(time.tmin,time.tmax,time.nsamples);
            for s = 1:nSubs
                subOrig{s}.avg = squeeze(resOrig1(s,channelsIdx,:));
                subOrig{s}.label = labels(channelsIdx);
                subOrig{s}.fsample = 64;
                subOrig{s}.time = t;
                subOrig{s}.dimord = 'chan_time';

                subShift{s}.avg = squeeze(resShifted(s,channelsIdx,:));
                subShift{s}.label = labels(channelsIdx);
                subShift{s}.fsample = 64;
                subShift{s}.time = t;
                subShift{s}.dimord = 'chan_time';
            end

            % Grand average EEG
            cfg = [];
            cfg.channel   = channels;%'all';
            cfg.latency   = 'all';
            cfg.parameter = 'avg';
            grandAvgOrig  = ft_timelockgrandaverage(cfg, subOrig{:});
            grandAvgShift  = ft_timelockgrandaverage(cfg, subShift{:});
            grandAvgOrigAll{cond} =  grandAvgOrig;
            grandAvgShiftAll{cond} =  grandAvgShift;

            cfg = [];
            cfg.method      = 'template';                         % try 'distance' as well
            cfg.template    = 'biosemi64_neighb.mat';                % specify type of template
            cfg.layout      = 'biosemi64.lay';                % specify layout of channels
            cfg.feedback    = 'yes';                              % show a neighbour plot
            neighboursEEG      = ft_prepare_neighbours(cfg, grandAvgOrig); % define neighbouring channels


            % note that the layout and template fields have to be entered because at the earlier stage
            % when ft_timelockgrandaverage is called the field 'grad' is removed. It is this field that
            % holds information about the (layout of the) channels.


            %So far we predefined a time window over which the effect was averaged, and
            %tested the difference of that between conditions. You can also chose to not
            %average over the predefine time window, and instead cluster simultaneously
            %over neighbouring channels and neighbouring time points within your time
            %window of interest . From the example below, we now find a channel-time
            %cluster is found from 0.33 s until 0.52 s in which p < 0.05.

            cfg = [];
            cfg.channel     = channels;
            cfg.neighbours  = neighboursEEG; % defined as above
            cfg.latency     = timeTestSig;
            cfg.avgovertime = 'no';
            cfg.parameter   = 'avg';
            cfg.method      = 'montecarlo';
            cfg.statistic   = 'ft_statfun_depsamplesT';
            cfg.alpha       = 0.05;
            cfg.correctm    = 'cluster';
            cfg.correcttail = 'prob';
            cfg.numrandomization = numrandomization;%'all';  % there are 10 subjects, so 2^10=1024 possible permutations
            cfg.minnbchan        = minnbchan;      % minimal number of neighbouring channels

            Nsub = nSubs;
            cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
            cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
            cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
            cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number

            stat = ft_timelockstatistics(cfg, subOrig{:}, subShift{:});

            close all;
            % make a plot
            cfg = [];
            cfg.highlightsymbolseries = ['*','*','.','.','.'];
            cfg.layout = 'biosemi64.lay';
            cfg.contournum = 0;
            cfg.markersymbol = '.';
            cfg.alpha = 0.05;
            cfg.comment          = 'xlim';
            cfg.commentpos       = 'title';
            cfg.parameter='stat';

            disp('-------------------------------------------------------')
            posClusterExists = false;
            negClusterExists = false;

            if isfield(stat,"posclusters")
                nPosClusters = length(stat.posclusters);
                for j = 1:nPosClusters
                    if stat.posclusters(j).prob < 0.05
                        posClusterExists = true;
                    end
                end
            end

            if isfield(stat,"negclusters")
                nNegClusters = length(stat.negclusters);
                for j = 1:nNegClusters
                    if stat.negclusters(j).prob < 0.05
                        negClusterExists = true;
                    end
                end
            end



            if posClusterExists || negClusterExists
                ft_clusterplot(cfg, stat);
            else
                disp('No significant cluster exists')
            end
            close all;
            clusterInfo_chGroups.(groupName).(condition).stats = stat;

            clusterInfo_chGroups.(groupName).(condition).labels = channels;
            clusterInfo_chGroups.(groupName).(condition).labelsIdx = channelsIdx;

            disp('-------------------------------------------------------')
            disp('-------------------------------------------------------')
        end
    end

    %%
    clusterInfo_chGroups.cfg.nPermutations = numrandomization;
    clusterInfo_chGroups.cfg.minNrNeighCh = minnbchan;
    clusterInfo_chGroups.channelGroups = channelGroups;
    clusterInfo_chGroups.time = t;
    clusterInfo_chGroups.cfg.timeTestSig = timeTestSig;
    clusterInfo_chGroups.conditions = {'Ton','Mon','Toff','Moff'};
    clusterInfo_chGroups.grandAvgOrig = grandAvgOrigAll;
    clusterInfo_chGroups.grandAvgShift = grandAvgShiftAll;

    for ii = 1:nChGroups
        groupName = channelGroups.areaNames{ii};
        for cond = 1:4
            condition = conditions{cond};
            significantData = loadSignificantData_chGroups(groupName,condition,t);
            clusterInfo_chGroups.(groupName).(condition).significantData = significantData;
        end
    end
    clusterInfo = clusterInfo_chGroups;
    fname = [config.datadir,'\significanceData_chGroups_user.mat'];
    save(fname,'clusterInfo_chGroups')
end

disp(['Cluster data saved as:   ',fname])
end
