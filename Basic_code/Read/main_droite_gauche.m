% TASK: Determine which is the used hand reading the register 24
% (ID_DROITE_GAUCHE). If the read value is 1 the right hand is used,
% otherwise if it is 2 the left hand is used.
% INPUT
%   s: serial port associated to the hand
%   name: 

function main_droite_gauche(name, s)

%création de la trame
mot_commande=hex2dec('52');%<--- R
mot_commande2=hex2dec('44');%<--- D
registre_faible=hex2dec('01');%<--- poids faible du nombre de registre
registre_fort=hex2dec('00');%<--- poids fort du nombre de registre
Pos_mem_faible=hex2dec('D0');%<--- poids faible de la premiere position memoire
Pos_mem_fort=hex2dec('0B');%<--- poids fort de la premiere position memoire

% CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

fwrite(s,[buf,crc16lo,crc16hi]); 

% Read and stop the communication
tampon=0;

for i=0:11
    val=fread(s,1);
    if (i==6)
        tampon=dec2hex(val);
    end 
end

% compare the read value with 1 and if they are equal the used hand is the
% right one
if (strcmp(tampon,'1'))
        set(name,'Name','main droite','Position',[700,200,560,420]);
        subplot(1,1,1);
        % background image
        imshow('IMG_20150122_155229.jpg')
        set(gca,'Position',[0 0.15 0.25 1])%<-- nomme le uicontrol ou la figure 
% compare the read value with 2 and if they are equal the used hand is the
% left one        
elseif (strcmp(tampon,'2'))
        set(name,'Name','main gauche','Position',[100,200,560,420]);
        subplot(1,1,1);
        % background image
        imshow('IMG_20150122_155230.jpg')
        set(gca,'Position',[0 0.15 0.25 1])
end

