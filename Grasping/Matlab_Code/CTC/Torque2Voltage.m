% TASK: Conversion Torque value in Voltage value.
% INPUTS
% Gamma: torque value in Nm
% w: speed value coming from the speed register (27) [rpm]

function Voltage = Torque2Voltage(Gamma, w)
    R = 27.4;           % Terminal resistance of the motor [Ohm]
    Kt = 0.01 *256;     % Torque constant of the motor [Nm/A]
    Kn = 1/955;         % Speed constant of the motor [V/rpm]
    
    if length(Gamma) > 1
        Gamma = Gamma(1);
    end
    
    Voltage = R*(Gamma/Kt);% + Kn*w); %[V]
    
%     % Transform the tension value from Volt to a scale readable by the hand
%     % (Look the registers documentation given by Alpes Instruments)
%     V = round(Voltage*10^2);
%     if V < -1150
%         fprintf('Tension value is smaller than the minumum one (%d)\n',V);
%         V = -1150;
%     elseif V > 1150
%         fprintf('Tension value is greater than the upper bound (%d)\n',V);
%         V = 1150;
%     end

end