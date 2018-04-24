function [newFs] = shiftSimpleSine(signal, fs)

%% Find max
[xfft, maxFreq, maxFreqBin] = fftSignal(signal, fs);

%% Find nearest piano tone
pianoFreq = [349.228, 391.995, 440, 493.883, 523.251];
[~, index] = min(abs(pianoFreq - maxFreq));
newTone = pianoFreq(index);

%% Change fs
newFs = (newTone/maxFreq) * fs;