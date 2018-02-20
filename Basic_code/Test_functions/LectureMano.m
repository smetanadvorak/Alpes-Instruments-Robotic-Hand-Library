function LectureMano(Pos_mem_faibleBase,Pos_mem_fortBase,Registre,s)
Registre2=str2double(Registre);
   
mot_commande=hex2dec('52');%<--- R
mot_commande2=hex2dec('44');%<--- D
Pos_mem_faible=hex2dec(Pos_mem_faibleBase);
Pos_mem_fort=hex2dec(Pos_mem_fortBase);


    Registre_faible=Registre2;%<--- poids faible du nombre de registre
    Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

%--------------------------------CRC16 calcul--------------------------------

%se referer au programme CRC16 si besion d'explication
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,Registre_faible,Registre_fort];
[crc16hi,crc16lo]=CRC16(buf);


%-----------------------------ecriture dans la main--------------------------
fwrite(s,[buf,crc16lo,crc16hi]);

%------------------------------------lecture --------------------------

for i=1:8
    
    fread(s,1);
    if i==6
        
        for n=1:Registre2*4  
            %fonction permettant de replire un tableau dans une autre
            %fonction
            evalin('caller',['tableau(' num2str(n) ')=fread(s,1)']);
        end
    end
end
    
end


