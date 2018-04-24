%% Load audio
[x, fs] = audioread('420HzSinus.wav');

%% Plot fft
plotFFT(x, fs);

%% Find new fs
[newFs, newSignal] = shiftSimpleSine(x, fs);

%plotFFT(newSignal, newFs)

figure
plot(x);
plot(x, '.');
hold on
plot(newSignal, 'o')
xlim([length(x) - 10, length(x) + 10])
xlabel('Sample number');
ylabel('Amplitude')
legend('Original signal', 'Original with added samples')
grid on
title('Addition of samples at the end of too low frequency signal.')