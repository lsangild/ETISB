function plotIF(y, Fs);
  z = hilbert(y);
  t = 0:1/Fs:2-1/Fs;
  instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));
  plot(t(2:end),instfreq)
  xlabel('Time')
  ylabel('Hz')
  grid on
  title('Instantaneous Frequency')
end