%% Create tester
f=470;
Amp=1;
Fs = 48000;
ts=1/Fs;
T=0.05;
t=0:ts:(T - ts);
y=sin(2*pi*f*t)';

%% Calc with built in functions
%z = hilbert(y);
%instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));

%% Home made
% hilbert
N = 2400;
W = 1;
y=fft(y);
y=[y(1,:);
   2*y(2:N/2,:);
   y(N/2+1,:);
   zeros(N/2-1, W)];
z=ifft(y);

%% Do easy way
instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));
za = angle(z);
zau = unwrap(angle(z));
zaud = diff(unwrap(angle(z)));

%% Angle
z = atan2(imag(z),real(z));

%% Unwrap
for i = 2:N
  dif = rem(z(i - 1) - z(i) + pi, 2* pi);
  if (dif < 0)
    dif = dif + 2 * pi;
  endif
  z(i) = dif - pi;
  z(i) = z(i - 1) - z(i);
endfor

%% Diff
for k = 2:(numel(z))
  z(k - 1, 1) = z(k) - z(k - 1);
endfor
% Remove last diff
z(end) = [];

z = Fs/(2*pi)*z;

%% Plot
plot(t(2:end),z, '-r')
%hold on
%plot(t(2:end),instfreq)
xlabel('Time')
ylabel('Hz')
grid on
title('Instantaneous Frequency')

disp(mean(z(100:end-100)))
