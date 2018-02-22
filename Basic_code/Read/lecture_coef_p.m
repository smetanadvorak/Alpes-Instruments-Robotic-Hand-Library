% TASK: Get the Derivative coefficient of the PID controller using the register 8.
% INPUT
%   s: serial port associated to the hand
%   doigt: integer number associated to the finger we want to move

function coef_p=lecture_coef_p(doigt,s)

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
coeff_hex = sprintf(fs,response(10:-1:7));
coef_p_reel = hex2dec(coeff_hex);
% calcule_coef=['coefficient P = ',num2str(coef_p_reel)];
% disp(calcule_coef);
coef_p = coef_p_reel;

return;



