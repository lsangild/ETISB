% function dec = myh2d( hex , m, n)
% 
%   Inputs :
%       hex is hexadecimal number - e.g. '0xABCD'
%       m and n are positive integers and m+n=16 (16 bits)
% 
%   Outputs :
%       dec is a decimal number (Matlab double format)
%   
function dec = myh2d( hex, n, m )

if n+m ~= 16
    disp('OBS: m+n sum should be 16');
    return
end

hex(1:2) = [];   % remove '0x' from string

% Insert own code..
% HINT : You may use matlab function "hex2dec" (but note that it converts to
% unsigned integer!)
hexVal = uint16(hex2dec(hex));

if hexVal < 32768
    dec = (double(hexVal)*2^-m); % Posiktive value
else % Negative value
    decTmp = int16(bitcmp(hexVal) + 1); %Two's complement
    dec = -double(decTmp)*2^-m;
end


end


