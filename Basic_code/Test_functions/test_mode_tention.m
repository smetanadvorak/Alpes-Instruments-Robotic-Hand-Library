function test_mode_tention(tention,courant,doigt,s)


%------------------------choix du doigt----------------------------------------

%valeurs en hexa recuperées par la formule dans le pdf protocole 
if doigt==0,%rotation pouce
    Pos_mem_faible=hex2dec('E8');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('03');%<--- poids fort de la premiere position memoire
    
elseif doigt==1,%pouce
    Pos_mem_faible=hex2dec('D0');
    Pos_mem_fort=hex2dec('07');
    
elseif doigt==2,%index
    Pos_mem_faible=hex2dec('B8');
    Pos_mem_fort=hex2dec('0B');
    
elseif doigt==3,%majeur
    Pos_mem_faible=hex2dec('A0');
    Pos_mem_fort=hex2dec('0F');
    
elseif doigt==4,%annulaire
    Pos_mem_faible=hex2dec('88');
    Pos_mem_fort=hex2dec('13');
    
elseif doigt==5,%auriculaire
    Pos_mem_faible=hex2dec('70');
    Pos_mem_fort=hex2dec('17');
    
end

if tention>=0
    %----------------------TENTION-----------------------------------------
    tention_hex=dec2hex(tention);%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que
    %                         l'on renverse le mot donc que si le mot est plus
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab
    
    if length(dec2hex(tention))==3%<-- si taille du mot est de trois alors le mot de
        %                          poids fort seras la position 3 du mot et '0'
        tention_fort=hex2dec(tention_hex(1));
        tention_faible=hex2dec(strcat(tention_hex(2),tention_hex(3)));
    elseif  length(dec2hex(tention))==2%<-- si taille du mot est de deux alors le mot de
        %                          poids fort seras '00'
        tention_fort=0;
        tention_faible=hex2dec(strcat(tention_hex(1),tention_hex(2)));
    elseif  length(dec2hex(tention))==1%<-- si taille du mot est de un alors le mot de
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        tention_fort=0;
        tention_faible=hex2dec(tention_hex(1));
    end
    tention_fort2=0;
    tention_fort3=0;
else
    if tention<0 
        tention_hex=dec2hex(4294967295+tention);
        tention_faible=hex2dec(strcat(tention_hex(7),tention_hex(8)));
        tention_fort=hex2dec(strcat(tention_hex(5),tention_hex(6)));
        tention_fort2=hex2dec(strcat(tention_hex(3),tention_hex(4)));
        tention_fort3=hex2dec(strcat(tention_hex(1),tention_hex(2)));
    end
end


%-------------------------COURANT-------------------------------------
courant_hex=dec2hex(courant);%<---transformation de la position en hexa
%                         gère la taille du mot en hexa dut au faite que 
%                         l'on renverse le mot donc que si le mot est plus 
%                         petit que 4 (le max) alors les zeros utiles
%                         serons au début et donc supprimé par matlab 

if length(dec2hex(courant))==3%<-- si taille du mot est de trois alors le mot de 
    %                          poids fort seras la position 3 du mot et '0' 
    courant_fort=hex2dec(courant_hex(1));
    courant_faible=hex2dec(strcat(courant_hex(2),courant_hex(3)));
elseif  length(dec2hex(courant))==2%<-- si taille du mot est de deux alors le mot de 
    %                          poids fort seras '00'
    courant_fort=0;
    courant_faible=hex2dec(strcat(courant_hex(1),courant_hex(2)));
elseif  length(dec2hex(courant))==1%<-- si taille du mot est de un alors le mot de 
    %                          poids fort seras '00' et celui de poids
    %                          faible sera position 1 du mot et '0'
    courant_fort=0;
    courant_faible=hex2dec(courant_hex(1));
elseif  length(dec2hex(courant))==4%<-- si taille du mot est de quatre alors 
    %                               c'est parfait on retourne le mot
    %                               directement
    courant_fort=hex2dec(strcat(courant_hex(1),courant_hex(2)));
    courant_faible=hex2dec(strcat(courant_hex(3),courant_hex(4)));
    
end


%-------------------------------TRAME PRINCIPALE--------------------------

%création de la trame


mot_commande=hex2dec('57');
mot_commande2=hex2dec('52');

registre_faible=hex2dec('03');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort,02,00,00,00,tention_faible,tention_fort,tention_fort2,tention_fort3,courant_faible,courant_fort,0,0];
[crc16hi,crc16lo]=CRC16(buf);

%ecriture dans la main
fwrite(s,[buf,crc16lo,crc16hi]);


for i=0:7
    fread(s,1);    
end


end 