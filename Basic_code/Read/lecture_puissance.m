% TASK: Get the power measurement.
% INPUT:
%   s is the serial port associated to the hand
%   doigt is the integer number corresponding to the considered finger.

function Puissance = lecture_puissance(doigt,s)

vitesse=1;
% Compute the motor torque
couple = lecture_couple(doigt,s);

while(vitesse~=0)
    % Compute the finger velocity
    vitesse=lecture_vitesse(doigt,s);
    % Compute the power
    Puissance=vitesse*couple;
end


