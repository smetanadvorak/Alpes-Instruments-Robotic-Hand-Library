% TASK: Check the correct initialization.
% INPUT
%   s: serial port associated to the hand.
% OUTPUT
%   result: 1 if ok, 0 if not

function [result] = initialisationtest(s)
result=0;

% Creation of the command string
mot_commande=hex2dec('52'); %<--- R
mot_commande2=hex2dec('44'); %<--- D

Pos_mem_faible=hex2dec('64');
Pos_mem_fort=hex2dec('00');

Registre_faible=hex2dec('01');%<--- poids faible du nombre de registre
Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

% CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,Registre_faible,Registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

% Write the command on the hand
fwrite(s,[buf,crc16lo,crc16hi]);

% Read the responce: the useful data are contained at sixth position of the
% command string. If the read data is 1, it means that the hand is
% correctly initialised
for i=1:11
    fread(s,1);
    if i==6
        test=fread(s,1);
    end
end

if test==1
    result=1;
end
end