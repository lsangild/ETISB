%% Load audio
[x, fs] = audioread('400HzSinus.wav');

%% Plot fft
%plotFFT(x, fs);

%% Find new fs
[newFs, newSignal] = shiftSimpleSine(x, fs);

plotFFT(newSignal, newFs)