function [PWM,tension] = lecture_PWM(s2,doigt)
%
%Lit la valeur du registre position pour un doigt
%

%Meme principe que dans tous les autres programmes lier aux doigts

if doigt==0,%rotation pouce
    PWM_mem_faible=hex2dec('09');%<--- poids faible de la premiere position memoire
    PWM_mem_fort=hex2dec('04');%<--- poids fort de la premiere position memoire
    
elseif doigt==1,%pouce
    PWM_mem_faible=hex2dec('F1');
    PWM_mem_fort=hex2dec('07');
    
elseif doigt==2,%index
    PWM_mem_faible=hex2dec('D9');
    PWM_mem_fort=hex2dec('0B');
    
elseif doigt==3,%majeur
    PWM_mem_faible=hex2dec('C1');
    PWM_mem_fort=hex2dec('0F');
    
elseif doigt==4,%annulaire
    PWM_mem_faible=hex2dec('A9');
    PWM_mem_fort=hex2dec('13');
    
elseif doigt==5,%auriculaire
    PWM_mem_faible=hex2dec('91');
    PWM_mem_fort=hex2dec('17');
    
end



mot_commande=hex2dec('52');
mot_commande2=hex2dec('44');

registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,PWM_mem_faible,...
    PWM_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

fwrite(s2,[buf,crc16lo,crc16hi]);

%lecture intégral du mot reçu
for i=1:8
    fread(s2,1);
    if i==6
        PWM1dec=fread(s2,1);
        PWM2dec=fread(s2,1);
        PWM3dec=fread(s2,1);
        PWM4dec=fread(s2,1);
    end
    
end

%
%Partie qui transforme le mot en hex en mot decimal 
%par transformation de mot qui devrais avoir un 0 en le rajoutant si besoin
%exemple: 0x5 pour la transformation en hexa doit s'écrire 0x05 pour la
%concaténation
%

PWM1=dec2hex(PWM1dec);
if length(PWM1)==1
    PWM1=strcat('0',PWM1);
end

PWM2=dec2hex(PWM2dec);
if length(PWM2)==1
    PWM2=strcat('0',PWM2);
end

PWM3=dec2hex(PWM3dec);
if length(PWM3)==1
    PWM3=strcat('0',PWM3);
end
%PWM is of type VAR_32. PWM4 represents the sign
PWM4=dec2hex(PWM4dec);

PWM_hex=strcat(PWM3,PWM2,PWM1);


PWM=hex2dec(PWM_hex);

if strcmp(PWM4,'FF') %
    tension = - PWM*12/4095;
else 
    tension = PWM*12/4095;
end

end