% TASK: Read every register one by one.
% INPUTS
%   s: serial port associated to the hand
%   doigt: integer number associated to the considered finger
%   register_number: number of register (DOCUMENTATION)

function data = lecture_register(doigt, register_number, s)

mot_commande=hex2dec('52'); % R
mot_commande2=hex2dec('44'); % D

memory_position = ((doigt+1)*1000) + register_number;
memory_position_hex = dec2hex(memory_position);

if length(memory_position_hex)==3
    position_fort=memory_position_hex(1);
    position_faible=strcat(memory_position_hex(2),memory_position_hex(3));
else
    position_faible=strcat(memory_position_hex(3),memory_position_hex(4));
    position_fort=strcat(memory_position_hex(1),memory_position_hex(2));
end

Pos_mem_faible = hex2dec(position_faible);
Pos_mem_fort = hex2dec(position_fort);

Registre_faible= 1;%<--- poids faible du nombre de registre
Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

% CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,Registre_faible,Registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

% Make the buffer empty to read the correct data
flushinput(s);

% Write the command on the register
fwrite(s,[buf,crc16lo,crc16hi]);

% Read data
response = fread(s, 12);

% Data transformation
fs = repmat('%02X', 1, 4);
data_hex = sprintf(fs,response(10:-1:7));
data = hex2dec(data_hex);

end


