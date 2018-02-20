function test_attraper_relacher(pos,doigt,s)

%but:permet de comparer la valeur de la position codeur reel et celle
%    demandée


%cette fonction aurais pus être realisée par le registre 29 ECART_POSITION 
% la longeur du code étant sensiblement la même j'ai obté pour une
% solution différente qui utilise la position des codeurs par le registre 26
% Je ne sais pas la quelle est la plus pratique à utiliser.


%---------------------initialisations des variables--------------
Pos_mem_faible=0;
Pos_mem_fort=0;
position2=0;
position1=0;
i=0;%<--boucle
CPT_TH=2;%<-- valeur magique permetant de rentrer dans le while



%------------------------choix du doigt----------------------------------------
%valeurs en hexa recuperées par la formule dans le pdf: protocole avec le
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


%-----------------création de la trame-----------------------------
mot_commande=hex2dec('52');%<---R
mot_commande2=hex2dec('44');%<---D
registre_faible=hex2dec('01');%<--- nombre de registre (poids faible)
registre_fort=hex2dec('00');%<--- nombre de registre (poids fort)

%------------------CRC16-------------------------------------
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];

[crc16hi,crc16lo]=CRC16(buf);

%------------------ecriture dans la main-------------------------
fwrite(s,[buf,crc16lo,crc16hi]);

%--------------position reel----------------------------------------
val=fread(s,1);
val_prec=val;

while(i~=CPT_TH)
    %lecture du protocole renvoyé par la main
    val=fread(s,1);
    
    %explication de la valeur du CPT_TH
    % demande_ecriture/lecture=2 dont 1 octet deja fait avant le premiers tours
    % position_memoire=2 octets;
    % nombre_registre=2 octets;
    % CRC16=2 octets
    %test RD :verification que l'on est en lecture
    if (val==68) && (val_prec==82),
        valeur_registre=str2double(strcat(num2str(registre_fort),num2str(registre_faible)))*4;
        CPT_TH=valeur_registre+7;
    end  
    
    %recuperation de la position du codeur
    if(i==6);
        position1=dec2hex(val);
        
    end
    if (i==5);
        position2=dec2hex(val);
        
    end
    
    %incrémentation de i et changement de val prec permetant de 
    %diminuer le risque de changer la valeur de CPT_TH
    val_prec=val;
    i=i+1;
    
end

%--------------Comparaison avec la position theorique----------------
%transforme la position qui est sur 2 octets en une position en decimal

position_hex=strcat(position1,position2);
position_reel=hex2dec(position_hex);


%si la position qui est lue n'est pas égale à la position demandée alors
%on réouvre le doigt, simple conditionnelle pouvant faire ce que l'on veux
if position_reel <pos-((pos/100)*2),
    mouv_doigts(00,doigt,s);
end



