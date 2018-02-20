% TASK: Read the register 36 (CALCUL_I). Integral term of the position
% control.
%   CALCUL_I = ECART_POSITION * (COEF_P / 1000)
% INPUT
%   s: serial port associated to the hand
%   doigt: integer number associated to the finger we want to move

function calcul_i = lecture_calcul_i(doigt,s)

% Thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('0C');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('04');%<--- poids fort de la premiere position memoire
% Thumb    
elseif doigt==1
    Pos_mem_faible=hex2dec('F4');
    Pos_mem_fort=hex2dec('07');
% Index    
elseif doigt==2
    Pos_mem_faible=hex2dec('DC');
    Pos_mem_fort=hex2dec('0B');
% Middle finger    
elseif doigt==3
    Pos_mem_faible=hex2dec('C4');
    Pos_mem_fort=hex2dec('0F');
% Annular   
elseif doigt==4
    Pos_mem_faible=hex2dec('AC');
    Pos_mem_fort=hex2dec('13');
% Little finger   
elseif doigt==5
    Pos_mem_faible=hex2dec('94');
    Pos_mem_fort=hex2dec('17');
    
end

%-------------------------------------------------------------------
mot_commande=hex2dec('52');%<--- R
mot_commande2=hex2dec('44');%<--- D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

%CRC16 calcul
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

fwrite(s,[buf,crc16lo,crc16hi]);

% Read the data
for i=1:8
    fread(s,1);
    if i==6
        val1dec=fread(s,1);
        val2dec=fread(s,1);
        val3dec=fread(s,1);
        val4dec=fread(s,1);
    end
    
end

val1=dec2hex(val1dec);
if length(val1)==1
    val1=strcat('0',val1);
end

val2=dec2hex(val2dec);
if length(val2)==1
    val2=strcat('0',val2);
end

val3=dec2hex(val3dec);
if length(val3)==1
    val3=strcat('0',val3);
end

val4=dec2hex(val4dec);

val_hex=strcat(val4,val3,val2,val1);

calcul_i_reel=hex2dec(val_hex);
% calcule_val=['calcul I = ',num2str(val_i_reel)];
% disp(calcule_val);
calcul_i = calcul_i_reel;

return;