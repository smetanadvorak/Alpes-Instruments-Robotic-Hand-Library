% TASK: Get the Derivative coefficient of the PID controller using the register 9.
% INPUT
%   s: serial port associated to the hand
%   doigt: integer number associated to the finger we want to move

function coef_i=lecture_coef_i(doigt,s)

% Depending on the considered finger compute the memory position of the
% register accordingly to the documentation formula. Register 9 is
% considered (COEF_I).

% Thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('F1');
    Pos_mem_fort=hex2dec('03');
% Thumb     
elseif doigt==1
    Pos_mem_faible=hex2dec('D9');
    Pos_mem_fort=hex2dec('07');
% Index    
elseif doigt==2
    Pos_mem_faible=hex2dec('C1');
    Pos_mem_fort=hex2dec('0B');
% Middle finger    
elseif doigt==3
    Pos_mem_faible=hex2dec('A9');
    Pos_mem_fort=hex2dec('0F');
% Annular    
elseif doigt==4
    Pos_mem_faible=hex2dec('91');
    Pos_mem_fort=hex2dec('13');
% Little finger    
elseif doigt==5
    Pos_mem_faible=hex2dec('79');
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

% Read the coefficient value
for i=1:8
    fread(s,1);
    if i==6
        coef1dec=fread(s,1);
        coef2dec=fread(s,1);
        coef3dec=fread(s,1);
        coef4dec=fread(s,1);
    end
    
end

coef1=dec2hex(coef1dec);
if length(coef1)==1
    coef1=strcat('0',coef1);
end

coef2=dec2hex(coef2dec);
if length(coef2)==1
    coef2=strcat('0',coef2);
end

coef3=dec2hex(coef3dec);
if length(coef3)==1
    coef3=strcat('0',coef3);
end

%inutile pour celui la car c'est celui qui vas etre en premier dans la
%concaténation
coef4=dec2hex(coef4dec);

coeff_hex=strcat(coef4,coef3,coef2,coef1);

coef_i_reel=hex2dec(coeff_hex);
% calcule_coef=['coefficient I = ',num2str(coef_i_reel)];
% disp(calcule_coef);
coef_i = coef_i_reel;

return;



