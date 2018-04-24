%% Load audio
[x, fs] = audioread('400HzSinus.wav');

%% Plot fft
plotFFT(x, fs);

%% Find new fs
[newFs] = shiftSimpleSine(x, fs);

[t, maxFreqNew, r] = fftSignal(x, fsNew);
disp(['Found new as ', num2str(maxFreqNew), ' Hz']);