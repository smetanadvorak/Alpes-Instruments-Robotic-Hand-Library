% TASK: Set the Proportional coefficient of the PID controller using the register 8.
% INPUT
%   s: serial port associated to the hand
%   doigt: integer number associated to the finger
%   coeff: value of the Proportional coefficient

function ecriture_coef_p(doigt,coeff,s)

% Transformation of the coefficient value in hexadecimal scale
coeff_hex=dec2hex(coeff);

if length(dec2hex(coeff))==8
    coeff_fort3=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_fort2=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
    coeff_fort=hex2dec(strcat(coeff_hex(5),coeff_hex(6)));
    coeff_faible=hex2dec(strcat(coeff_hex(7),coeff_hex(8)));
    
elseif length(dec2hex(coeff))==7
    coeff_fort3=hex2dec(coeff_hex(1));
    coeff_fort2=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
    coeff_fort=hex2dec(strcat(coeff_hex(4),coeff_hex(5)));
    coeff_faible=hex2dec(strcat(coeff_hex(6),coeff_hex(7)));

elseif length(dec2hex(coeff))==6
    coeff_fort3=0;
    coeff_fort2=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_fort=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
    coeff_faible=hex2dec(strcat(coeff_hex(5),coeff_hex(6)));

elseif length(dec2hex(coeff))==5
    coeff_fort3=0;
    coeff_fort2=hex2dec(coeff_hex(1));
    coeff_fort=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
    coeff_faible=hex2dec(strcat(coeff_hex(4),coeff_hex(5)));
    
elseif length(dec2hex(coeff))==4
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_faible=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
                            
elseif length(dec2hex(coeff))==3
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=hex2dec(coeff_hex(1));
    coeff_faible=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));

elseif  length(dec2hex(coeff))==2
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=0;
    coeff_faible=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    
elseif  length(dec2hex(coeff))==1
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=0;
    coeff_faible=hex2dec(coeff_hex(1));
end

% Depending on the considered finger compute the memory position of the
% register accordingly to the documentation formula. Register 8 is
% considered (COEF_P).

% Thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('F0');
    Pos_mem_fort=hex2dec('03');
% Thumb     
elseif doigt==1
    Pos_mem_faible=hex2dec('D8');
    Pos_mem_fort=hex2dec('07');
% Index
elseif doigt==2
    Pos_mem_faible=hex2dec('C0');
    Pos_mem_fort=hex2dec('0B');
% Middle finger    
elseif doigt==3
    Pos_mem_faible=hex2dec('A8');
    Pos_mem_fort=hex2dec('0F');
% Annular
elseif doigt==4
    Pos_mem_faible=hex2dec('90');
    Pos_mem_fort=hex2dec('13');
% Little finger    
elseif doigt==5
    Pos_mem_faible=hex2dec('78');
    Pos_mem_fort=hex2dec('17');    
end

%-------------------------------------------------------------------
mot_commande=hex2dec('57');%<--- R
mot_commande2=hex2dec('52');%<--- D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

%CRC16 calcul
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort,coeff_faible,coeff_fort,coeff_fort2,coeff_fort3];
[crc16hi,crc16lo]=CRC16(buf);

fwrite(s,[buf,crc16lo,crc16hi]);

% fread(s,7);



return;



