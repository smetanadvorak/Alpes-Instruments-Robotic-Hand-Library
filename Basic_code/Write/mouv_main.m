% TASK: Close the hand completely.
% INPUT: s is the serial port associated to the hand.

function mouv_main(s)

% Define the maximum position value for aech finger and arrange it in a
% proper way.
% The variable is transformed in hexadecimal. The first two characters 
% represents the most significant byte, while the final two are the least 
% significant ones.

pos_hex=dec2hex(43000); % Max position for all fingers is 43000
position_fort=hex2dec(strcat(pos_hex(1),pos_hex(2)));
position_faible=hex2dec(strcat(pos_hex(3),pos_hex(4)));

% Depending on the finger, define the memory position
% thumb position
    Pos_mem_faible_Rpouce=hex2dec('E8'); %least significant byte
    Pos_mem_fort_Rpouce=hex2dec('03'); %most significant byte
% thumb
    Pos_mem_faible_pouce=hex2dec('D0');
    Pos_mem_fort_pouce=hex2dec('07'); 
% index
    Pos_mem_faible_index=hex2dec('B8');
    Pos_mem_fort_index=hex2dec('0B');
% middle finger
    Pos_mem_faible_majeur=hex2dec('A0');
    Pos_mem_fort_majeur=hex2dec('0F');
% annular
    Pos_mem_faible_annulaire=hex2dec('88');
    Pos_mem_fort_annulaire=hex2dec('13');
%a little finger
    Pos_mem_faible_auriculaire=hex2dec('70');
    Pos_mem_fort_auriculaire=hex2dec('17');
    
mot_commande=hex2dec('57'); % W
mot_commande2=hex2dec('52'); % R
Registre_faible=hex2dec('02'); %least significant byte of the register number
Registre_fort=hex2dec('00'); %most significant byte of the register number

% CRC16 computation for each finger

% thumb rotation / position codeur Rpouce:16639 valeur arbitraire pour
%ressembler a un poing fermé
buf_Rpouce=[mot_commande,mot_commande2,Pos_mem_faible_Rpouce,Pos_mem_fort_Rpouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('FF'),hex2dec('40'),00,00];
[crc16hi_Rpouce,crc16lo_Rpouce]=CRC16(buf_Rpouce);
% thumb / position codeur pouce:13823 valeur arbitraire pour
%ressembler a un poing fermé
buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('FF'),hex2dec('35'),00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);
% index
buf_index=[mot_commande,mot_commande2,Pos_mem_faible_index,Pos_mem_fort_index,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_index,crc16lo_index]=CRC16(buf_index);
% middle finger
buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);
% annular
buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);
%little finger
buf_auriculaire=[mot_commande,mot_commande2,Pos_mem_faible_auriculaire,Pos_mem_fort_auriculaire,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_auriculaire,crc16lo_auriculaire]=CRC16(buf_auriculaire);

% Write the command on the registers
fwrite(s,[buf_Rpouce,crc16lo_Rpouce,crc16hi_Rpouce]);
fwrite(s,[buf_index,crc16lo_index,crc16hi_index]);
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);
fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);
fwrite(s,[buf_auriculaire,crc16lo_auriculaire,crc16hi_auriculaire]);
% waiting for the thumb to come this put on the other fingers
pause(1.5);
fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);

% Read the command by the register so as not to interfere with other 
% readings of the principal
% fread(s,48);

end
