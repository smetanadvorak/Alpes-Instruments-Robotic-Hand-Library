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

% Make the buffer empty to read the correct data
flushinput(s);
fwrite(s,[buf,crc16lo,crc16hi]);

% Read the data
response = fread(s, 12);
fs = repmat('%02X', 1, 4);
coeff_hex = sprintf(fs,response(10:-1:7));
coef_i_reel=hex2dec(coeff_hex);
% calcule_coef=['coefficient I = ',num2str(coef_i_reel)];
% disp(calcule_coef);
coef_i = coef_i_reel;

return;



