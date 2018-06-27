% TASK: compute the CRC16 in order to check the good communication
% INPUT
% buf: the string of commands containing [code_command_1, code_command_2,
%   least_significant_byte_memory_position, most_significant_byte_memory_position,
%   least_significant_byte_register_number,most_significant_byte_register_number,
%   01,00,00,00, least_significant_data, most_significant_data, 00, 00]

function [crc16hi, crc16lo] = CRC16(buf)

crc16hi = uint8(255);
crc16lo = uint8(255);
len = length(buf); % Length of the table to be tested

for byte_index = 1:len
    crc16lo = bitxor(crc16lo,uint8(buf(byte_index)));%<---CRC16 low xor la 
    %                                                valeur du tableur variant de 1 � len on ne le fait qu'avec le low car 
    %                                                les mots que l'on compart avec CRC16 ne fonts que 8 bits
    for bit_index = 1:8
        test1 = bitand(crc16hi,1);%<---prend la valeur 0 ou 1 en fonction de si le dernier bit de CRC16 soit 1 ou 0
        test2 = bitand(crc16lo,1);%<---Et bit � bit entre CRC16lo et 1
        crc16lo = uint8(fix(double(crc16lo)/2));%<---retrecissement du mot de 1bit
        crc16hi = uint8(fix(double(crc16hi)/2));%<---retrecissement du mot de 1bit
        if test1 %<--- comme on a coup� en deux il y � une correction � faire entre les deux mot si CRC16 high finissait par un 1
            crc16lo = bitor(crc16lo,128);%<---si crc16hi avait un 1 au LSB il est r�injecter sur crc16lo 
        end
        if test2 %<--- condition de modification du mot (parit�)
            crc16lo = bitxor(crc16lo,uint8(1));%<---principe du crc16 : X^16+X^14+X (partie 01 en hexa)
            crc16hi = bitxor(crc16hi,uint8(160));%<---principe de ce CRC : X^16+X^14+X (partie A0 en hexa)
        end
    end
end
return
