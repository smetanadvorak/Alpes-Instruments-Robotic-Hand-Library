%% Initialization
clc
clear all
close all

%variables de detection si l'initialisation est faite
d = 0;%<---- main droite

%variables v�rifiant si les mains sont d�ja ouvertes
ouvert_droit=0;
ouvert_gauche=0;

%Initialisation de chaque Mains
delete(instrfindall) ;

s=serial('/dev/tty.usbserial-A703UV4L');
fclose(s);
delete(s);
clear s;

s=serial('/dev/tty.usbserial-A703UV4L');
set(s, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);
fopen(s);

d=initialisationtest(s);
%if d=0 the hand is not yet initialized
if d==0 
    initialisation(s);
    d=1;
end
doigt = 3;

coef_p_before = lecture_coef_i (doigt, s);
coef_i_before = lecture_coef_i (doigt, s);
coef_d_before = lecture_coef_i (doigt, s);
[P_before, I_before, D_before, current_limit_before] = Lecture_coeffs(s);

P = 700;
I = 140;
D = 200;

ecriture_coef_d (doigt, P, s);
ecriture_coef_d (doigt, I, s);
ecriture_coef_d (doigt, D, s);

coef_p = lecture_coef_i (doigt, s);
coef_i = lecture_coef_i (doigt, s);
coef_d = lecture_coef_i (doigt, s);

[P_after, I_after, D_after, current_limit] = Lecture_coeffs(s);
%[P, I, D, current_limit] = Lecture_coeffs(s);

% mouv_main(s2); % hand closed
% back_main(s2); % hand opened
% mouv_doigts(20000, 3, s2); % move 3rd finger to position 20000
% position = lecture_position(s2, 3); % read the position of the 3rd finger