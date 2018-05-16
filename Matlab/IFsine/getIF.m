function z = getIF(y, Fs, scale)
  %%%%%
  % Returns the instantaneous frequency for any time
  % y is the input signal in time domain
  % Fs is the sampling frequency
  % scale is the scaling, primarily used for debugging and comparison with CC
  % Set scale to pi for normal scaling, 2^15 for CC comparison
  
  % hilbert
  N = length(y);
  y=fft(y);
  % Division by 2, in stead of multiplication to keep everything below 1 on crosscore
  y=[y(1,:)/2;
     y(2:N/2,:);
     y(N/2+1,:)./2;
     zeros(N/2-1, 1)];
  z=ifft(y);

  %% Angle
  z = atan2(imag(z),real(z));

  %% Unwrap
  % https://stackoverflow.com/questions/15634400/continous-angles-in-c-eq-unwrap-function-in-matlab
  % Scale to fit CC
  z = (z/pi)*scale;

  for i = 2:N
    x = z(i - 1) - z(i) + scale;
    y = 2 * scale;
    dif(i) = rem(x, y);
    if (dif(i) < 0)
      dif(i) = dif(i) + 2 * scale;
    end
    z(i) = (dif(i) - scale);
    z(i) = z(i - 1) - z(i);
  end

  %% Diff
  for k = 2:(numel(z))
    z(k - 1, 1) = z(k) - z(k - 1);
  end
  % Remove last diff
  z(end) = [];

  z = Fs/(2*pi)*z;
end