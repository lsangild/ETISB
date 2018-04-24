function [newFs, newSignal] = shiftSimpleSine(signal, fs)
%% Takes the signal to change and the sample rate
%% Returns a new sample rate, and the original signal fitted to the new
%% frequency

%% Find original frequency
[xfft, maxFreq, maxFreqBin] = fftSignal(signal, fs);

%% Find nearest piano tone
pianoFreq = [349.228, 440, 493.883, 523.251];
[~, index] = min(abs(pianoFreq - maxFreq));
newTone = pianoFreq(index);

%% Change fs
newFs = (newTone/maxFreq) * fs;

%% Original frequency is higher than new frequency, remove samples
if (newTone < maxFreq)
  newSignal = signal(1:length(signal)*round(newTone/maxFreq));
%% Original frequency is lower than new frequency, add samples
else
  %% Find number of extra samples
  N_extra = round(length(signal)*(newFs/fs)) - length(signal);
  %% Find slope direction
  if (signal(end) > signal(end-1))
    dir = 1;
  elseif (signal(end) < signal(end-1))
    dir = -1;
  else
    error('No slope at end of signal');
  endif
  %% Find phase shift
  phase = asin(signal(end));
  if (dir == (-1))
    phase = pi - phase;
  endif
  tail = [1:1:N_extra]'.*(1/newFs);
  tail = sin(2*pi*newTone.*tail + phase);
  newSignal = [signal; tail];
endif
