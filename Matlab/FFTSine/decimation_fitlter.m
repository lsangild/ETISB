%% decimation
%makes the lowpasser filter, chosen IIR, to get less coefficient and less
%calculation on the DSP
cutoff = 1200;
stop = 2400;
fs = 48000;

Wn = [cutoff/fs, stop/fs];
[b,a] = butter(2, cutoff/fs, 'low');

freqz(b,a)
%% scalering af filter coef så de passer på Q1.16
%b coef er øverste række
%a coef er nederste række
scaledcoef =[b/max(abs([b a])); a/max(abs([b a]))]

%% signal to be filterde 
clear, clc
[x,fs]=audioread('400HzSinus.wav');


%% filtering process aswell as downsampling 

xfiltert = filter(b, a, x);

y = downsample(xfiltert, 10);

%% test af det nyes signal
%soundsc(y, fs/10)
[xfft, maxFreq, maxFreqBin] = fftSignal(y,fs/10);
%%
for r=1 : 2
    for i=1 : length(scaledcoef)
        hex = myd2h_kims( scaledcoef(r,i), 1, 15 );
        dec(r,i) = myh2d( hex, 1, 15);
    end
    
end

    


%% test af det gamle signal
%soundsc(x, fs)
[xfft, maxFreq, maxFreqBin] = fftSignal(x,fs);