function [y, newPhase] = genSine(len, Fs, freq, phase, amplitude)
  % Find number of periods
  T = 1 / freq;
  soundTime = (1 / Fs) * len;
  N_T = soundTime / T;
  
  % Find number of points per period
  N = len/N_T;
  
  % Generate one period sine for the points
  t = (0:(round(N) - 1)) ./ Fs;
  y_1 = amplitude .* sin(2 * pi * freq * t + phase)';
  
  % Add the same sine to the signal, flooring the number of periods
  for n = 0:(floor(N_T) - 1)
    y((n * round(N) + 1):((n + 1) * round(N))) = y_1;
  end
  
  % Add the missing number of points (+1 to know phase of next sine)
  y((floor(N_T) * round(N) + 1):(len + 1)) = y_1(1:(len - length(y) + 1));
  y_phase = y(end);
  y(end) = [];
  
  % Find new phase
  newPhase = asin(y_phase / max(abs(y_1)));
  if y_phase > 0
    if y_phase > y(end)
      newPhase = newPhase;
    else
      newPhase = - newPhase + pi;
    end
  else
    if y_phase > y(end)
      newPhase = newPhase;
    else
      newPhase = - newPhase - pi;
    end
  end
  
  disp(newPhase);
end