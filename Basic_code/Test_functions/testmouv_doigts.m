function testmouv_doigts
delete(instrfindall) ;
s=serial('COM11');
fclose(s);
delete(s);
clear s1;
s=serial('COM11');

set(s, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);
fopen(s);

%------------------------création de la trame principal----------------------

%toujours vrais pour une écriture sur un doigt sans lecture
mot_commande=hex2dec('57');%<--- W
mot_commande2=hex2dec('52');%<--- R

Pos_mem_faible=hex2dec('0B');%<--- W
Pos_mem_fort=hex2dec('B8');%<--- R
Registre_faible=hex2dec('03');%<--- poids faible du nombre de registre
Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

%--------------------------------CRC16 calcul--------------------------------

%se referer au programme CRC16 si besion d'explication
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,Registre_faible,Registre_fort,01,00,00,00,hex2dec('58'),hex2dec('02'),hex2dec('00'),hex2dec('00'),hex2dec('E8'),hex2dec('03'),00,00];
[crc16hi,crc16lo]=CRC16(buf);


%-----------------------------ecriture dans la main--------------------------
fwrite(s,[buf,crc16lo,crc16hi]);

%------------------------------------lecture --------------------------

for i=0:7
    %lecture du protocole renvoyé par la main
    fread(s,1);
    
    %explication du 0:7 soit (8 itérations) du for
    % demande_ecriture/lecture=2
    % position_memoire=2 octets;
    % nombre_registre=2 octets;
    % CRC16=2 octets
    %%disp(val);%<--- lecture de valeur (Shutdown)
    %%disp(dec2hex(val));%<--- lecture de valeur en hexa (Shutdown)

end


