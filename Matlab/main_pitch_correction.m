%% picth correction project

%% Generate sine wave with freq f.
f=400;
Amp=1;
ts=1/48000;
T=6;
t=0:ts:(T - ts);
y=sin(2*pi*f*t);
%plot(t,y)
audiowrite('400HzSinus.wav',y,48000)

%% listen to the tone.
[x,fs]=audioread('400HzSinus.wav');
soundsc(y)
%%
xfft=fft(y);
%find max value
P2 = abs(xfft/length(x));
P1 = P2(1:(length(x)/2 + 1));
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(length(x)/2))/length(x);

[~, index] = max(P1);

frequency = f(index);

%%
bin=fs/length(x);
Y = fft(x);
L=length(x);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%
[fftSignal, maxFreq, maxFreqBin] = fftSignal(x,fs);