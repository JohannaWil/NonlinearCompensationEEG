% Code to plot the figures in:   
    % J. Wilroth, E. Alickovic, M.A. Skoglund, C. Signoret, J. Rönnberg and 
    % M. Enqvist. "Improving Tracking of Selective Attention in Hearing Aid Users: 
    % The role of Noise Reduction and Nonlinearity Compensation". Submitted
    % to eNeuro, December 2024.
    
    % Code written by Johanna Wilroth (johanna.wilroth@liu.se), July 2024

clear; clc; close all;
rng default;

todaysdate = string(datetime('now','TimeZone','local',"Format","MMMM_d_HHmm"));
mkdir(fullfile("results",todaysdate));

tempstr = fileread("config.json"); % Read config file.
config = jsondecode(tempstr); % Decode JSON format to values.
addpath(config.fieldtripdir)
addpath('helpFunctions\')
addpath('Data\')
addpath('plot_topography\')

% Load data
load('data.mat')
time = data.TRFdata.time;
stimDelay = computeStimDelay(config);

time.tmin = time.tmin + stimDelay;
time.tmax = time.tmax + stimDelay;
t = linspace(time.tmin,time.tmax,time.nsamples);
nSubs = length(data.TRFdata.subjects); 
labels = data.labels;

% Do the permutation significance test...
if config.computeSignificance 
    % Grand average across all channels (Figure 4)
    clusterInfo = computeSignificane(config,data,labels,time,false,data.channelGroups);  
    
    % With channel groups (Figure 5)
    clusterInfo_chGroups = computeSignificane(config,data,labels,time,true,data.channelGroups);   

else % ...or load already saved significance data (by author)
    load('significanceData_author.mat');
    load('significanceData_chGroups_author.mat');
end

%% Plot figures

plotAbstractTRF(config,clusterInfo,data,t,time)

plotFig4(config,clusterInfo,data,t,time);

TRFdata = plotFig5(config,data,time,clusterInfo_chGroups);

plotFig6(config,TRFdata,data.channelGroups);

plotFig7a(config,data.residuals,labels);

plotFig7b(config,data.rawResiduals,labels); 

plotFig8(config,TRFdata,t,data.channelGroups);
 
plotFig9(config,data.snr,data.channelGroups)

plotFig10(config,data.behavioralData);


