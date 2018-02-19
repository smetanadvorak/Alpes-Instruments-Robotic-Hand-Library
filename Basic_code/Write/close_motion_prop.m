% TASK: Move the fingers accordingly to the desired positions.
% INPUT:
%   s serial port associated to the hand;
%   pos vector of the desired positions for the fingers.

function close_motion_prop(pos,s)

% Transform the position info in such a way the hand can understand it. The
% pos variable is transformed in hexadecimal and if its length is not 4,
% (length-4) number of 0 are added. The first two characters represents the
% most significant byte, while the final two are the least significant
% ones.

% thumb rotation
    pos_hex1=dec2hex(pos(1)); 
    length_pos1 = length(pos_hex1);
    if length_pos1==3
        position_fort_Rpouce=hex2dec(pos_hex1(1));
        position_faible_Rpouce=hex2dec(strcat(pos_hex1(2),pos_hex1(3)));
    elseif  length_pos1==2
        position_fort_Rpouce=0;
        position_faible_Rpouce=hex2dec(strcat(pos_hex1(1),pos_hex1(2)));
    elseif  length_pos1==1
        position_fort_Rpouce=0;
        position_faible_Rpouce=hex2dec(pos_hex1(1));
    elseif  length_pos1==4
        position_fort_Rpouce=hex2dec(strcat(pos_hex1(1),pos_hex1(2)));
        position_faible_Rpouce=hex2dec(strcat(pos_hex1(3),pos_hex1(4)));
    end

% thumb
    pos_hex2=dec2hex(pos(2));
    length_pos2 = length(pos_hex2);
    if length_pos2==3
        position_fort_pouce=hex2dec(pos_hex2(1));
        position_faible_pouce=hex2dec(strcat(pos_hex2(2),pos_hex2(3)));
    elseif  length_pos2==2
        position_fort_pouce=0;
        position_faible_pouce=hex2dec(strcat(pos_hex2(1),pos_hex2(2)));
    elseif  length_pos2==1
        position_fort_pouce=0;
        position_faible_pouce=hex2dec(pos_hex2(1));
    elseif  length_pos2==4
        position_fort_pouce=hex2dec(strcat(pos_hex2(1),pos_hex2(2)));
        position_faible_pouce=hex2dec(strcat(pos_hex2(3),pos_hex2(4)));
    end

% index
    pos_hex3=dec2hex(pos(3));
    length_pos3 = length(pos_hex3);
    if length_pos3==3
        position_fort_index=hex2dec(pos_hex3(1));
        position_faible_index=hex2dec(strcat(pos_hex3(2),pos_hex3(3)));
    elseif  length_pos3==2
        position_fort_index=0;
        position_faible_index=hex2dec(strcat(pos_hex3(1),pos_hex3(2)));
    elseif  length_pos3==1
        position_fort_index=0;
        position_faible_index=hex2dec(pos_hex3(1));
    elseif  length_pos3==4
        position_fort_index=hex2dec(strcat(pos_hex3(1),pos_hex3(2)));
        position_faible_index=hex2dec(strcat(pos_hex3(3),pos_hex3(4)));
    end

% middle finger
    pos_hex4=dec2hex(pos(4));
    length_pos4 = length(pos_hex4);
    if length_pos4==3
        position_fort_majeur=hex2dec(pos_hex4(1));
        position_faible_majeur=hex2dec(strcat(pos_hex4(2),pos_hex4(3)));
    elseif  length_pos4==2
        position_fort_majeur=0;
        position_faible_majeur=hex2dec(strcat(pos_hex4(1),pos_hex4(2)));
    elseif  length_pos4==1
        position_fort_majeur=0;
        position_faible_majeur=hex2dec(pos_hex4(1));
    elseif  length_pos4==4
        position_fort_majeur=hex2dec(strcat(pos_hex4(1),pos_hex4(2)));
        position_faible_majeur=hex2dec(strcat(pos_hex4(3),pos_hex4(4)));
    end

%annular
    pos_hex5=dec2hex(pos(5));
    length_pos5 = length(pos_hex5);
    if length_pos5==3
        position_fort_annulaire=hex2dec(pos_hex5(1));
        position_faible_annulaire=hex2dec(strcat(pos_hex5(2),pos_hex5(3)));
    elseif  length_pos5==2
        position_fort_annulaire=0;
        position_faible_annulaire=hex2dec(strcat(pos_hex5(1),pos_hex5(2)));
    elseif  length_pos5==1
        position_fort_annulaire=0;
        position_faible_annulaire=hex2dec(pos_hex5(1));
    elseif  length_pos5==4
        position_fort_annulaire=hex2dec(strcat(pos_hex5(1),pos_hex5(2)));
        position_faible_annulaire=hex2dec(strcat(pos_hex5(3),pos_hex5(4)));
    end
    
% little finger
    pos_hex6=dec2hex(pos(6));
    length_pos6 = length(pos_hex6);
    if length_pos6 == 3
        position_fort_auriculaire=hex2dec(pos_hex6(1));
        position_faible_auriculaire=hex2dec(strcat(pos_hex6(2),pos_hex6(3)));
    elseif  length_pos6==2
        position_fort_auriculaire=0;
        position_faible_auriculaire=hex2dec(strcat(pos_hex6(1),pos_hex6(2)));
    elseif  length_pos6==1
        position_fort_auriculaire=0;
        position_faible_auriculaire=hex2dec(pos_hex6(1));
    elseif  length_pos6==4
        position_fort_auriculaire=hex2dec(strcat(pos_hex6(1),pos_hex6(2)));
        position_faible_auriculaire=hex2dec(strcat(pos_hex6(3),pos_hex6(4)));
    end

% Depending on the finger, define the memory position.

% thumb position
Pos_mem_faible_Rpouce = 232; % hex2dec('E8');
Pos_mem_fort_Rpouce = 3; % hex2dec('03');
% thumb
Pos_mem_faible_pouce= 208; % hex2dec('D0');
Pos_mem_fort_pouce= 7; % hex2dec('07');
% index
Pos_mem_faible_index= 184; % hex2dec('B8');
Pos_mem_fort_index= 11; % hex2dec('0B');
% middle finger
Pos_mem_faible_majeur= 160; % hex2dec('A0');
Pos_mem_fort_majeur= 15; % hex2dec('0F');
% annular
Pos_mem_faible_annulaire= 136; % hex2dec('88');
Pos_mem_fort_annulaire= 19; %h ex2dec('13');
% little finger
Pos_mem_faible_auriculaire= 112; % hex2dec('70');
Pos_mem_fort_auriculaire= 23; % hex2dec('17');

mot_commande = 87; % hex2dec('57') <--- W
mot_commande2 = 82; % hex2dec('52') <--- R
Registre_faible = 2; % hex2dec('02')  least significant byte of the register number
Registre_fort = 0; % hex2dec('00')  most significant byte of the register number

% CRC16 computation
% thumb rotation / position codeur Rpouce:18000 valeur arbitraire pour
%ressembler a un poing ferm�
buf_Rpouce=[mot_commande,mot_commande2,Pos_mem_faible_Rpouce,Pos_mem_fort_Rpouce,Registre_faible,Registre_fort,01,00,00,00,position_faible_Rpouce,position_fort_Rpouce,00,00];
[crc16hi_Rpouce,crc16lo_Rpouce]=CRC16(buf_Rpouce);
% thumb / position codeur pouce:13823 valeur arbitraire pour
%ressembler a un poing ferm�
buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,position_faible_pouce,position_fort_pouce,00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);
% index
buf_index=[mot_commande,mot_commande2,Pos_mem_faible_index,Pos_mem_fort_index,Registre_faible,Registre_fort,01,00,00,00,position_faible_index,position_fort_index,00,00];
[crc16hi_index,crc16lo_index]=CRC16(buf_index);
% middle finger
buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,position_faible_majeur,position_fort_majeur,00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);
% annular
buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,position_faible_annulaire,position_fort_annulaire,00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);
% little finger
buf_auriculaire=[mot_commande,mot_commande2,Pos_mem_faible_auriculaire,Pos_mem_fort_auriculaire,Registre_faible,Registre_fort,01,00,00,00,position_faible_auriculaire,position_fort_auriculaire,00,00];
[crc16hi_auriculaire,crc16lo_auriculaire]=CRC16(buf_auriculaire);

% Write the command on the register
fwrite(s,[buf_Rpouce,crc16lo_Rpouce,crc16hi_Rpouce]);
fwrite(s,[buf_index,crc16lo_index,crc16hi_index]);
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);
fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);
fwrite(s,[buf_auriculaire,crc16lo_auriculaire,crc16hi_auriculaire]);
% waiting for the thumb to come this put on the other fingers
pause(0);
fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);

% Read the command by the register so as not to interfere with other 
% readings of the principal
fread(s,48); 

end
