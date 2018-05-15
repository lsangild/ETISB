%% Create tester
f = 888;
Amp = 1;
Fs = 48000;
ts = 1/Fs;
T = 0.04267/4;
t = 0:ts:(T - ts);
y = sin(2*pi*f*t)';

%% Load data in stead
y = csvread('x_signal888.txt');
y(:,2) = []; % Remove extra column

%% Calc with built in functions
%z = hilbert(y);
%instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));

%% Home made
% hilbert
N = length(t);
W = 1;
y=fft(y);
% Division by 2, in stead of multiplication to keep everything below 1 on crosscore
y=[y(1,:)/2;
   y(2:N/2,:);
   y(N/2+1,:)./2;
   zeros(N/2-1, W)];
z=ifft(y);

%% read in file from CC which is already ifft
load('../ifft_CC_888.mat');
z=ifft_CC;
plot(abs(z))
%z(:,2) = []; % Remove extra column
%% Do easy way
instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));
za = angle(z);
zau = unwrap(angle(z));
zaud = diff(unwrap(angle(z)));

%% Angle
z = atan2(imag(z),real(z));

%% read in data which has already been taken argument off
%z = csvread('../y_argument.txt');
%z(:,2) = []; % Remove extra column

%% Unwrap
% https://stackoverflow.com/questions/15634400/continous-angles-in-c-eq-unwrap-function-in-matlab
% Scale to fit CC
z = (z/pi)*2^15;

for i = 2:N
  %dif = rem(z(i - 1) - z(i) + pi, 2 * pi);
  x = z(i - 1) - z(i) + 2^15;
  y = 2 * 2^15;
  %dif = rem(z(i - 1) - z(i) + 2^15, 2 * (2^15));
  dif = rem(x, y);
  if (dif < 0)
    %dif = dif + 2 * pi;
    dif = dif + 2 * 2^15;
  end
  %z(i) = dif - pi;
  z(i) = (dif - 2^15);
  z(i) = z(i - 1) - z(i);
end

%% Diff
for k = 2:(numel(z))
  z(k - 1, 1) = z(k) - z(k - 1);
end
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

disp((mean(z(100:end-100))/(2^15))*pi)
%disp(mean(z(100:end-100)))