% function hex = myd2h( dec , n, m)
% 
%   Inputs :
%       dec is a decimal number (Matlab double format)
%       n and m are positive integers and n+m=16 (16 bits)
% 
%   Outputs :
%       hex is hexadecimal number - e.g. '0xABCD'
%   
function hex = myd2h_kims( dec, n, m )

if dec < -32768  || dec > 32767 , % Overflow check - CHANGE LIMIT !
    disp('OBS: dec should be within range of format');
    return
end

if n+m ~= 16
    disp('OBS: n+m sum should be 16');
    return
end

% Insert own code..
% HINT : You may use matlab function "dec2hex" (but note that it converts to
% unsigned integer!) and e.g. "round"

if (dec < 0)
    tmp = round(-dec*2^m); % Format to n.m and round - positive number
    tmpInt = uint16(tmp); % Unsigned 16 bits
    hexNum = bitcmp(tmpInt-1); % Two's complement
else
    hexNum = round((dec)*2^m);
end
    
% add "0x" to hex-number
hex = ['0x' dec2hex(hexNum)];

end

