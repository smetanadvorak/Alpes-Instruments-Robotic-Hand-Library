% TASK: Completely open the hand. This configuration corresponds to the
% reference one.
% INPUT
%   s: is the serial port associated to the hand.

function back_main(s)

% In order to open the hand it is necessary to apply a 0 position to the
% hand joints. Usually the decimal position is converted in hexadecimal one
% but in this case is easier:
position_fort=0;
position_faible=0;


% Define the memory position associated to each finger. The first line
% corresponds to the least significant byte, the second one to the most
% significant one.

% thumb rotation
Pos_mem_faible_Rpouce=hex2dec('E8'); %<--- least significant byte
Pos_mem_fort_Rpouce=hex2dec('03'); %<--- most significant byte

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

% pinkie
Pos_mem_faible_auriculaire=hex2dec('70');
Pos_mem_fort_auriculaire=hex2dec('17');

% Command code
mot_commande=hex2dec('57');%<--- W
mot_commande2=hex2dec('52');%<--- R

% Define the memory address associated to the consdered register. The first
% line corresponds to the least significant byte, the second one to the most
% significant one.
Registre_faible=hex2dec('02'); %<--- least significant byte
Registre_fort=hex2dec('00'); %<--- least significant byte

% CRC16 computation for each finger
buf_Rpouce=[mot_commande,mot_commande2,Pos_mem_faible_Rpouce,Pos_mem_fort_Rpouce,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_Rpouce,crc16lo_Rpouce]=CRC16(buf_Rpouce);

buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);

buf_index=[mot_commande,mot_commande2,Pos_mem_faible_index,Pos_mem_fort_index,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_index,crc16lo_index]=CRC16(buf_index);

buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);

buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);

buf_auriculaire=[mot_commande,mot_commande2,Pos_mem_faible_auriculaire,Pos_mem_fort_auriculaire,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_auriculaire,crc16lo_auriculaire]=CRC16(buf_auriculaire);


% Send the command to the hand through the fwrite() finction
fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);
pause(0.5);
fwrite(s,[buf_Rpouce,crc16lo_Rpouce,crc16hi_Rpouce]);
fwrite(s,[buf_index,crc16lo_index,crc16hi_index]);
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);
fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);
fwrite(s,[buf_auriculaire,crc16lo_auriculaire,crc16hi_auriculaire]);

% Read 8 values in hex per finger (6)
% fread(s,48);

end


