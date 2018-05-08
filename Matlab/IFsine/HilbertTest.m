% Create tester
f=470;
Amp=1;
Fs = 48000;
ts=1/Fs;
T=0.05;
t=0:ts:(T - ts);
y=sin(2*pi*f*t);

% Calc
z = hilbert(y);
instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));

% Plot
plot(t(2:end),instfreq)
xlabel('Time')
ylabel('Hz')
grid on
title('Instantaneous Frequency')