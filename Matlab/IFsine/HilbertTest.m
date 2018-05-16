%% Load data in stead
Fs = 48000;
y = csvread('x_signal470.txt');
y(:,2) = []; % Remove extra column

ts = 1/Fs;
T = length(y)*ts;
t = 0:ts:(T - ts);

%% Home made
scale = 2^15;
z = getIF(y, Fs, scale);

%% Plot
plot(t(2:end),z, '-r')
%hold on
%plot(t(2:end),instfreq)
xlabel('Time')
ylabel('Hz')
grid on
title('Instantaneous Frequency')

disp((mean(z(100:end-100))/(scale))*pi)