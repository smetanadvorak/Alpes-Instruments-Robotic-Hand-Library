
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
number_output = 2;              % Number of acquired contact forces
rotation_thumb = 0;             % Integer number representing the rotation of the THUMB
thumb = 1;                      % Integer number representing the THUMB
index = 2;                      % Integer number representing the INDEX
middle_finger = 3;              % Integer number representing the MIDDLE

current = 750;                  % Limit current (0.075 mA)
reference_force = [0.4, 0.4];   % Reference force [N]  1.2

Kp_index = diag([3.7, 3.7, 0]);        % Proportional gain 2
Ki_index = diag([2.5, 2.5, 0]);        % Integral gain 0.35
Kp_thumb = -diag([4.5, 4.5, 0]);       % Proportional gain 2
Ki_thumb = -diag([2, 2, 0]);           % Integral gain 0.35

X_index = [0.075, -0.015];             % x and y coordinated of the intex fingertip position 
X_thumb = [0.03, 0.065];               % x and y coordinated of the thumb fingertip position

%% Fixed Variables
% Global variables initialization
global Initial_cond 
global error_integral_x error_integral_y    %for the optimisation with integral term
global error_integral_previous
Initial_cond = [0.001,0.001,0.001,0.001,0.001]';
error_integral_x = 0; error_integral_y = 0;
error_integral_previous = [0, 0, 0]';

global Initial_cond_thumb 
global error_integral_x_thumb error_integral_y_thumb
global error_integral_previous_thumb
Initial_cond_thumb = [0.001,0.001,0.001,0.001,0.001]';
error_integral_x_thumb = 0; error_integral_y_thumb = 0;
error_integral_previous_thumb = [0, 0, 0]';

sampling_rate = 25;
force_limit = 5;                    % Maximum measurable force
newton_force = 0;                   % Initial applied force [N]
alpha = 0.1;                        % Smoothing factor of the filter
s_prec = zeros(1,number_output);    % Initial value for the filtering

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
position_thumb = 10000;
position_index = 25000;
position_rotation_thumb = 19000; % Maximum value for the rotation of the thumb
mouv_doigts(position_rotation_thumb, rotation_thumb, s);
pause(2)
mouv_doigts(position_index, index, s);
pause(0.5)
mouv_doigts(position_thumb, thumb, s);
pause(1);

%% Control code
%figure(1);
%title('Simulation');

flushinput(Arduino);
% initial loops waiting the correct readings of the IMU sensor data
for i = 1:50
    adc = readTemp(Arduino, mode, 3);
    adc_force_filtered = ExponentialSmoothingFilter(adc(1:2), s_prec, alpha);
    s_prec = adc_force_filtered;
    newton_force = Calibration_Two_Sensors(adc_force_filtered);

    force_value(i,1:number_output) = newton_force;
%     ref = 1 + sin(theta);
%     ref = reference_force'*ones(1,length(force_value));
%     plot(ref(1,:), 'r');
%     hold on
%     plot(ref(2,:), 'r');
%     hold on
%     plot(force_value(:,1), 'b');
%     hold on
%     plot(force_value(:,2), 'k');
%     hold off
%     pause(0.1)
end

stop_time = 70;
start_time = cputime();
fprintf('START SIMULATION \n');
% Close loop (starting from 0 till the stop_time)
while (cputime() - start_time < stop_time)
    
    % Read the data from Arduino (Measured force)
    tic;
    adc = readTemp(Arduino, mode, 3);
    adc_force_filtered = ExponentialSmoothingFilter(adc(1:2), s_prec, alpha);
    s_prec = adc_force_filtered;

    newton_force = Calibration_Two_Sensors(adc_force_filtered);
    q1_index(i) = deg2rad(Accelerometer_Calibration(adc(3)));

    % Acquire other useful data
    %[register_position(i), position(i)] = lecture_position(s, middle_finger);
    %[register_vitesse(i), vitesse(i)] = lecture_vitesse(middle_finger, s);
    %[current_register(i), current_tension_unit(i)] = lecture_limit_current(middle_finger,s);
    
    % IGM information
    [q2_index(i), q3_index(i)] = Inverse_Geometric_Model(X_index, q1_index(i));
    [q1_thumb(i), q2_thumb(i)] = Inverse_Geometric_Model_Thumb(X_thumb);

    % State vector
    x_index = [q1_index(i),q2_index(i),q3_index(i), 0,0,0, 0,0,0]';
    x_thumb = [q1_thumb(i),q2_thumb(i), 0,0, 0,0]';
    % Angle of the object surface wrt the absolute reference frame
    angle_index(i) = 2*pi - mod(q1_index(i) + q2_index(i) + q3_index(i), 2*pi);
    angle_thumb(i) = 2*pi - mod(q1_thumb(i) + q2_thumb(i), 2*pi);

    % Controller
    %reference_force = 1 + sin(theta(i)); % VARIABLE REFERENCE FORCE

    % Optimesation procedure
    Gamma_index = Optimisation_Procedure_Index(Kp_index, Ki_index, reference_force(2), newton_force(2), x_index);
    Gamma_thumb = Optimisation_Procedure_Thumb(Kp_thumb, Ki_thumb, reference_force(1), newton_force(1), x_thumb);
    
    % Convert the torque value in a voltage one to be applied to the motor
    Voltage = [Torque2Voltage(Gamma_index(1), 0),Torque2Voltage(Gamma_thumb(1), 0)];

    % Apply the control moving the hand
    mode_tensionDoigt(round(Voltage(1)*1e2), current, index, s);
    mode_tensionDoigt(round(Voltage(2)*1e2), current, thumb, s);
        
    % Save data
    tens(i,1:number_output) = Voltage;
    force_value(i,1:number_output) = newton_force;
    error_value(i,1:number_output) = reference_force - newton_force;
    
    % Plotting: force evolution over time
    ref = reference_force'*ones(1,length(force_value));
%    % ref = (1 + sin(theta)); % VARIABLE REFERENCE FORCE
%     plot(ref(1,:), 'r');
%     hold on
%     plot(ref(2,:), 'r');
%     hold on
%     plot(force_value(:,1), 'b');
%     hold on
%     plot(force_value(:,2), 'k');
%     hold off
%     pause(0.005)

    i = i + 1;
    time = [time; toc];
end

fclose(Arduino);
%delete(f);
fprintf('STOP SIMULATION \n');

figure(1)
plot(force_value)

%% Result analysis
sampling_time = sum(time)/length(time);
rt = rise_time (reference_force, force_value, sampling_time);

fine = 308; 
inizio = 60;
% Compute the mean value and the standard deviation of the static error
% using a Gaussian distribution
[mean_value_index, sigma_index] = normfit(abs(error_value(inizio + round(inizio:end/2):fine,2)));
[mean_value_thumb, sigma_thumb] = normfit(abs(error_value(inizio + round(inizio:end/2):fine,1)));

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
plot(x(1:length(force_value(inizio:fine,2))), force_value(inizio:fine,1),'b');
hold on;
plot(x(1:length(force_value(inizio:fine,1))), force_value(inizio:fine,2),'k');
hold on;
y = ref;
y = y(1:length(error_value));
plot(x(1:length(y)), y, 'r')
title('Measured force');
xlabel('Time [sec]');
ylabel('Force [N]');
legend('F_{meas,thumb}','F_{meas,index}','F_d');

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

%% Default values

[MIN_SORTIE_PWM, MAX_SORTIE_PWM] = lecture_MINandMAX_SORTIE_PWM(middle_finger, s);
MIN_SORTIE_PWM_VOLTS = - MIN_SORTIE_PWM * 12 / 4095;
MAX_SORTIE_PWM_VOLTS = MAX_SORTIE_PWM * 12 / 4095;

TEMPS_CALCUL_VITESSE = lecture_TEMPS_CALCUL_VITESSE (middle_finger, s);

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
