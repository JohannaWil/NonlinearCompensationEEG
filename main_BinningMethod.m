% Code to illustrate the binning-based nonlinear compensation method presented in:

    % J. Wilroth, E. Alickovic, M.A. Skoglund, C. Signoret, J. Rönnberg and 
    % M. Enqvist. "Improving Tracking of Selective Attention in Hearing Aid Users: 
    % The role of Noise Reduction and Nonlinearity Compensation". Submitted
    % to eNeuro, December 2024.
    
    % Code written by Johanna Wilroth (johanna.wilroth@liu.se), July 2024
 
    % EEG data for one subject (one trial) can be downloaded at: xxx in the format:
    %       Yorig (64,3100):    Measured EEG data
    %       Yhat  (64,3100):    Predicted EEG data after TRF analysis with the
    %                           MNE-boosting algorithm presented in the Eeelbrain toolbox in Python
    %                           (Brodbeck C, Das P, Gillis M, Kulasingham JP, Bhattasali S, Gaston P,
    %                           Resnik P, Simon JZ. Eelbrain, a Python toolkit for time-continuous analysis
    %                           with temporal response functions. Elife. 2023 Nov 29;12:e85012.
    %                           doi: 10.7554/eLife.85012. PMID: 38018501; PMCID: PMC10783870.)


    % For variable illustration, see variableExplanationsBinningMethod.jpg

clear; clc; close all;
rng default;

todaysdate = string(datetime('now','TimeZone','local',"Format","MMMM_d_HHmm"));
mkdir(fullfile("results",todaysdate));

tempstr = fileread("config.json"); % Read config file.
config = jsondecode(tempstr); % Decode JSON format to values.

% Add paths to help functions and data
addpath('helpFunctions\')
addpath('Data\')

% Load data
load('EEG.mat')
load('labels.mat')

config.todaysdate = todaysdate;
config.saveFolder = todaysdate; % Folder to save figures

%%
close all;
cfg = nonlinMethod(Yorig, Yhat, labels, config);