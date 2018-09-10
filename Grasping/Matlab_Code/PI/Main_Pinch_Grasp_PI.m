%% Main_Pinch_Grasp
clc
clear all
close all

%% Open the communication with the hand
g=0;
ouvert_gauche=0;
delete(instrfindall) ;
s=serial('/dev/tty.usbserial-A703V3A3');
fclose(s);
delete(s);
clear s;

s=serial('/dev/tty.usbserial-A703V3A3');
set(s, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);
if ouvert_gauche==0  
    fopen(s);
    ouvert_gauche=1;
end
g=initialisationtest(s);
if g==0
    initialisation(s);
    g=1;
end

%% Open the communication with the sensor
mode = 'R';
buf_len = 1500;
comPort = '/dev/tty.usbmodem1411';
[Arduino,serialFlag] = setupSerial(comPort);
cleanup_arduino = onCleanup(@()fclose(Arduino));

%% Variables you have to adapt
number_output = 2;      % Number of acquired forces
rotation_thumb = 0;     % Integer number representing the rotation of the THUMB
thumb = 1;              % Integer number representing the THUMB
index = 2;              % Integer number representing the INDEX
middle_finger = 3;      % Integer number representing the MIDDLE

current = 750;          % Limit current (0,075 mA)
reference_force = 0.4;  % Reference force [N]  1.2

Kp = [1, 2];            % Proportional gain of index and thumb respectively
Ki = [0.8, 0.7];        % Integral gain of index and thumb respectively

%% Fixed Variables
sampling_rate = 25;
force_limit = 5;                    % Maximum measurable force
newton_force = 0;                   % Initial applied force [N]
alpha = 0.1;                        % Smoothing factor of the filter
s_prec = zeros(1,number_output);    % Initial value for the filtering
s_prec_index = 0;
s_prec_thumb = 0;
i = 1;
time = [];                          % Samplig time variable
theta = 0:0.01:5*pi;                % Algle for the variable input signal

% variables to save data
adc_data = zeros(10*sampling_rate, number_output);
newton_data = zeros(10*sampling_rate, number_output);
error = zeros(10*sampling_rate, number_output);
force_value = zeros(10*sampling_rate, number_output);
error_value = zeros(10*sampling_rate, number_output);
error_integral_value = zeros(10*sampling_rate, number_output);

%% Fingers configuration
%Put the hand in the initial configuration
mouv_doigts(0, index, s);
pause(0.5)
mouv_doigts(0, thumb, s);
pause(0.2)
mouv_doigts(0, rotation_thumb, s);
pause(2)
% Put the hand in a position of contact
position_thumb = 11000;
position_index = 26000;
position_rotation_thumb = 19000;
mouv_doigts(position_rotation_thumb, rotation_thumb, s);
pause(2)
mouv_doigts(position_index, index, s);
pause(0.5)
mouv_doigts(position_thumb, thumb, s);
pause(1);

%% Control code
figure(1);
title('Simulation');

flushinput(Arduino);
% initial loops waiting the correct readings of the IMU sensor data
for i = 1:50
    adc = readTemp(Arduino, mode, 3);
    adc_force_filtered = ExponentialSmoothingFilter(adc(1:2), s_prec, alpha);
    s_prec = adc_force_filtered;
    newton_force = Calibration_Two_Sensors(adc_force_filtered);

    force_value(i,1:number_output) = newton_force;
    %ref = 1 + sin(theta); % VARIABLE REFERENCE FORCE
    ref = reference_force*ones(1,length(force_value));
    plot(ref, 'r');
    hold on;
    plot(force_value, 'b');
    hold off;
    pause(0.1)
end

stop_time = 90;
start_time = cputime();
fprintf('START SIMULATION \n');
% The loop starts from 0 till the stop_time
while (cputime() - start_time < stop_time)
    
    % Read the data from Arduino (Measured force)
    tic;
    adc_force = readTemp(Arduino, mode, 3);
    adc_force_filtered = ExponentialSmoothingFilter(adc_force(1:2), s_prec, alpha);
    s_prec = adc_force_filtered;
    newton_force = Calibration_Two_Sensors(adc_force_filtered);
    q1(i) = adc_force(3);
    
    % Proportional controller
    %reference_force = (1 + sin(theta(i))); % VARIABLE REFERENCE FORCE
    E = reference_force - newton_force;
    error = [error(2:end,:); E];
    if i == 1
        for j = 1:number_output
            E_integral(1,j) = Euler(0, E(j), 0.075);
        end
    else
        for j = 1:number_output
            E_integral(1,j) = Euler(error_integral_value(i-1,j), E(j), 0.075);
        end
    end
    tens(i,:) = Ki.*E_integral + Kp.*E;

    % Transform the tension value from Volt to a scale readable by the hand
    % (Look the registers documentation given by Alpes Instruments)
    tension = ceil(tens(i,:)*10^2);
    if tension < -1150
        disp('Tension value is smaller than the minumum one!');
        fprintf('%d\n',tension);
        tension = [-1150, -1150];
    elseif tension > 1150
        disp('Tension value is greater than the upper bound!');
        fprintf('%d\n',tension);
        tension = [1150, 1150];
        tens(i,:) = [11.50, 11.50];
    end
    
    % Apply the control moving the hand
    mode_tensionDoigt (tension(1), current, thumb, s);
    mode_tensionDoigt (tension(2), current, index, s);
    
    % Acquire other useful data
%     [register_position(i), position(i)] = lecture_position(s, middle_finger);
%     [register_vitesse(i), vitesse(i)] = lecture_vitesse(middle_finger, s);
%     [current_register(i), current_tension_unit(i)] = lecture_limit_current(middle_finger,s);  
    % Save data
    force_value(i,1:number_output) = newton_force;
    error_value(i,1:number_output) = E;
    error_integral_value(i,1:number_output) = E_integral;
    
    % Plotting: error evolution over time
    ref = reference_force'*ones(1,length(force_value));
    %ref = (1 + sin(theta)); % VARIABLE REFERENCE FORCE
    plot(ref(1,:), 'r');
    hold on
    plot(force_value(:,1), 'b');
    hold on
    plot(force_value(:,2), 'k');
    hold off
    pause(0.1)
 
    i = i+1;
    time = [time; toc];
end

fclose(Arduino);
fprintf('STOP SIMULATION \n');

%% Result analysis
sampling_time = sum(time)/length(time);
rt = rise_time (reference_force, force_value, sampling_time);

% Compute the mean value and the standard deviation of the static error
% using a Gaussian distribution
[mean_value_index, sigma_index] = normfit(abs(error_value(125 + round(125:end/2):end,2)));
[mean_value_thumb, sigma_thumb] = normfit(abs(error_value(125 + round(125:end/2):end,1)));


figure(2) % Static error plot
x = 1:sampling_time:length(error_value);
x = x(1:length(error_value));
plot(x, error_value(:,1),'b');
hold on;
plot(x, error_value(:,2),'k');
hold on;
y = zeros(1, length(error_value));
plot(x, y, 'r')
title('Fd - F');
xlabel('Time [sec]');
ylabel('Error');

figure(3) % Contact force plot
plot(x(1:386), force_value(119:end,1),'b');
hold on;
plot(x(1:386), force_value(119:end,2),'k');
hold on;
y = ref;
y = y(1:length(error_value));
plot(x, y, 'r')
title('Measured force');
xlabel('Time [sec]');
ylabel('Force [N]');
legend('F_{meas}','F_d');

figure(5) % Tension vs Contact force plot
plot(x, y, 'r');
hold on
plot(x, tens,'b')
hold on
plot(x, force_value,'k');
title('Applied tension on the motor during control');
xlabel('Time [sec]')
ylabel('Tension [V]');
legend('F_d', 'Voltage', 'Measured force');

%% Torque evaluation
R = 27.4;                           %[Ohm]
L = 0.399 * 10^(-3);                %[H]
I_limit = 0.075;                    %[A] it corresponds to 750 in hand unit
Kn = 955 * (2*pi/60);               %[rad/(sec*V)]
Kt = 10 * 10^(-3) * 256;            %[Nm/A] (256 for the reductor)

speed_cutted = vitesse;
speed_cutted(speed_cutted > 1000) = nan;
Istar = tens/R;
Istar_speed = (tens - speed_cutted/Kn)/R;
Gamma = Kt * min(Istar_speed, I_limit);

figure(4)
plot(x, speed_cutted);
title('Motor speed');
xlabel('Time [sec]')
ylabel('Speed [rad/sec]');

figure(6)
plot(x, tens);
xlabel('Time [sec]')
ylabel('Applied tension from the controller [V]');
title('Applied voltage');

figure(7)
plot(x, Istar_speed);
hold on
plot(x, I_limit*ones(1, length(x)), 'r');
title('Evolution over time of the current');
xlabel('Time [sec]')
ylabel('Current [A]');
legend('Current', 'Limit\_current');

figure(10)
yyaxis left
plot(x, Gamma);
ylabel('Torque [Nm]');
hold on
yyaxis right
plot(x, tens);
title('Motor torque and applied voltage');
xlabel('Time [sec]')
ylabel('Voltage [V]')

figure(11)
yyaxis left
plot(x, Gamma);
ylabel('Torque [Nm]');
hold on
yyaxis right
plot(x, force_value);
title('Motor torque and measured force');
xlabel('Time [sec]')
ylabel('Measured force [N]')
