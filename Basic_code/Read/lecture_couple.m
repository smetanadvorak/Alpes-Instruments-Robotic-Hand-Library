% TASK: Get the motor torque measurement using 26th register.
% constants:
%           nominal torque :    Cpn=2.03 mNm
%           nominal current:    Cn=0.211 A
%           stall torque:       Cpd=4.38 mNm 
%           starting current:   Cd=0.438 A
% then the motor's torque constant Kt = (Cpd-Cn)/(Cd-Cn) = 10.35
% INPUT:
%   s is the serial port associated to the hand
%   doigt is the integer number corresponding to the considered finger 

function couple_doigt = lecture_couple(doigt,s)

Pos_mem_faible_3=0;
Pos_mem_fort_3=0;

% thumb rotation
if doigt==0
    Pos_mem_faible_3=hex2dec('EA');
    Pos_mem_fort_3=hex2dec('03');
% thumb    
elseif doigt==1
    Pos_mem_faible_3=hex2dec('D2');
    Pos_mem_fort_3=hex2dec('07');
% index    
elseif doigt==2
    Pos_mem_faible_3=hex2dec('BA');
    Pos_mem_fort_3=hex2dec('0B');
% middle finger     
elseif doigt==3
    Pos_mem_faible_3=hex2dec('A2');
    Pos_mem_fort_3=hex2dec('0F');
% annular    
elseif doigt==4
    Pos_mem_faible_3=hex2dec('8A');
    Pos_mem_fort_3=hex2dec('13');
% little finger     
elseif doigt==5
    Pos_mem_faible_3=hex2dec('72');
    Pos_mem_fort_3=hex2dec('17');    
end

mot_commande_3=hex2dec('52'); % R
mot_commande2_3=hex2dec('44'); % D

registre_faible_3=hex2dec('01');
registre_fort_3=hex2dec('00');

%CRC16 computation
buf_3=[mot_commande_3,mot_commande2_3,Pos_mem_faible_3,...
    Pos_mem_fort_3,registre_faible_3,registre_fort_3];
[crc16hi_3,crc16lo_3]=CRC16(buf_3);

% Send the command to the hand
fwrite(s,[buf_3,crc16lo_3,crc16hi_3]);

% Read the data
m=0;
fread(s,1);
CPT_TH_1=2;
    while(m~=CPT_TH_1)
        val_1=fread(s,1);
        valeur_registre=str2double(strcat(num2str(registre_fort_3),num2str(registre_faible_3)))*4;
        CPT_TH_1=valeur_registre+7;
        m=m+1;
        if m==6
            amp1=dec2hex(val_1);
        end
        
        if m==7
            amp2=dec2hex(val_1);
        end   
    end
    
    % Transform the data such dìthat it can be transformed in decimal
    ampere_hex=strcat(amp2,amp1);
    ampere_reel=(hex2dec(ampere_hex)*3.3)/65535; % Ratio given by the company

    couple_doigt=ampere_reel*10.35;
    return;
end
    
