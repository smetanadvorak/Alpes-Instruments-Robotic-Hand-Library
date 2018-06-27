% TASK: PI controller on one finger of the Alpes Instruments robotic hand
% INPUTS
%   doigt: integer number identifying the finger we want to move
%   reference_force
%   current: limit current of the motor
%   contact_position: encoder position at which contact occurs
%   Kp: Proportional gain
%   Ki: Integral gain
% OUTPUTS
%   error_value
%   force_value

function [error_value, force_value] = PI_controller (doigt, reference_force, current, contact_position, Kp, Ki, Kd)

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
newton_force = 0;       % Initial applied force [N]

% Initialization of the variables
adc_data = zeros(buf_len, number_output);
newton_data = zeros(buf_len, number_output);
error = zeros(10*sampling_rate, 1);
force_value = zeros(1, 1000);
error_value = zeros(1, 1000);
error_integral_value = zeros(1, 1000);
time = [];

% Put the hand in the initial configuration
back_main(s);
pause(2);
% Put the hand in a position of contact
mouv_doigts(contact_position, doigt, s);
pause(2);

profile on;
figure;

stop_time = 60;
start_time = cputime();
tic;
% The loop starts from 0 till the stop_time
while (cputime() - start_time < stop_time)
    
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    
    % Read the data from Arduino (Measured force)
    time = [time; toc];
    adc_force = readTemp(Arduino, mode, number_output);
    tic;
    newton_force = adc_to_newtons(adc_force);
    
    % Proportional controller
    E = reference_force - newton_force;
    error = [error(2:end,:); E];
    if i == 1
        E_integral = Euler(0, E);
    else
        E_integral = Euler(error_value(i-1), E);
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
    end
    
    % Apply the control moving the hand
    mode_tensionDoigt (tension, current, doigt, s);
    pause(0.01);
    
    % Acquire the encoder position which is one of the system output
    % position(i) = lecture_position(s, doigt);
    
    % Save data
    force_value(i) = newton_force;
    error_value(i) = E;
    error_integral_value(i) = E_integral;
    
    % Plotting: error evolution over time
    plot(error);
    drawnow;
    
    % Update waitbar and message
    percentage = floor(((cputime() - start_time)/stop_time)*100);
    waitbar((cputime() - start_time)/stop_time,f,sprintf('%d',percentage))
    
    i = i+1;
end

profile report;
fclose(Arduino);
delete(f);
disp('Connection stopped');

%save('Fd4','error_value','mu','sigma')

end