% TASK: Get the velocity measurement from the register for all fingers. The
% request is repeated 'times' times.
% INPUT:
%   s is the serial port associated to the hand
%   times

% CHECK THE OUTPUT
function [ speed ] = read_all_speeds( s, times )

if times*6*12 > s.InputBufferSize
    warning(['times variable shouldn''t be greater than ', num2str(floor(s.InputBufferSize/6/12))...
        , '. No read ouput.']);
    return;
end

mot_commande=hex2dec('52');
mot_commande2=hex2dec('44');

registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

% flushinput(s);

for t = 1:times
    for finger = 0:5
        % thumb rotation
        if finger==0
            Pos_mem_faible=hex2dec('03');
            Pos_mem_fort=hex2dec('04');
            % thumb
        elseif finger==1
            Pos_mem_faible=hex2dec('EB');
            Pos_mem_fort=hex2dec('07');
            % index
        elseif finger==2
            Pos_mem_faible=hex2dec('D3');
            Pos_mem_fort=hex2dec('0B');
            % middle finger
        elseif finger==3
            Pos_mem_faible=hex2dec('BB');
            Pos_mem_fort=hex2dec('0F');
            % annular
        elseif finger==4
            Pos_mem_faible=hex2dec('A3');
            Pos_mem_fort=hex2dec('13');
            % little finger
        elseif finger==5
            Pos_mem_faible=hex2dec('8B');
            Pos_mem_fort=hex2dec('17');
        end
        
        buf=[mot_commande,mot_commande2,Pos_mem_faible,...
            Pos_mem_fort,registre_faible,registre_fort];
        
        [crc16hi,crc16lo]=CRC16(buf);
        
        fwrite(s,[buf,crc16lo,crc16hi]);
        
    end
end

w_len = 12; %Word length defined by protocol
f_num = 6; %Number of fingers
w_s = 7; %Data starting position in word
w_e = 10; %Data end position
response = fread(s,w_len*times*f_num);

speed = zeros(times,6);
%% My version, should be faster:
fs = repmat('%02X', 1, 4);
for t = 0:times-1
    for finger = 0:5
        to_take = (t*f_num*w_len+finger*w_len+w_s):(t*f_num*w_len+finger*w_len+w_e);
        speed_hex = sprintf(fs,response(to_take(end:-1:1)));
        speed(t+1,finger+1)=hex2dec(speed_hex);
    end
end

end

