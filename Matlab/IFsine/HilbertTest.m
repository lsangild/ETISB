%% Create tester
f=470;
Amp=1;
Fs = 48000;
ts=1/Fs;
T=0.04267/4;
t=0:ts:(T - ts);
y=sin(2*pi*f*t)';

%% Load data in stead
y = csvread('../y_signal470.txt');
y(:,2) = []; % Remove extra column

%% Calc with built in functions
%z = hilbert(y);
%instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));

%% Home made
% hilbert
N = length(t);
W = 1;
%y=fft(y);
% Division by 2, in stead of multiplication to keep everything below 1 on crosscore
y=[y(1,:)/2;
   y(2:N/2,:);
   y(N/2+1,:)./2;
   zeros(N/2-1, W)];
z=ifft(y);

%% read in file from CC which is already ifft
load('../ifft_CC.mat');
z=ifft_CC;
%%z(:,2) = []; % Remove extra column
%% Do easy way
instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));
za = angle(z);
zau = unwrap(angle(z));
zaud = diff(unwrap(angle(z)));

%% Angle
z = atan2(imag(z),real(z));
plot(z)
%% read in data which has already been taken argument off
z = csvread('../y_argument.txt');
z(:,2) = []; % Remove extra column
%z = z/(2^15) * pi;
plot(z)
%% Unwrap
% https://stackoverflow.com/questions/15634400/continous-angles-in-c-eq-unwrap-function-in-matlab
for i = 2:N
  dif = rem(z(i - 1) - z(i) + 2^15, 2* (2^15));
  if (dif < 0)
    dif = dif + 2 * 2^15;
  end
  z(i) = dif - 2^15;
  z(i) = z(i - 1) - z(i);
end

%%
z = csvread('../y_unwrapping.txt');
z(:,2) = []; % Remove extra column
plot(z)
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

disp(mean(z(100:end-100))/(2^15)*pi)
