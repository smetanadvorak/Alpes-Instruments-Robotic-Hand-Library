% TASK: Get the velocity measurement from the register 27 (VITESSE_MOTEUR).
% INPUT:
%   s is the serial port associated to the hand
%   doigt is the integer number corresponding to the considered finger
% OUTPUTS
%   register_vitesse: Absolute value of the speed of rotation of the motor 
%                     shaft (after reductor) expressed in [tr/min]
%   vitesse: corresponding velocity in [rad/sec]

function [register_vitesse, vitesse] = lecture_vitesse(doigt, s)

% thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('03');
    Pos_mem_fort=hex2dec('04');
% thumb    
elseif doigt==1
    Pos_mem_faible=hex2dec('EB');
    Pos_mem_fort=hex2dec('07');
% index    
elseif doigt==2
    Pos_mem_faible=hex2dec('D3');
    Pos_mem_fort=hex2dec('0B');
% middle finger    
elseif doigt==3
    Pos_mem_faible=hex2dec('BB');
    Pos_mem_fort=hex2dec('0F');
% annular    
elseif doigt==4
    Pos_mem_faible=hex2dec('A3');
    Pos_mem_fort=hex2dec('13');
% little finger    
elseif doigt==5
    Pos_mem_faible=hex2dec('8B');
    Pos_mem_fort=hex2dec('17');   
end

mot_commande=hex2dec('52'); % R
mot_commande2=hex2dec('44'); % D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

%CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

% Make the buffer empty to read the correct data
flushinput(s);
% Send the command to the hand
fwrite(s,[buf,crc16lo,crc16hi]);
% Read the information
response = fread(s,12);

%% My version, should be faster, Konstantin:
fs = repmat('%02X', 1, 4);
vitesse_hex = sprintf(fs,response(10:-1:7));
register_vitesse = hex2dec(vitesse_hex);

register_vitesse = register_vitesse/100;

vitesse = (register_vitesse)* (2*pi/60) * 256;

end
