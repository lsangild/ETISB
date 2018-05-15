close all;
load('x_signal.txt')
load('y_signal.txt')

figure, 
subplot(2,1,1);
len = size(y_signal,1);
plot(x_signal(1:len))
title('Sweep input');
xlabel('n');
ylabel('x(n)');

subplot(2,1,2);
plot(y_signal)
title('Filtered output');
xlabel('n');
ylabel('y(n)');

load('fft_mag.txt')

figure,
subplot(2,1,1);
fftLen = 1024;
fftLen2 = fftLen/2; 
fftMag = abs(fft(x_signal))/fftLen2;
plot(fftMag(1:fftLen2));
title('FFT MATLAB Sweep');
xlabel('m');
ylabel('|Y(m)|');

subplot(2,1,2);
plot(fft_mag(1:fftLen2));
title('FFT CrossCore Sweep');
xlabel('m');
ylabel('|Y(m)|');
