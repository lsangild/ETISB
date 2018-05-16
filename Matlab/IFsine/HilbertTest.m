%% Load data in stead
Fs = 48000;
y = csvread('x_signal222.txt');
y(:,2) = []; % Remove extra column
blocksize = 128;

% Check if blocksize is valid
assert(ismember(blocksize, [2^7, 2^8, 2^9, 2^10, 2^11]) && blocksize <= length(y));

% Create window
h = hamming(blocksize);

for i = 0:(length(y)/blocksize - 1)
  y_block = y((i * blocksize + 1):((i + 1) * blocksize));

  ts = 1/Fs;
  T = length(y_block)*ts;
  t = 0:ts:(T - ts);

  % Apply window
  y_block = y_block .* h;

  %% Home made
  scale = 2^15;
  z = getIF(y_block, Fs, scale);

  disp((mean(z(floor(length(z)/3):end-ceil(length(z)/3)))/(scale))*pi)
end