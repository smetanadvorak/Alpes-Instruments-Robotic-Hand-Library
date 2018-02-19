% TASK: Apply a limit value to the current writing on registre 8 (COEF_P).
% INPUTS
%   s: is the serial port associated to the hand
%   doigt: integer number associated to the finger we want to apply the
%       limit to
%   coeff: limit value of the current for the finger 'doigt'.

function ecriture_limite_courant(doigt,coeff,s)
% The possible values for the current are in the interval [0,750]
if coeff > 750
    coeff_reel = 750;
elseif coeff < 0
    coeff_reel = 0;
else
    coeff_reel = coeff;
end

% Transform the current value in such a way the hand can understand it. The
% coeff variable is transformed in hexadecimal and if its length is not 4,
% (length-4) number of 0 are added. The first two characters represents the
% most significant byte, while the final two are the least significant
% ones.
coeff_hex=dec2hex(coeff_reel);
if length(dec2hex(coeff_reel))==8
    coeff_fort3=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_fort2=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
    coeff_fort=hex2dec(strcat(coeff_hex(5),coeff_hex(6)));
    coeff_faible=hex2dec(strcat(coeff_hex(7),coeff_hex(8)));
elseif length(dec2hex(coeff_reel))==7
    coeff_fort3=hex2dec(coeff_hex(1));
    coeff_fort2=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
    coeff_fort=hex2dec(strcat(coeff_hex(4),coeff_hex(5)));
    coeff_faible=hex2dec(strcat(coeff_hex(6),coeff_hex(7)));
elseif length(dec2hex(coeff_reel))==6
    coeff_fort3=0;
    coeff_fort2=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_fort=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
    coeff_faible=hex2dec(strcat(coeff_hex(5),coeff_hex(6)));
elseif length(dec2hex(coeff_reel))==5
    coeff_fort3=0;
    coeff_fort2=hex2dec(coeff_hex(1));
    coeff_fort=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
    coeff_faible=hex2dec(strcat(coeff_hex(4),coeff_hex(5)));    
elseif length(dec2hex(coeff_reel))==4
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_faible=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));                           
elseif length(dec2hex(coeff_reel))==3
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=hex2dec(coeff_hex(1));
    coeff_faible=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
elseif  length(dec2hex(coeff_reel))==2
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=0;
    coeff_faible=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));    
elseif  length(dec2hex(coeff_reel))==1
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=0;
    coeff_faible=hex2dec(coeff_hex(1));
end

% Define the command string.

% thumb rotation
if doigt==0
    Pos_mem_faible=hex2dec('EA');
    Pos_mem_fort=hex2dec('03');
% thumb    
elseif doigt==1
    Pos_mem_faible=hex2dec('D2');
    Pos_mem_fort=hex2dec('07');
% index    
elseif doigt==2
    Pos_mem_faible=hex2dec('BA');
    Pos_mem_fort=hex2dec('0B');
% middle finger     
elseif doigt==3
    Pos_mem_faible=hex2dec('A2');
    Pos_mem_fort=hex2dec('0F');
% annular    
elseif doigt==4
    Pos_mem_faible=hex2dec('8A');
    Pos_mem_fort=hex2dec('13');
% little finger     
elseif doigt==5
    Pos_mem_faible=hex2dec('72');
    Pos_mem_fort=hex2dec('17');    
end

flushinput(s);
mot_commande=hex2dec('57'); % W
mot_commande2=hex2dec('52'); % R
registre_faible=hex2dec('01'); % least significant byte of the register number
registre_fort=hex2dec('00'); % most significant byte of the register number

%CRC16 computation
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort,coeff_faible,coeff_fort,coeff_fort2,coeff_fort3];
[crc16hi,crc16lo]=CRC16(buf);

% Send the command to the hand's register
fwrite(s,[buf,crc16lo,crc16hi]);
% Read the command by the register so as not to interfere with other 
% readings of the principal
fread(s,8);

end



