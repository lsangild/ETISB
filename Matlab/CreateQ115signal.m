fs = 48000;
Amp=0.8;
ts=1/fs;
T = 0.04267/4;
t=0:ts:T - 1/fs;

scale = Amp;
y=scale.*sin(2*pi*888*t)';

% gem i fil
y16 = y*2^15;
fid = fopen('x_signal888.txt', 'w');
for i=1:length(y16)
    xtext = num2str(round(y16(i)));
    fprintf(fid, '%s,\r\n', xtext);
end
fclose(fid);