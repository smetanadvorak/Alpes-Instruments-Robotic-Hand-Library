% TASK: Get the position measurement from the register 26 (POSITION_CODEUR)
% for one finger.
% INPUT:
%   s is the serial port associated to the hand
%   doigt is the integer number corresponding to the considered finger

function position = lecture_position(s2, doigt)

% thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('02');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('04');%<--- poids fort de la premiere position memoire
% thumb   
elseif doigt==1
    Pos_mem_faible=hex2dec('EA');
    Pos_mem_fort=hex2dec('07');
% index    
elseif doigt==2
    Pos_mem_faible=hex2dec('D2');
    Pos_mem_fort=hex2dec('0B');
% middle finger     
elseif doigt==3
    Pos_mem_faible=hex2dec('BA');
    Pos_mem_fort=hex2dec('0F');
% annular    
elseif doigt==4
    Pos_mem_faible=hex2dec('A2');
    Pos_mem_fort=hex2dec('13');
% little finger    
elseif doigt==5
    Pos_mem_faible=hex2dec('8A');
    Pos_mem_fort=hex2dec('17');  
end

mot_commande=hex2dec('52'); % <-- R
mot_commande2=hex2dec('44'); % <-- D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

% CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

flushinput(s);
% Send the command to the hand's register
fwrite(s2,[buf,crc16lo,crc16hi]);
% Read the information
response = fread(s,12);

%% My version, should be faster, Konstantin:
fs = repmat('%02X', 1, 4);
position_hex = sprintf(fs,response(10:-1:7));
position = hex2dec(position_hex);

%% Previous version
% % Read the information
% for i=1:8
%     fread(s2,1);
%     if i==6
%         pos1dec=fread(s2,1);
%         pos2dec=fread(s2,1);
%         pos3dec=fread(s2,1);
%         pos4dec=fread(s2,1);
%     end
% end
% 
% % Transform the read data in a understandable information. From ex
% % character to decimal one. It is necessary to have the length of each
% % character equals to 2, if it is not a number of 0 equals to (length-2)
% % has to be added.
% pos1=dec2hex(pos1dec);
% if length(pos1)==1
%     pos1=strcat('0',pos1);
% end
% pos2=dec2hex(pos2dec);
% if length(pos2)==1
%     pos2=strcat('0',pos2);
% end
% pos3=dec2hex(pos3dec);
% if length(pos3)==1
%     pos3=strcat('0',pos3);
% end
% pos4=dec2hex(pos4dec);
% 
% position_hex=strcat(pos4,pos3,pos2,pos1);
% position=hex2dec(position_hex);
% 
 end   