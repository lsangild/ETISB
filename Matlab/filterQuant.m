cutoff = 1024;
stop = 4800;
fs= 48000;

[b,a] = butter(2,cutoff/(fs/2));

[H, W] = freqz(b,a);
freqz(b,a)
%% kvantisering

for i=1 : length(b)
    hex = myd2h_kims( b(i), 1, 15 )
    dec = myh2d( hex, 1, 15)
    bcoef(i) = dec; 
end
anew=a/(max(abs(a)))
for i=1 : length(a)
    hex = myd2h_kims( anew(i), 1, 15 )
    dec = myh2d( hex, 1, 15)
    acoef(i) = dec * (max(abs(a))); 
end

%%
freqz(b,a), hold on
[H1,W1] = freqz(bcoef,acoef);

lines = findall(gcf,'type','line');
set(lines(1),'color','red')
set(lines(2),'color','green')
set(lines(3),'color','red')
set(lines(4),'color','green')
%%
Htotal = H-H1;
Wtotal = W - W1;