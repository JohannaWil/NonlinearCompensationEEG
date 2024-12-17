function data = loadSignificantData_chGroups(group,condition,t)

% Data saved by Johanna Wilroth from the command window after using the
% function ft_clusterplot(cfg, stat).

switch group
    
    case 'leftTemporal'
        
        switch condition
            
            case 'Ton'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 28;
                data.tIntervals = {[-0.0009,0.0391],[0.0791,0.1491],[0.1891,0.2691]};
                
            case 'Mon'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 22;
                data.tIntervals = {[0.0891,0.1191],[0.2391,0.2991]};
                
                
            case 'Toff'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 1;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 18;
                data.tIntervals = {[0.0891,0.1491],[0.1891,0.2591]};
                
            case 'Moff'
                data.nPosClustersTot = 0;
                data.nNegClustersTot = 1;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 6;
                data.tIntervals = {[0.2491,0.2991]};
                
                
        end
        
        
    case 'frontal'
        
        switch condition
            
            case 'Ton'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 42;
                data.tIntervals = {[-0.0009,0.0491],[0.0691,0.1591],[0.1791,0.2691],[0.3291,0.4091]};
                
                
            case 'Mon'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 4;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 20;
                data.tIntervals = {[0.2491,0.3191],[0.3591,0.4391]};
                
            case 'Toff'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 38;
                data.tIntervals = {[-0.0009,0.0391],[0.0891,0.1491],[0.1791,0.2591],[0.3291,0.3691]};
                
            case 'Moff'
                data.nPosClustersTot = 1;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 8;
                data.tIntervals = {[0.2491,0.3191]};
                
        end
        
        
    case 'rightTemporal'
        
        switch condition
            
            case 'Ton'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 44;
                data.tIntervals = {[-0.0009,0.0591],[0.0991,0.1491],[0.1891,0.2691],[0.3491,0.4291]};
                
            case 'Mon'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 1;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 30;
                data.tIntervals = {[0.0091,0.0391],[0.2391,0.2991]};
                
            case 'Toff'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 1;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 27;
                data.tIntervals = {[0.0091,0.0491],[0.1191,0.1391],[0.1791,0.2691]};
                
            case 'Moff'
                data.nPosClustersTot = 1;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 1;
                data.nNegClustersSig = 0;
                data.nTimePointSig = 4;
                data.tIntervals = {[-0.0009,0.0291]};
                
                
        end
        
        
    case 'central'
        
        switch condition
            
            case 'Ton'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 4;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 43;
                data.tIntervals = {[-0.0009,0.0491],[0.0691,0.1591],[0.1791,0.2591],[0.2891,0.4191]};
                
                
            case 'Mon'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 4;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 7;
                data.tIntervals = {[0.2491,0.3091]};
                
            case 'Toff'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 39;
                data.tIntervals = {[-0.0009,0.0491],[0.0791,0.1491],[0.1791,0.2591],[0.2991,0.3791]};
                
            case 'Moff'
                data.nPosClustersTot = 1;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 8;
                data.tIntervals = {[0.2491,0.3191]};
                
        end
        
        
    case 'parietal'
        
        switch condition
            
            case 'Ton'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 4;
                data.nPosClustersSig = 2;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 42;
                data.tIntervals = {[-0.0009,0.0591],[0.0891,0.1591],[0.1791,0.2491],[0.2791,0.4091]};
                
            case 'Mon'
                data.nPosClustersTot = 1;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 6;
                data.tIntervals = {[0.2491,0.2991]};
                
            case 'Toff'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 1;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 29;
                data.tIntervals = {[0.0991,0.1491],[0.1891,0.2491],[0.2891,0.3791]};
                
            case 'Moff'
                data.nPosClustersTot = 0;
                data.nNegClustersTot = 2;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 1;
                data.nTimePointSig = 6;
                data.tIntervals = {[0.2591,0.3091]};
                
                
        end
        
        
    case 'occipital'
        
        switch condition
            
            case 'Ton'
                data.nPosClustersTot = 2;
                data.nNegClustersTot = 3;
                data.nPosClustersSig = 1;
                data.nNegClustersSig = 2;
                data.nTimePointSig = 33;
                data.tIntervals = {[-0.0009,0.0591],[0.1091,0.1491],[0.2791,0.3191]};
                
            case 'Mon'
                data.nPosClustersTot = 1;
                data.nNegClustersTot = 0;
                data.nPosClustersSig = 1;
                data.nNegClustersSig = 0;
                data.nTimePointSig = 7;
                data.tIntervals = {[0.0091,0.0691]};
                
                
            case 'Toff'
                data.nPosClustersTot = 1;
                data.nNegClustersTot = 0;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 0;
                data.nTimePointSig = 0;
                data.tIntervals = {};
                
            case 'Moff'
                data.nPosClustersTot = 0;
                data.nNegClustersTot = 0;
                data.nPosClustersSig = 0;
                data.nNegClustersSig = 0;
                data.nTimePointSig = 0;
                data.tIntervals = {};
                
                
        end
        
        
end
[sigTimeSec,sigTimeIdx,sigBinaryTime] = timeEval(t, data.tIntervals);
data.sigTimeSec = sigTimeSec;
data.sigTimeIdx = sigTimeIdx;
data.sigBinaryTime = sigBinaryTime;

    function closest_idxs = closest_index(time, target_values)
        for i = 1:length(target_values)
            target_value = target_values(i);
            differences = abs(time - target_value);   % Calculate the absolute differences
            [~, closest_idx] = min(differences);        % Find the index of the minimum difference
            closest_idxs(i) = closest_idx;
        end
    end

    function [timeSec,timeIdx,binaryTime] = timeEval(time, timeIntervals)
        binaryTime = zeros(1,length(time));
        
        if isempty(timeIntervals)
            timeSec = NaN;
            timeIdx = NaN;
        else
            for i = 1:length(timeIntervals)

                tstart = timeIntervals{i}(1);
                tend = timeIntervals{i}(2);
                %nPoints = 100*(tend-tstart)+1;
                %timeSec{i} = linspace(tstart,tend,nPoints);
                % timeIdx{i} = closest_index(time, timeSec{i});
                tstartIDX = closest_index(time, tstart);
                tendIDX = closest_index(time, tend);
                timeIdx{i} = tstartIDX:tendIDX;
                binaryTime(timeIdx{i}) = 1;
            end
        end
        timeSec = timeIntervals;
    end

    % function [timeSec,timeIdx,binaryTime] = timeEval(time, timeIntervals)
    %     binaryTime = zeros(1,length(time));
    % 
    %     if isempty(timeIntervals)
    %         timeSec = NaN;
    %         timeIdx = NaN;
    %     else
    %         for i = 1:length(timeIntervals)
    % 
    %             tstart = timeIntervals{i}(1);
    %             tend = timeIntervals{i}(2);
    %             nPoints = 100*(tend-tstart)+1;
    %             timeSec{i} = linspace(tstart,tend,nPoints);
    %             timeIdx{i} = closest_index(time, timeSec{i});
    %             binaryTime(timeIdx{i}) = 1;
    %         end
    %     end
    % end



end