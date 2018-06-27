%% Proportional force control u = Kp(Fd - F)
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
    %initialisation(s);
    g=1;
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

% Useful parameters
number_output = 1;      % Only one finger is controlled 
sampling_rate = 25;
force_limit = 5;
i = 1;

doigt = 3;              % Integer number representing the INDEX
current = 650;          % Limit current
reference_force = 1;    % Reference force [N]
newton_force = 0;       % Initial applied force [N]
Kp = 12;                % Proportional gain
Ki = 0.7;                 % Integral gain
alpha = 0.1;            % Smoothing factor of the filter
theta = 0:0.01:5*pi;

% Initialization of the variables
adc_data = zeros(buf_len, number_output);
newton_data = zeros(buf_len, number_output);
error = zeros(10*sampling_rate, 1);
force_value = [];
error_value = [];
error_integral_value = zeros(1, 1000);
s_prec = 0;
time = [];

% Put the hand in the initial configuration
mouv_doigts(0, doigt, s);
pause(2)
% Put the hand in a position of contact
contact_position = 25000;
mouv_doigts(contact_position, doigt, s);
pause(2);

profile on;
figure(1);
title('Simulation');

stop_time = 80;
start_time = cputime();
fprintf('START SIMULATION \n');
tic;
% The loop starts from 0 till the stop_time
while (cputime() - start_time < stop_time)
    
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    
    % Read the data from Arduino (Measured force)
    time = [time; toc];
    tic;
    adc_force = readTemp(Arduino, mode, number_output);
    adc_force_filtered = ExponentialSmoothingFilter(adc_force, s_prec, alpha);
    s_prec = adc_force_filtered;
    newton_force = adc_to_newtons(adc_force_filtered);
    
    % Proportional controller
    %reference_force = (1 + sin(theta(i)));
    E = reference_force - newton_force;
    error = [error(2:end,:); E];
    if i == 1
        E_integral = Euler(0, E, 0.075);
    else
        E_integral = Euler(error_integral_value(i-1), E, 0.075);
    end
    tens(i) = Kp*E + Ki*E_integral;

    % Transform the tension value from Volt to a scale readable by the hand
    % (Look the registers documentation given by Alpes Instruments)
    tension = ceil(tens(i)*10^2);
    if tension < -1150
        disp('Tension value is smaller than the minumum one!');
        fprintf('%d\n',tension);
        tension = -1150;
    elseif tension > 1150
        disp('Tension value is greater than the upper bound!');
        fprintf('%d\n',tension);
        tension = 1150;
        tens(i) = 11.50;
    end
    
    % Apply the control moving the hand
    mode_tensionDoigt (tension, current, doigt, s);
    pause(0.01);
    
    % Acquire other useful data
    [register_position(i), position(i)] = lecture_position(s, doigt);
    [register_vitesse(i), vitesse(i)] = lecture_vitesse(doigt, s);
    [current_register(i), current_tension_unit(i)] = lecture_limit_current(doigt,s);
    
    % Save data
    force_value(i) = newton_force;
    error_value(i) = E;
    error_integral_value(i) = E_integral;
    %error_derivative_value(i) = E_derivative;
    
    % Plotting: error evolution over time
    ref = reference_force*ones(1,length(force_value));
    %ref = (1 + sin(theta));
    plot(ref, 'r');
    hold on;
    plot(force_value, 'b');
    hold off;
    axis([1,1000,0,4]);
    
    % Update waitbar and message
    percentage = floor(((cputime() - start_time)/stop_time)*100);
    waitbar((cputime() - start_time)/stop_time,f,sprintf('%d',percentage))
    
    i = i+1;
end

profile report;
fclose(Arduino);
delete(f);
fprintf('STOP SIMULATION \n');

%% Result analysis
sampling_time = sum(time)/length(time);

x = 1:sampling_time:length(error_value);
x = x(1:length(error_value));
% Static error value
[mean_value, sigma] = normfit(error_value(round(end/2):end));
fprintf('**************************************** \n');
fprintf('* Remaining error: %f ± %f * \n', mean_value, sigma);
fprintf('**************************************** \n');

figure(2);
plot(x, error_value,'b');
hold on;
y = zeros(1, length(error_value));
plot(x, y, 'r')
title('Error evolution over time');
xlabel('Time [sec]');
ylabel('Error');
hold on
plot(x(round(end/2):end),error_value(round(end/2):end), 'Color','g');
hold off;

figure(3);
plot(x, force_value,'b');
hold on;
y = ref;
y = y(1:length(error_value));
plot(x, y, 'r')
title('Measured force evolution over time');
xlabel('Time [sec]');
ylabel('Force [N]');
legend('F_{meas}','F_d');
hold off;

figure(5)
plot(x, y, 'r');
hold on
plot(x, tens,'b')
hold on
plot(x, force_value,'k');
title('Applied tension on the motor during control');
xlabel('Time [sec]')
ylabel('Tension [V]');
legend('F_d', 'Voltage', 'Measured force');

%% Default values from registers
[MIN_SORTIE_PWM, MAX_SORTIE_PWM] = lecture_MINandMAX_SORTIE_PWM(doigt, s);
MIN_SORTIE_PWM_VOLTS = - MIN_SORTIE_PWM * 12 / 4095;
MAX_SORTIE_PWM_VOLTS = MAX_SORTIE_PWM * 12 / 4095;

TEMPS_CALCUL_VITESSE = lecture_TEMPS_CALCUL_VITESSE (doigt, s);

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
