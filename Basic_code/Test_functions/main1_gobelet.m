function main1_gobelet(s)

%
% Principe: resserer la main sur le gobelet
% méthode: première approche puis resserement autour du gobelet 
%




%------------------------choix du doigt------------------------------
%rotation pouce
    Pos_mem_faible_Rpouce=hex2dec('E8');%<--- poids faible de la premiere position memoire
    Pos_mem_fort_Rpouce=hex2dec('03');%<--- poids fort de la premiere position memoire
    
%pouce
    Pos_mem_faible_pouce=hex2dec('D0');
    Pos_mem_fort_pouce=hex2dec('07');
    
%annulaire
    Pos_mem_faible_annulaire=hex2dec('88');
    Pos_mem_fort_annulaire=hex2dec('13');
    
%majeur
    Pos_mem_faible_majeur=hex2dec('A0');
    Pos_mem_fort_majeur=hex2dec('0F');
    
%--------------------------------------------------------------------


%création de la trame
mot_commande=hex2dec('57');%<--- W
mot_commande2=hex2dec('52');%<--- R
Registre_faible=hex2dec('02');%<--- poids faible du nombre de registre
Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

%-------------------------------PREMIERE APPROCHE------------------------------
%rotation pouce
buf_Rpouce=[mot_commande,mot_commande2,Pos_mem_faible_Rpouce,Pos_mem_fort_Rpouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('5C'),hex2dec('44'),00,00];
[crc16hi_Rpouce,crc16lo_Rpouce]=CRC16(buf_Rpouce);

%pouce
buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('58'),hex2dec('1B'),00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);


%annulaire
buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,hex2dec('80'),hex2dec('3E'),00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);

%majeur
buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,hex2dec('80'),hex2dec('3E'),00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);

fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);%<--- annualire
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);%<--- majeur
fwrite(s,[buf_Rpouce,crc16lo_Rpouce,crc16hi_Rpouce]);%<-- rotation pouce
pause(1);%<---- utile pour ne pas renverser le gobelet :)
fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);%<--- pouce

for i=1:32%<--4*8 égale à 4 fois la lecture de 8 valeurs en hexa (8 valeurs par doigt)
    fread(s,1);%<-- lecture pour ne pas interferer avec les autres lectures du principal
end

%------------------------pause entre les deux approches---------------
pause(1);

%------------------------DEUXIEME APPROCHE----------------------------
%pouce
buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('FC'),hex2dec('21'),00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);

%annulaire
buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,hex2dec('38'),hex2dec('4A'),00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);

%majeur
buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,hex2dec('38'),hex2dec('4A'),00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);

%----------------------ecriture dans la main-------------------------
fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);%<--- annulaire
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);%<--- majeur

fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);

for i=1:24%<--4*8 égale à 4 fois la lecture de 8 valeurs en hexa (8 valeurs par doigt)
    fread(s,1);%<-- lecture pour ne pas interferer avec les autres lectures du principal
end
%---------------------DEUXIEME APPROCHE-----------------------------------



end

