%% pitchshift function
%the function takes the input vector
%fs is the sampling frequency

function [outputvector] = pitchShift(inputVector, fs, windowSize, hopSize, step)
%% parameters
x = inputvector;
length = size(x);
%find max value and which freq it's at, aswell as the fft signal
[fftSignal, maxFreq, maxFreqBin] = fftSignal(x,fs);
%Hanning window for overlap-add 
wn = hann(winSize*2+1); 
wn = wn(2:2:end);








end
