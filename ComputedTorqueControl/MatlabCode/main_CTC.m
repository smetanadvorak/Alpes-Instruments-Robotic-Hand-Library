%function [error_value, force_value] = main_CTC_accelerometer (reference_force)
%% Computed torque control without the observer 
% knowing the position of the fingertip and measuring q1
clear all
close all

%% Open the communication with the hand
ouvert_gauche = 0;
delete(instrfindall) ;
s = serial('/dev/tty.usbserial-A703V3A3');
fclose(s);
delete(s);
clear s;

s = serial('/dev/tty.usbserial-A703V3A3');
set(s, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);
if ouvert_gauche == 0  
    fopen(s);
    ouvert_gauche=1;
end
g = initialisationtest(s);
if g == 0
    initialisation(s);
    g = 1;
end

%% Open the communication with the sensor
mode = 'R';
buf_len = 1500;
comPort = '/dev/tty.usbmodem1421';
[Arduino,serialFlag] = setupSerial(comPort);
cleanup_arduino = onCleanup(@()fclose(Arduino));

%% Acquire data
% Percentage bar
f = waitbar(0,'1','Name','Simulation...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);

% Global variables initialization
global Initial_cond 
global error_integral_x error_integral_y % Integral term in the optimisation porcedure
global error_integral_previous
Initial_cond = [0.001,0.001,0.001,0.001,0.001]';
error_integral_x = 0; error_integral_y = 0;
error_integral_previous = [0, 0, 0]';

% Fixed Variables
sampling_rate = 17;
number_output = 1;              % Only one finger is controlled 
limit_current = 750;            % Limit current
newton_force = 0;               % Initial applied force [N]
Gamma = [0, 0, 0]';             % Torque initialization
Voltage = 0;                    % Voltage initialization
alpha = 0.1;                    % Smoothing factor of the filter
s_prec = 0;                     % precedent measurements of the force sensor
theta = 0:0.01:5*pi;
i = 1;
time = [];

% Variables you have to ADAPT
doigt = 2;                      % Integer number representing the INDEX
reference_force = 1.5;          % Reference force [N]
Kp = -diag([1, 1, 0]);          % Proportional gain
Ki = -diag([0.8, 0.8, 0]);      % Integral gain
X = [0.092, 0.042];             % Fingertip position (x,y)

% Initialization of the variables to save data
adc_data = zeros(buf_len, number_output);
newton_data = zeros(buf_len, number_output);
force_value = nan*ones(10*sampling_rate, 1);
error_value = nan*ones(10*sampling_rate, 1);
torque = nan*ones(10*sampling_rate, 3);
tens = nan*ones(10*sampling_rate, 1);
x_observer = nan*ones(10*sampling_rate, 6);
position = nan*ones(10*sampling_rate, 1);
vitesse = nan*ones(10*sampling_rate, 1);
current_tension_unit = nan*ones(10*sampling_rate, 1);

% Put the hand in the initial configuration
mouv_doigts(0, doigt, s);
pause(2)
% Put the hand in a position of contact
contact_position = 22000;
mouv_doigts(contact_position, doigt, s);
pause(2);

figure(1);
title('Simulation');
% Clean the arduino buffer
flushinput(Arduino);
for i = 1:22
    adc = readTemp(Arduino, mode, number_output);
    adc_force_filtered = ExponentialSmoothingFilter(adc(2), s_prec, alpha);
    s_prec = adc_force_filtered;
    % Using FSR
    newton_force = adc_to_newtons(adc_force_filtered);
    % Using straing gauge with load cell
    %newton_force = Strain_Gauge_Data_Calibration(adc_force_filtered);
    
    % Measure q1 and compute q2 and q3 using IGM. Velocity and acceleration
    % of the joint coordinates are neglected assuming quasi-static
    % conditions:
    q1(i) = deg2rad(Accelerometer_Calibration(adc(3)));
    [q2(i), q3(i)] = Inverse_Geometric_Model(X, q1(i));
  
    force_value(i) = newton_force;
    %ref = 1 + sin(theta);
    ref = reference_force*ones(1,length(force_value));
    plot(ref, 'r');
    hold on;
    plot(force_value, 'b');
    hold off;
    pause(0.1)
end

stop_time = 70;
start_time = cputime();
fprintf('START SIMULATION \n');
% The loop starts from 0 till the stop_time
while (cputime() - start_time < stop_time)
    tic;
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    
    % Read the data from Arduino (Measured force and accelerometer measure (q1))
    adc = readTemp(Arduino, mode, number_output);
    adc_force_filtered = ExponentialSmoothingFilter(adc(1), s_prec, alpha);
    s_prec = adc_force_filtered;
    %newton_force = Strain_Gauge_Data_Calibration(adc_force_filtered);
    newton_force = adc_to_newtons(adc_force_filtered, 0.0933);

    q1(i) = deg2rad(Accelerometer_Calibration(adc(2)));
    
    % Acquire other useful data
    [~, position(i)] = lecture_position(s, doigt);
    [~, vitesse(i)] = lecture_vitesse(doigt, s);
    [~, current_tension_unit(i)] = lecture_limit_current(doigt,s);
    
    % IGM information
    % Measure q1 and compute q2 and q3 using IGM. Velocity and acceleration
    % of the joint coordinates are neglected assuming quasi-static
    % conditions:
    [q2(i), q3(i)] = Inverse_Geometric_Model(X, q1(i));

    x = [q1(i),q2(i),q3(i), 0,0,0,0,0,0]';
    % Angle of the object surface wrt the absolute reference frame
    angle(i) = 2*pi - mod(q1(i) + q2(i) + q3(i), 2*pi);
    
    % Controller
    %reference_force = 1 + sin(theta(i));
    [Gamma,Fx,Fy,q,dq,dm,b, f_value] = Optimisation_Procedure_new(Kp, Ki, reference_force, newton_force, x);
    Voltage = Torque2Voltage(Gamma(1), vitesse(i));
    fprintf('Voltage value %d [V]\n', Voltage*1e-2)
    
    % Apply the control moving the hand
    mode_tensionDoigt(round(Voltage*1e2), limit_current, doigt, s);
    pause(0.01);
    
    % Save data
    Opt_error(i) = f_value;
    Fx_value(i) = Fx;
    Fy_value(i) = Fy;
    torque(i,:) = Gamma';
    tens(i) = Voltage;
    force_value(i) = newton_force;
    error_value(i) = reference_force - newton_force;
    
    % Plotting: error evolution over time
    %ref = 1 + sin(theta);
    ref = reference_force*ones(1,length(force_value));
    plot(ref, 'r');
    hold on;
    plot(force_value, 'b');
    hold off;
    
    % Update waitbar and message
    percentage = floor(((cputime() - start_time)/stop_time)*100);
    waitbar((cputime() - start_time)/stop_time,f,sprintf('%d',percentage))
    
    time(i) = toc;
    i = i+1;
end

%profile report;
fclose(Arduino);
fclose(s);
delete(f);
fprintf('STOP SIMULATION \n');

%% PLOTTING DATA
sampling_time = sum(time)/length(time);
x = 1:sampling_time:length(error_value);
x = x(1:length(error_value));
rt = rise_time(reference_force, force_value, sampling_time);

E = error_value;
E(isnan(E)) = [];
[mean_value, sigma] = normfit(abs(E(round(length(E)/2):end)));
fprintf('**************************************** \n');
fprintf('* Remaining error: %f ± %f * \n', mean_value, sigma);
fprintf('**************************************** \n');

figure(2);
plot(x, error_value,'b');
hold on;
y = zeros(1, length(error_value));
plot(x, y, 'r')
title('Error evolution (Fd - F)');
xlabel('Time [sec]');
ylabel('Error');

figure(3);
plot(x(1:length(force_value)), force_value,'b');
hold on;
y = ref;
y = y(1:length(error_value));
plot(x, y, 'r')
title('Measured force');
xlabel('Time [sec]');
ylabel('Force [N]');
legend('F_{meas}','F_d');

figure(4)
subplot(3,1,1)
plot(x(1:length(q1)), q1)
xlabel('Time [sec]')
ylabel('q1 [rad]')
subplot(3,1,2)
plot(x(1:length(q2)), q2)
xlabel('Time [sec]')
ylabel('q2 [rad]')
subplot(3,1,3)
plot(x(1:length(q3)), q3)
xlabel('Time [sec]')
ylabel('q3 [rad]')
title('Evolution over time of obverved q1')

figure(7)
yyaxis left
plot(x, torque(:,1));
ylabel('Torque [Nm]');
hold on
yyaxis right
plot(x, tens);
title('Motor torque and applied voltage');
xlabel('Time [sec]')
ylabel('Voltage [V]')

figure(8)
yyaxis left
plot(x, torque(:,1));
ylabel('Torque [Nm]');
hold on
yyaxis right
plot(x, force_value);
title('Motor torque and measured force');
xlabel('Time [sec]')
ylabel('Measured force [N]')

figure(9)
plot(x, vitesse')
ylabel('Speed [rad/sec]')
xlabel('Time [sec]')

%% Other plots

figure(11)
yyaxis left
plot(x, torque(:,2:3))
ylabel('Torques [Nm]')
hold on
yyaxis right
plot(x(1:length(Fx_value)), Fx_value)
hold on
plot(x(1:length(Fy_value)), Fy_value)
xlabel('Time [sec]')
ylabel('Shear force [N]')
legend('Gamma_2','Gamma_3','F_f^x','F_f^y')

% figure(12)
% plot(x(1:length(shear_force)), shear_force')
% hold on
% plot(x, force_value,'r')
% title('Contact force components')
% xlabel('Time [sec]')
% ylabel('[N]')
% legend('F_x','F_y','F_m')

figure(13)
yyaxis left
plot(x(1:length(Opt_error)), Opt_error)
ylabel('Optimisation error')
hold on
yyaxis right
plot(x(1:length(force_value)), force_value)
xlabel('Time [sec]')
ylabel('Measured force')

figure(14)
plot(x(1:length(B)), B)
title('Known term of the optimization')
xlabel('Time [sec]')
ylabel('[Nm]')
legend('Component_1','Component_2','Component_3')

figure(15)
plot(x(1:length(force_value)), -force_value*sin(angle),'b')
hold on
plot(x, -y*sin(angle),'r')

figure(16)
plot(x(1:length(force_value)), force_value*cos(angle), 'b')
hold on
plot(x, y*cos(angle),'r')
