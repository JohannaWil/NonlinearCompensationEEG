function stimDelay = computeStimDelay(config)

% This script computes the stim delay between the actual stimuli presented
% over the audio signal path (channel 1):
%       RME stimulus soundcard -> ProTools -> Dante system -> Speaker 2.2 from microphone -> DPA microphone -> RME recording soundcard
% and event markers fed directly into the EEG recordings (channel 2):
%       RME stimulus soundcard -> RME recording soundcard


% Available test data from two recordings (dual signal path recording):
%   test1:  simDelay_data1.wav
%   test2:  simDelay_data2.wav 

stimLength = 33; % 33s

% Load the dual signal path recordings (assuming you've already done this)
% For demonstration, assuming that the first channel is the microphone-recorded signal
% and the second channel is the direct signal from the soundcard.

delay_test = cell(1,2);
delay_blockAve = zeros(1,2);

for test = 1:2
    filename = ['simDelay_data',num2str(test),'.wav'];
    filePath = fullfile(config.datadir, filename);

    % Load the audio file
    [audioData, sampleRate] = audioread(filePath);

    nSamples = length(audioData);
    nBlocks = floor(nSamples/(stimLength*sampleRate));

    idx1 = 1;
    idx2 = stimLength*sampleRate;

    for b = 1:nBlocks
        longPath = audioData(idx1:idx2, 1);
        shortPath = audioData(idx1:idx2, 2);

        % Cross-correlation to find the time lag
        [crossCorr, lags] = xcorr(longPath, shortPath);

        % Find the index of the maximum cross-correlation
        [~, I] = max(abs(crossCorr));

        % Determine the time lag in samples
        timeLagInSamples = lags(I);

        % Convert the time lag from samples to seconds
        timeLagInSeconds = timeLagInSamples / sampleRate;

        delay_test{test}(b) =  timeLagInSeconds; % in seconds

        idx1 = idx2 + 1;
        idx2 = idx2 + stimLength*sampleRate;

    end

    delay_blockAve(test) = mean(delay_test{test});

end

stimDelay = mean(delay_blockAve);

fprintf('The time lag between the signals is %.6f ms.\n', stimDelay*1000);



end