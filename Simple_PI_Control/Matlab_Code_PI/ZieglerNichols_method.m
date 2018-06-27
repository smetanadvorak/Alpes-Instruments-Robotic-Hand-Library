%% Ziegler and Nichols method
%  Apply a step to the open loop system and record the response. Compute the
%  tangent to the responce, then the parameters m and Tr. Thanks to the
%  knowledge of these parameters it is possible to compute Kp and Ki.
function [Kp, Ki, m, Tr, x, y, x0] = ZieglerNichols_method(in)

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

% Useful parameters
number_output = 1;      % Only one finger is controlled 
sampling_rate = 25;
force_limit = 5;
i = 1;

doigt = 2;              % Integer number representing the INDEX
current = 750;          % Limit current
newton_force = 0;       % Initial applied force [N]


% Initialization of the variables
adc_data = zeros(buf_len, number_output);
newton_data = zeros(buf_len, number_output);
error = zeros(10*sampling_rate, 1);
force_value = [];
error_value = [];
error_integral_value = zeros(1, 1000);
time = [];

% Put the hand in the initial configuration
back_main(s);
pause(2);
% Put the hand in a position of contact
contact_position = 20000;
mouv_doigts(contact_position, doigt, s);
pause(3);

figure(1);

stop_time = 40;
start_time = cputime();
tic;
% The loop starts from 0 till the stop_time
while (cputime() - start_time < stop_time)
    
    % Read the data from Arduino (Measured force)
    time = [time; toc];
    adc_force = readTemp(Arduino, mode, number_output);
    tic;
    newton_force = adc_to_newtons(adc_force);
    
    if i < 100
        tens(i) = 0;
    elseif i > 100
        tens(i) = in;    %[Volt]
        
        % Transform the tension value from Volt to a scale readable by the hand
        % (Look the registers documentation given by Alpes Instruments)
        tension = ceil(tens(i)*10^2);
        % Apply the control moving the hand
        mode_tensionDoigt (tension, current, doigt, s);
        pause(0.01);
    end
    
    % Save data
    force_value(i) = newton_force;
    
    % Plotting: error evolution over time
    plot(force_value);
    drawnow;
    
    i = i+1;
end

fclose(Arduino);
fclose(s);
disp('Connection stopped');

%% Result analysis
figure(2);
sampling_time = sum(time)/length(time);
x = 1:sampling_time:length(force_value);
x = x(1:length(force_value));
plot(x, tens, 'r');
hold on;
plot(x, force_value);
title('Ziegler and Nichols method');
xlabel('Time [sec]');
legend('Applied tension','Measured force');
hold off;

% save('ZieglerNichols');

%% Compute tangent

%load('ZieglerNichols.mat');
figure(3)
y = force_value;
plot(x,y,'.');
hold on
plot(x,tens,'r');
indeces = find(ceil(y) == 0);
index = indeces(end);
y = y(index:end);
x = x(index:end);
n = 20;
[p, ~, mu] = polyfit(x,y,n);
xfit = linspace(min(x),max(x),100);
yfit = polyval(p,xfit,[],mu);
plot(xfit, yfit);

x0 = input('Enter x value where the tangent is computed:');
%x0 = 3.848;
f = @(x) polyval(p,x,[],mu);
df = derivest(f,x0);

% Calculate m and q parameters of the line equation y = mx+q
m = df;
q = f(x0) - m * x0;
xt = 1:0.1:length(x);
xt = xt(1:length(x));
yt = df*xt + q;
plot(xt(1:35), yt(1:35), 'k')
axis([0,10,-0.5,5.5]);
%grid on;
legend('Measured force','Input voltage','Measured force in polynomial form','Tangent');

% Abscissa value where y = 0 (Tr)
syms r
sol = solve(df*r + q == 0, r);
Tr = double(sol);

% Gains computation PI
Kp = 0.9*(m*Tr);
Ti = 3.3*Tr;

% Gains computation PID
% Kp = 1.2*(m*Tr);
% Ti = 2*Tr;
% Td = 0.5*Tr;
% Kd = Kp*Td;

Ki = Kp/Ti;

fprintf('The value of the gains is: Kp = %f, Ki = %f, Kd = %f \n', Kp, Ki, Kd);
end
