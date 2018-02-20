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

fwrite(s2,[buf,crc16lo,crc16hi]);

% Read the data
for i=1:8
    fread(s2,1);
    if i==6
        PWM1dec=fread(s2,1);
        PWM2dec=fread(s2,1);
        PWM3dec=fread(s2,1);
        PWM4dec=fread(s2,1);
    end
    
end

% Transform the decimal value in hexadecimal one. 
PWM1=dec2hex(PWM1dec);
if length(PWM1)==1
    PWM1=strcat('0',PWM1);
end

PWM2=dec2hex(PWM2dec);
if length(PWM2)==1
    PWM2=strcat('0',PWM2);
end

PWM3=dec2hex(PWM3dec);
if length(PWM3)==1
    PWM3=strcat('0',PWM3);
end

% PWM is of type VAR_32. PWM_4 represents the sign
PWM4=dec2hex(PWM4dec);

PWM_hex=strcat(PWM3,PWM2,PWM1);
PWM=hex2dec(PWM_hex);

% Tension computation
if strcmp(PWM4,'FF') 
    tension = - PWM*12/4095;
else 
    tension = PWM*12/4095;
end

end