% TASK: Move a specific finger to the absolute given position.
% INPUT:
%   s is the serial port associated to the hand
%   doigt integer number associated to the finger we want to move
%   pos desired position for the finger 'doigt'.

function mouv_doigts(pos,doigt,s)

% Transform the position info in such a way the hand can understand it. The
% pos variable is transformed in hexadecimal and if its length is not 4,
% (length-4) number of 0 are added. The first two characters represents the
% most significant byte, while the final two are the least significant
% ones.
pos_hex=dec2hex(pos); 
if length(dec2hex(pos))==3
    position_fort=hex2dec(pos_hex(1));
    position_faible=hex2dec(strcat(pos_hex(2),pos_hex(3)));
elseif  length(dec2hex(pos))==2
    position_fort=0;
    position_faible=hex2dec(strcat(pos_hex(1),pos_hex(2)));
elseif  length(dec2hex(pos))==1
    position_fort=0;
    position_faible=hex2dec(pos_hex(1));
elseif  length(dec2hex(pos))==4
    position_fort=hex2dec(strcat(pos_hex(1),pos_hex(2)));
    position_faible=hex2dec(strcat(pos_hex(3),pos_hex(4)));
end

% Depending on the finger, define the memory position
% thumb position
if doigt==0
    Pos_mem_faible=hex2dec('E8'); %least significant byte
    Pos_mem_fort=hex2dec('03'); %most significant byte
% thumb    
elseif doigt==1
    Pos_mem_faible=hex2dec('D0');
    Pos_mem_fort=hex2dec('07');
% index    
elseif doigt==2
    Pos_mem_faible=hex2dec('B8');
    Pos_mem_fort=hex2dec('0B');
% middle finger    
elseif doigt==3
    Pos_mem_faible=hex2dec('A0');
    Pos_mem_fort=hex2dec('0F');
% annular   
elseif doigt==4
    Pos_mem_faible=hex2dec('88');
    Pos_mem_fort=hex2dec('13');
% little finger    
elseif doigt==5
    Pos_mem_faible=hex2dec('70');
    Pos_mem_fort=hex2dec('17'); 
end

mot_commande=hex2dec('57'); % W
mot_commande2=hex2dec('52'); % R
Registre_faible=hex2dec('02'); % least significant byte of the register number
Registre_fort=hex2dec('00'); % most significant byte of the register number

% CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi,crc16lo]=CRC16(buf);

% Write the command on the register
fwrite(s,[buf,crc16lo,crc16hi]);

% Read the command by the register so as not to interfere with other 
% readings of the principal
fread(s,7);

end


