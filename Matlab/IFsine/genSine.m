function [y, newPhase] = genSine(len, Fs, freq, phase, amplitude)
  % Find number of periods
  T = 1 / freq;
  soundTime = (1 / Fs) * len;
  N_T = soundTime / T;
  
  % Find number of points per period
  N = len/N_T;
  
  % Generate one period sine for the points
  t = (0:(round(N) - 1)) ./ Fs;
  y_1 = amplitude .* sin(2 * pi * freq * t)';
  
  % Add the same sine to the signal, flooring the number of periods
  for n = 0:(floor(N_T) - 1)
    y((n * round(N) + 1):((n + 1) * round(N))) = y_1;
  end
  
  % Add the missing number of points
  y((floor(N_T) * round(N) + 1):len) = y_1(1:(len - length(y)));
end