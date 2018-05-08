%% picth correction project
%%
%%
%This is currently a test matlab script the main which calls the function
%is in testShiftSimpleSine.m
%
%
%
%
%
%
%
%
%% Generate sine wave with freq f.
f=470;
Amp=1;
ts=1/48000;
T=6;
t=0:ts:(T - ts);
y=sin(2*pi*f*t);
%plot(t,y)
audiowrite('470HzSinus.wav',y,48000)

%% listen to the tone.
clear, clc
[x,fs]=audioread('400HzSinus.wav');
%soundsc(x,fs)
%%
%x=new_x';
xfft=fft(x);
%find max value
P2 = abs(xfft/length(x));
P1 = P2(1:(length(x)/2 + 1));
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(length(x)/2))/length(x);

[~, index] = max(P1);

frequency = f(index);

%%
x=new_x;
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
[xfft, maxFreq, maxFreqBin] = fftSignal(x,fs);

%% can change the freq, but not in a way we want it to. 
T=length(x)/fs; %6 sec long
hz10 = 10;
%change the freq to 600Hz, so add 200Hz
f_add=200*6; %= 10 hz
f_add = f_add * hz10
%add this to the old samplings freq we get
fs_new=fs-f_add;

% the amount of samples the new signal needs is 
N=T*fs_new;

% generate a new vector which can contain the full signal
% and generates a vector size N with value going from 1, length(x)
vec=linspace(1, length(x), N);

% do interpolation
new_x = interp1(1:length(x), x, vec);

[fftSignal, maxFreq, maxFreqBin] = fftSignal(new_x',fs);

%%
plotFFT(new_x,fs)
%%
[newFs] = shiftSimpleSine(x, fs);
[xfft, maxFreq, maxFreqBin] = fftSignal(x,newFs);
%%
N_add=length(x)*(newFs/fs) - length(x);
%find phase




