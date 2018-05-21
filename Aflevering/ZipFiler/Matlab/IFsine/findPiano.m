function pianoFreq = findPiano(freq)
  %%%
  % Finds the nearest piano tone
  %%%
  
  % Load possible frequencies
  pianoFreqs = load('../PianoFreqs.dat');
  
  % Find nearest
  [~, index] = min(abs(pianoFreqs - freq));
  pianoFreq = pianoFreqs(index);
end