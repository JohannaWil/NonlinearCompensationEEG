function cfg = nonlinMethod(y, yhat, labels, config)

% The binning-based nonlinear compensation method presented in:

    % J. Wilroth, E. Alickovic, M.A. Skoglund, C. Signoret, J. Rönnberg and 
    % M. Enqvist. "Improving Tracking of Selective Attention in Hearing Aid Users: 
    % The role of Noise Reduction and Nonlinearity Compensation". Submitted
    % to eNeuro, December 2024.
    
% Code written by Johanna Wilroth (johanna.wilroth@liu.se), July 2024.

% INPUT:
%       y:      Measured EEG data                       (nCh, nSamples)
%       yhat:   Predicted EEG data after TRF analysis   (nCh, nSamples)
%       labels: Channel labels in cell format           64x1 cell
%       config: Can be downloaded at XXX

% OUTPUT: cfg struct with fields:
%       Yorig       (nCh,nSamples)      Same as input y
%       Yhat        (nCh,nSamples)      Same as input yhat
%       Ynew        (nCh,nSamples)      New (compensated) EEG data after the
%                                       binning-based nonlinear compensation method
%       labels      nChx1 cell           Same as input labels
%       config                          Same as input config
%       badChannels []                  String of bad channels
%       bins        nChx1, 1xnBins      Original samples in each bin
%       binsNew     nChx1, 1xnBins      Compensated samples in each bin
%       f           nChx1               Expected linear trend between reference bins  
%       res         nChx1, 1xnBins      Residuels (error) between mean value in each
%                                       bin and the expected linear trend
%                                       f. Original EEG data.
%       resNew      nChx1, 1xnBins       Residuels (error) between mean value in each
%                                       bin and the expected linear trend
%                                       f. Compensated EEG data.
%       xBoarders   nChx1, (1xnBins+1)  x-value of the boarders of the bins
%       xMeanBins   nChx1, 1xnBins      Mean x-value in each bin
%       yMeanBins   nChx1, 1xnBins      Mean y-value in each bin. Original
%                                       EEG data.
%       yNewMeanBins    nChx1, 1xnBins  Mean y-value in each bin.
%                                       Compensated EEG data
%       xGrid       nChx1               Grid of x-values

% **********************************************************************

nChannels = size(y,1);  % Number of channels
nSampels = size(y,2);   % Number of samples
nBins = config.nBins;   % Number of bins

% Number of outliers. Will be put to zero.
nOutliers = config.nOutliers;

% Indices/samples in each bin
indices_per_bin = config.indices_per_bin;

ynew = zeros(nChannels,nSampels);
bins = [];

% Note if any channels are bad
badCh = [];

for ch = 1:nChannels
    
    y_ch = y(ch,:);
    yhat_ch = yhat(ch,:);
    sorted = sort(yhat_ch);

    %Compute the x-position of the vertical binning lines
    xBoarders = linspace(sorted(nOutliers),sorted(end-nOutliers),nBins+1);  %% t previous

    % Add samples to the bins
    bins = addSampToBins(bins,nBins,nSampels,xBoarders,y_ch,yhat_ch);
    
    % Compute mean value in each bin
    yMeanBin = zeros(1,nBins); %mean y-value
    xMeanBin = zeros(1,nBins); %mean x-value

    for j = 1:nBins
        yMeanBin(j) = mean(bins{j});
        xMeanBin(j) = xBoarders(j) + abs(xBoarders(j)-xBoarders(j+1))/2;
    end

    % Grid on x-axis
    xGrid = linspace(xBoarders(1),xBoarders(end),indices_per_bin*nBins);

    % Choose which two bins to be used as references. Compute the linear
    % trend f between the mean y-value in these two reference bins.
    [refBins, f] = computeLinearTrend(nBins,xMeanBin,yMeanBin,xGrid);

    % Compute the resiuduals (res) between the mean y-value and
    % the linear trend in each bin.
    res_ch = zeros(1,nBins);
    xGridMeanBin = zeros(1,nBins);
    xGridMeanBin(1) = indices_per_bin/2;
    for j = 1:nBins
        res_ch(j) = yMeanBin(j) - f(xGridMeanBin(j));
        xGridMeanBin(j+1) = xGridMeanBin(j) + indices_per_bin;
    end

   %% Do the same procedure for yNew
    % Compute Ynew 
    y_ch_new = computeYnew(nSampels,nBins,bins,y_ch,refBins,yMeanBin,xGridMeanBin,res_ch,f);
    
    % Compute the mean yNew value in each bin
    binsNew = bins;
    yNewMeanBin = zeros(1,nBins);
    for b = 1:nBins
        if b ~= refBins(1) && b ~= refBins(2)
            binsNew{b}(:) = binsNew{b}(:) - res_ch(b);
        end
        yNewMeanBin(b) = mean(binsNew{b});
    end
   

    % Compute the resiuduals (res) between the mean yNew-value and
    % the linear trend in each bin.
    resNew_ch = zeros(1,nBins);
    for j = 1:nBins
        range_tmp = [xMeanBin(j)-100 xMeanBin(j)+100];
        b = find(xGrid > range_tmp(1) & xGrid < range_tmp(2));
        resNew_ch(j) = yNewMeanBin(j) - f(b(1));
    end

    % Note bad channels
    if all(y_ch_new == 0)
        badCh = [badCh,{data.labels(ch,:)}];
    end

    ynew(ch,:) = y_ch_new;
    cfg.xMeanBins{ch,1} = xMeanBin;
    cfg.yMeanBins{ch,1} = yMeanBin;
    cfg.yNewMeanBins{ch,1} = yNewMeanBin;
    cfg.xGrid{ch,1} = xGrid;
    cfg.xBoarders{ch,1} = xBoarders;
    cfg.f{ch,1} = f;
    cfg.res{ch,1} = res_ch;
    cfg.resNew{ch,1} = resNew_ch;
    cfg.bins{ch,1} = bins;
    cfg.binsNew{ch,1} = binsNew;

    if ch == 48
        plotFig2(yhat_ch,y_ch,y_ch_new,labels{ch},xBoarders,xMeanBin,yMeanBin,yNewMeanBin,xGrid,f,config)
    end
end

cfg.config = config;
cfg.Yorig = y;
cfg.Yhat = yhat;
cfg.Ynew = ynew;
cfg.labels = labels;
cfg.badChannels = badCh;

end

function bins = addSampToBins(bins,nBins,nSampels,xBoarders,y_ch,yhat_ch)
  ind = ones(1,nBins);
  for i = 1:nSampels % For each sample
      for j = 1:nBins % For each bin
          leftBoarder = xBoarders(j);      % Left binning boarder for bin j
          rightBoarder = xBoarders(j+1);    % Right binning boarder for bin j

          % If yhat sample i is in bin j
          if yhat_ch(i) > leftBoarder && yhat_ch(i) < rightBoarder
              bins{j}(ind(j)) = y_ch(i);
              ind(j) = ind(j) + 1;
              break;
          end
      end
  end
end

function [refBins, f] = computeLinearTrend(nBins,xMeanBin,yMeanBin,xGrid)
s1 = floor(nBins/2);

% Choose which bins to use as middle bins
if mod(nBins,2)==0 %If even number of bins
    refBins = [nBins/2 nBins/2+1];
    p = polyfit([xMeanBin(s1) xMeanBin(s1+1)], [yMeanBin(s1) yMeanBin(s1+1)], 1);
else
    refBins = [s1 s1+2];
    p = polyfit([xMeanBin(s1) xMeanBin(s1+2)], [yMeanBin(s1) yMeanBin(s1+2)], 1);
end

% The linear trend between the mean value in the two chosen reference bins
f = polyval(p,xGrid); 

end

function y_ch_new = computeYnew(nSampels,nBins,bins,y_ch,refBins,yMeanBin,xGridMeanBin,res_ch,f)
y_ch_new = zeros(1,nSampels);
for j = 1:nSampels
    for i = 1:nBins
        temp = find(bins{i} == y_ch(j));
        if ~isempty(temp)
            if i ~= refBins(1) && i ~= refBins(2)
                if i < refBins(1)
                    if yMeanBin(i) < f(xGridMeanBin(i))
                        y_ch_new(j) = y_ch(j) + res_ch(i);
                    else
                        y_ch_new(j) = y_ch(j) - res_ch(i);
                    end
                else
                    if yMeanBin(i) < f(xGridMeanBin(i))
                        y_ch_new(j) = y_ch(j) - res_ch(i);
                    else
                        y_ch_new(j) = y_ch(j) + res_ch(i);
                    end
                end
            else
                y_ch_new(j) = y_ch(j);
                break;
            end
        end
    end
end

end