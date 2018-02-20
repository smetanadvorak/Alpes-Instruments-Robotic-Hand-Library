function test_attraper(pos,doigt,s)

%
%But: vérifie que la main tien quelque chose
%

%------------------------choix du doigt----------------------------------------
 Pos_mem_faible=0;
 Pos_mem_fort=0;
%valeurs en hexa recuperées par la formule dans le pdf protocole avec le
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
mot_commande=hex2dec('52'); % <-- R
mot_commande2=hex2dec('44');% <-- D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

%ecriture dans la main
fwrite(s,[buf,crc16lo,crc16hi]);

%lecture + arret de communication
i=0;
position2=0;
position1=0;
val=fread(s,1);
CPT_TH=2;
val_prec=val;
while(i~=CPT_TH)
    %lecture du protocole renvoyé par la main
    val=fread(s,1);
    
    %test RD
    if (val==68) && (val_prec==82),
         valeur_registre=str2double(strcat(num2str(registre_fort),num2str(registre_faible)))*4;
        CPT_TH=valeur_registre+7;
        
    %test WR
    elseif (val==82)&&(val_prec==87),
        CPT_TH=7;
        
    %test W1 ,W2 ,W3
    elseif ((val==01)||(val==02)||(val==3))&&(val_prec==87),
       
        CPT_TH=11;
    end
    if(i==CPT_TH-6);
        position1=dec2hex(val);
    end
    if (i==CPT_TH-5);
        position2=dec2hex(val);
    end
    val_prec=val;
    i=i+1;

end

position_hex=strcat(position2,position1);
position_reel=hex2dec(position_hex);

if position_reel <pos,
    reponse=['le doigt ',num2str(doigt),' tien quelquechose'];
    disp(reponse);
    
end 


