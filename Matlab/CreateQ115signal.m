fs = 48000;
Amp=0.8;
ts=1/fs;
T = 500*0.04267;
t=0:ts:T - 1/fs;
t = t(1:(500*512));
f0 = 245;
f1 = 521;

y = chirp(t, f0, 5, f1);

%scale = Amp;
%y=scale.*sin(2*pi*f*t)';

% gem i fil
y16 = y*2^15;
fid = fopen('IFsine/x_chirp245_521.txt', 'w');

for i=1:length(y16)
    xtext = num2str(round(y16(i)));
    fprintf(fid, '%s,\r\n', xtext);
end
fclose(fid);