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

% Make the buffer empty to read the correct data
flushinput(s);
fwrite(s,[buf,crc16lo,crc16hi]);

% Read the data
response = fread(s, 12);
fs = repmat('%02X', 1, 4);
val_hex = sprintf(fs,response(10:-1:7));

calcul_i_reel=hex2dec(val_hex);
% calcule_val=['calcul I = ',num2str(val_i_reel)];
% disp(calcule_val);
calcul_i = calcul_i_reel;

return;