function fin_mouv=test_mouvement(doigt,s)
fin_mouv=0;

%
%Verifie si le doigt est en mouvement par le biais des postions codeurs 
%
%------------------------choix du doigt----------------------------------------
 Pos_mem_faible=0;
 Pos_mem_fort=0;
%valeurs en hexa recuperé par la formule dans le pdf protocole avec le
%registre 26 pour chaques doigts
if doigt==0,%rotation pouce
    Pos_mem_faible=hex2dec('02');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('04');%<--- poids fort de la premiere position memoire
    
elseif doigt==1,%pouce
    Pos_mem_faible=hex2dec('EA');
    Pos_mem_fort=hex2dec('07');
    
elseif doigt==2,%index
    Pos_mem_faible=hex2dec('D2');
    Pos_mem_fort=hex2dec('0B');
    
elseif doigt==3,%majeur
    Pos_mem_faible=hex2dec('BA');
    Pos_mem_fort=hex2dec('0F');
    
elseif doigt==4,%annulaire
    Pos_mem_faible=hex2dec('A2');
    Pos_mem_fort=hex2dec('13');
    
elseif doigt==5,%auriculaire
    Pos_mem_faible=hex2dec('8A');
    Pos_mem_fort=hex2dec('17');
    
end


%création de la trame
mot_commande=hex2dec('52');
mot_commande2=hex2dec('44');
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

%ecriture dans la main
fwrite(s,[buf,crc16lo,crc16hi]);

%lecture + arret de communication

position2_2=0;
position1_2=0;

for i=0:11
    %lecture du protocole renvoyé par la main
    val=fread(s,1);    
    if(i==6);
        position1_1=dec2hex(val);
    end
    if (i==7);
        position2_1=dec2hex(val);
    end
end

position_hex_1=strcat(position2_1,position1_1);
position_reel_1=hex2dec(position_hex_1);

fwrite(s,[buf,crc16lo,crc16hi]);
for i=0:11
    %lecture du protocole renvoyé par la main
    val=fread(s,1);    
    if(i==6);
        position1_2=dec2hex(val);
    end
    if (i==7);
        position2_2=dec2hex(val);
    end
end

position_hex_2=strcat(position2_2,position1_2);
position_reel_2=hex2dec(position_hex_2);

if position_reel_2==position_reel_1 ,
    fin_mouv=1;
    return;
    
end 