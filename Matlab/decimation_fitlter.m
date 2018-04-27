%% decimation
%makes the lowpasser filter, chosen IIR, to get less coefficient and less
%calculation on the DSP
cutoff = 1050;
stop = 2400;
fs = 48000;

Wn = [cutoff/fs, stop/fs];
[b,a] = butter(4, cutoff/fs, 'low')

freqz(b,a)
%% scalering af filter coef så de passer på Q1.16
%b coef er øverste række
%a coef er nederste række
scaledcoef =[b/max([b a]); a/max([b a])]

%% signal to be filterde 
clear, clc
[x,fs]=audioread('400HzSinus.wav');


%% filtering process aswell as downsampling 

xfiltert = filter(b, a, x);

y = downsample(xfiltert, 10)

%% test af det nyes signal
%soundsc(y, fs/10)
[xfft, maxFreq, maxFreqBin] = fftSignal(y,fs/10);

%% test af det gamle signal
%soundsc(x, fs)
[xfft, maxFreq, maxFreqBin] = fftSignal(x,fs);