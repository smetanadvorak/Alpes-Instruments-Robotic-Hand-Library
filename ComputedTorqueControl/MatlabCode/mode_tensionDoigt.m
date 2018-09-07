% TASK: Write 2 on the register 0 in order to set the Tension Mode.
% Moreover, it set the tension value on the "CONSIGNE_TENSION_POSITION"
% register and the current value on the next register. A negative tension 
% opens the hand, while a positive one closes the hand.
% The tension is espressed as 1/100 volt (Ex: 825 corresponds to
% 8.25 V). The minimum value is -1150 (-11.5V), the maximum one is 1150
% (11.5V). Concerning the current value, it must be between 0 and 36000.
% INPUT
%   s: serial port associated to the hand
%   doigt: integer number associated to the finger we want to move
%   tension: desired tension value
%   courant: desired current value.

function mode_tensionDoigt (tension, courant, doigt, s)

% Thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('E8');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('03');%<--- poids fort de la premiere position memoire
% Thumb    
elseif doigt==1
    Pos_mem_faible=hex2dec('D0');
    Pos_mem_fort=hex2dec('07');
% Index
elseif doigt==2
    Pos_mem_faible=hex2dec('B8');
    Pos_mem_fort=hex2dec('0B');
% Middle finger   
elseif doigt==3
    Pos_mem_faible=hex2dec('A0');
    Pos_mem_fort=hex2dec('0F');
% Annalar    
elseif doigt==4
    Pos_mem_faible=hex2dec('88');
    Pos_mem_fort=hex2dec('13');
% Little finger     
elseif doigt==5
    Pos_mem_faible=hex2dec('70');
    Pos_mem_fort=hex2dec('17'); 
end

%% Transform the tension value format such that it can be sent via register
if tension>=0
    tension_hex=dec2hex(tension);
    if length(dec2hex(tension))==3
        tension_fort=hex2dec(tension_hex(1));
        tension_faible=hex2dec(strcat(tension_hex(2),tension_hex(3)));
    elseif  length(dec2hex(tension))==2
        tension_fort=0;
        tension_faible=hex2dec(strcat(tension_hex(1),tension_hex(2)));
    elseif  length(dec2hex(tension))==1
        tension_fort=0;
        tension_faible=hex2dec(tension_hex(1));
    end
    tension_fort2=0;
    tension_fort3=0;
else
    % Add 'FFFF FFFF' to each word to turn it into a negative. 
    if tension < 0
        tension_hex=dec2hex(4294967295+tension);
        tension_faible=hex2dec(strcat(tension_hex(7),tension_hex(8)));
        tension_fort=hex2dec(strcat(tension_hex(5),tension_hex(6)));
        tension_fort2=hex2dec(strcat(tension_hex(3),tension_hex(4)));
        tension_fort3=hex2dec(strcat(tension_hex(1),tension_hex(2)));
    end
end


%% Transform the current value format such that it can be sent via register
courant_hex=dec2hex(courant);

if length(dec2hex(courant))==3
    courant_fort=hex2dec(courant_hex(1));
    courant_faible=hex2dec(strcat(courant_hex(2),courant_hex(3)));
elseif  length(dec2hex(courant))==2
    courant_fort=0;
    courant_faible=hex2dec(strcat(courant_hex(1),courant_hex(2)));
elseif  length(dec2hex(courant))==1
    courant_fort=0;
    courant_faible=hex2dec(courant_hex(1));
elseif  length(dec2hex(courant))==4
    courant_fort=hex2dec(strcat(courant_hex(1),courant_hex(2)));
    courant_faible=hex2dec(strcat(courant_hex(3),courant_hex(4)));   
end

%% Build the command line

mot_commande=hex2dec('57'); % <-- W
mot_commande2=hex2dec('52');% <-- R

registre_faible=hex2dec('03');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort,02,00,00,00,tension_faible,tension_fort,tension_fort2,tension_fort3,courant_faible,courant_fort,0,0];
[crc16hi,crc16lo]=CRC16(buf);

% Write the command on the register
fwrite(s,[buf,crc16lo,crc16hi]);

%fread(s,24);

end