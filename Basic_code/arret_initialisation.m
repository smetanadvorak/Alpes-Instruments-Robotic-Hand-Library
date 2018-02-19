% TASK: Stop the initialization procedure
% INPUT
%   s: serial port associated to the hand.

function arret_initialisation(s)

code_ascii_W=hex2dec('57');
code_ascii_R=hex2dec('52');
pos_mem_faible=hex2dec('64');
pos_mem_fort=hex2dec('00');
nb_registre_faible=hex2dec('01');
nb_registre_fort=hex2dec('00');
poids_valeur1_1=hex2dec('00');%  ]
poids_valeur1_2=hex2dec('00');%  } poids de la valeur à
poids_valeur1_3=hex2dec('00');%  } écrire dans le registre
poids_valeur1_4=hex2dec('00');%  ]


buf=[code_ascii_W,code_ascii_R,pos_mem_faible,pos_mem_fort,nb_registre_faible,...
    nb_registre_fort,poids_valeur1_1,poids_valeur1_2,poids_valeur1_3,poids_valeur1_4];

[crc16hi,crc16lo]=CRC16(buf);

fwrite(s,[buf,crc16lo,crc16hi]);

fread(s,7);
end
