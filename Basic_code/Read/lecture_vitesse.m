% TASK: Get the velocity measurement from the register 27 (VITESSE_MOTEUR).
% INPUT:
%   s is the serial port associated to the hand
%   doigt is the integer number corresponding to the considered finger

function vitesse=lecture_vitesse(doigt,s)

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

flushinput(s);
% Send the command to the hand
fwrite(s,[buf,crc16lo,crc16hi]);
% Read the information
response = fread(s,12);

%% My version, should be faster, Konstantin:
fs = repmat('%02X', 1, 4);
vitesse_hex = sprintf(fs,response(10:-1:7));
vitesse=hex2dec(vitesse_hex);

vitesse = vitesse/100;

%% Previous version
% % Read the information
% for n=0:11
%     val=fread(s,1);
%     if(n==6)
%         vitesse1=dec2hex(val);
%     end
%     if (n==7)
%         vitesse2=dec2hex(val);
%     end
% end
% 
% % Transform the data such dìthat it can be transformed in decimal
% vitesse_hex=strcat(vitesse2,vitesse1);
% vitesse_reel=hex2dec(vitesse_hex)/100;
% 
% vitesse=vitesse_reel;
% 
% return;
end
