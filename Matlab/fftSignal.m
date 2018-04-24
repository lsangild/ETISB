%% fft function and max value
%takes the input signal
%output the freq with max value
%output the bin corrosponding to freq with max value
%output fft of input signal

function [fftSignal, maxFreq, maxFreqBin] = fftSignal(inputSignal,fs)
%fft the signal
fftSignal=fft(inputSignal);

%find max value
P2 = abs(fftSignal/length(inputSignal));
P1 = P2(1:(length(inputSignal)/2 + 1));
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(length(inputSignal)/2))/length(inputSignal);

[~, maxFreqBin] = max(P1);

maxFreq = f(maxFreqBin);

end
