function data = loadSignificantData(condition,t)

% Data saved by Johanna Wilroth from the command window after using the
% function ft_clusterplot(cfg, stat).

switch condition
    
    case 'Ton'
        data.nPosClustersTot = 2;
        data.nNegClustersTot = 3;
        data.nPosClustersSig = 2;
        data.nNegClustersSig = 2;
        data.nTimePointSig = 44;
        data.tIntervals = {[-0.0009,0.0691],[0.0691,0.1591],[0.1791,0.2691],[0.2791,0.4291]};
        
    case 'Mon'
        data.nPosClustersTot = 2;
        data.nNegClustersTot = 3;
        data.nPosClustersSig = 1;
        data.nNegClustersSig = 2;
        data.nTimePointSig = 50;
        data.tIntervals = {[-0.0009,0.0691],[0.2391,0.3191],[0.3591,0.4891]};
        
        
    case 'Toff'
        data.nPosClustersTot = 2;
        data.nNegClustersTot = 3;
        data.nPosClustersSig = 2;
        data.nNegClustersSig = 2;
        data.nTimePointSig = 42;
        data.tIntervals = {[-0.0009,0.0491],[0.0791,0.1491],[0.1791,0.2691],[0.2891,0.4091]};
        
    case 'Moff'
        data.nPosClustersTot = 2;
        data.nNegClustersTot = 3;
        data.nPosClustersSig = 0;
        data.nNegClustersSig = 1;
        data.nTimePointSig = 8;
        data.tIntervals = {[0.2491,0.3191]};
        
        
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