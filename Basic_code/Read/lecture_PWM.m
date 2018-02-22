% TASK: Read the value contained in the register 33 for one finger.
% INPUT
%   s: serial port associated to the hand
%	doigt: integer number associated to the finger.
% OUTPUT
%   PWM
%   tension

function [PWM,tension] = lecture_PWM(s2,doigt)

% Thumb rotation
if doigt==0
    PWM_mem_faible=hex2dec('09');
    PWM_mem_fort=hex2dec('04');
% Thumb    
elseif doigt==1
    PWM_mem_faible=hex2dec('F1');
    PWM_mem_fort=hex2dec('07');
% Index    
elseif doigt==2
    PWM_mem_faible=hex2dec('D9');
    PWM_mem_fort=hex2dec('0B');
% Middle finger    
elseif doigt==3
    PWM_mem_faible=hex2dec('C1');
    PWM_mem_fort=hex2dec('0F');
% Annular    
elseif doigt==4
    PWM_mem_faible=hex2dec('A9');
    PWM_mem_fort=hex2dec('13');
% Little finger    
elseif doigt==5
    PWM_mem_faible=hex2dec('91');
    PWM_mem_fort=hex2dec('17');    
end

mot_commande=hex2dec('52'); % R
mot_commande2=hex2dec('44'); % D

registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,PWM_mem_faible,...
    PWM_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

% Make the buffer empty to read the correct data
flushinput(s);
fwrite(s2,[buf,crc16lo,crc16hi]);

% Read the data
response = fread(s2, 12);
PWM4dec = response(10);
fs = repmat('%02X', 1, 3);
PWM_hex = sprintf(fs,response(9:-1:7));
PWM=hex2dec(PWM_hex);

% Tension computation
control = dec2hex(PWM4dec);
if strcmp(control,'FF') 
    tension = - PWM*12/4095;
else 
    tension = PWM*12/4095;
end
end