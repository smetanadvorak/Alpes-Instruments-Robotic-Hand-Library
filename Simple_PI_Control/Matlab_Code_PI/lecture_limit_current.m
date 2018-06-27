% TASK: Read register 13 and 14 containing respectively the lower bound and the upper
%       bound of the motor applicable voltage.
% INPUT
%   s: serial port associated to the robotic hand
%   doigt: integer number from 0 to 5 corresponding to the finger

function [register_current, current_tension_unit] = lecture_limit_current(doigt, s)

% thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('EA');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('03');%<--- poids fort de la premiere position memoire
% thumb   
elseif doigt==1
    Pos_mem_faible=hex2dec('D2');
    Pos_mem_fort=hex2dec('07');
% index    
elseif doigt==2
    Pos_mem_faible=hex2dec('BA');
    Pos_mem_fort=hex2dec('0B');
% middle finger     
elseif doigt==3
    Pos_mem_faible = hex2dec('A2');
    Pos_mem_fort = hex2dec('0F');
% annular    
elseif doigt==4
    Pos_mem_faible=hex2dec('8A');
    Pos_mem_fort=hex2dec('13');
% little finger    
elseif doigt==5
    Pos_mem_faible=hex2dec('72');
    Pos_mem_fort=hex2dec('17');  
end

mot_commande = hex2dec('52'); % R
mot_commande2 = hex2dec('44'); % D

registre_faible = hex2dec('01');
registre_fort = hex2dec('00');

buf = [mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo] = CRC16(buf);

% Make the buffer empty to read the correct data
flushinput(s);
fwrite(s,[buf,crc16lo,crc16hi]);

% Read the data
response = fread(s, 12);
fs = repmat('%02X', 1, 3);
current_hex = sprintf(fs,response(9:-1:7));
register_current = hex2dec(current_hex);
current_tension_unit = (register_current * 3.3)/65535;

end