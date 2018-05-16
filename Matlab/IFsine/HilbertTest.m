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

% Create figure for the IF of different blocks
figure
hold on

% Display target, input, new frequencies
disp("Input\t\tTarget\tNew");

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
  
  % Find frequency
  freq(i + 1) = (mean(z(floor(length(z)/3):end-ceil(length(z)/3)))/(scale))*pi;
  
  % Find nearest C-major frequency and create signal
  pianoFreq = findPiano(freq(i + 1));
  [out((i * blocksize + 1):((i + 1) * blocksize)), phase] = genSine(blocksize, Fs, pianoFreq, phase, max(y_block));

  % Check the frequency of the new signal
  z_new = getIF(out((i * blocksize + 1):((i + 1) * blocksize))', Fs, scale);
  newFreq(i + 1) = (mean(z_new(floor(length(z_new)/3):end-ceil(length(z_new)/3)))/(scale))*pi;

  % Print the result
  disp([num2str(freq(i + 1)), "\t", num2str(pianoFreq), "\t", num2str(newFreq(i + 1))])
  
  % Plotting the IF of the different blocks
  plot([i*blocksize + 1:((i+1)*blocksize - 1)],z_new);
end

% Plot output
figure
plot(out);
