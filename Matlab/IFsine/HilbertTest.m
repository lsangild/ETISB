%% Load data in stead
Fs = 48000;
y = csvread('x_signal245.txt');
y(:,2) = []; % Remove extra column
blocksize = 512;

% Check if blocksize is valid
assert(ismember(blocksize, [2^7, 2^8, 2^9, 2^10, 2^11]) && blocksize <= length(y));

% Create window
h = hamming(blocksize);

% Initial phase offset
phase = 0;

for i = 0:(length(y)/blocksize - 1)
  y_block = y((i * blocksize + 1):((i + 1) * blocksize));

  ts = 1/Fs;
  T = length(y_block)*ts;
  t = 0:ts:(T - ts);

  % Apply window
  %y_block = y_block .* h;

  %% Home made
  scale = 2^15;
  z = getIF(y_block, Fs, scale);
  
  freq(i + 1) = (mean(z(floor(length(z)/3):end-ceil(length(z)/3)))/(scale))*pi;
  
  pianoFreq = findPiano(freq(i + 1));
  [out((i * blocksize + 1):((i + 1) * blocksize)), phase] = genSine(blocksize, Fs, pianoFreq, phase, max(y_block));
  disp(["Input frequency: ", num2str(freq(i + 1)), " Hz"])
  z_new = getIF(out((i * blocksize + 1):((i + 1) * blocksize))', Fs, scale);
  newFreq(i + 1) = (mean(z_new(floor(length(z_new)/3):end-ceil(length(z_new)/3)))/(scale))*pi;
  disp(["New frequency: ", num2str(newFreq(i + 1)), " Hz"])
end


plot(out);
