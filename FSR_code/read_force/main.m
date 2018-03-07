%% Initialization
clc
clear all
close all

mode = 'R';
buf_len = 1500;
comPort = '/dev/tty.usbmodem1421';
[Arduino,serialFlag] = setupSerial(comPort);
cleanup_arduino = onCleanup(@()fclose(Arduino));

%% Acquire data
% Useful parameters
number_output = 1;
sampling_rate = 25;
force_limit = 5;

% Initialization of the variables
adc_data = zeros(buf_len, number_output);
newton_data = zeros(buf_len, number_output);
hf_force = figure(1);

% Save the data
force_animation_buffer = zeros(10*sampling_rate, 1);
force_hist = [];
%force_graph_separator = zeros (length(force_animation_buffer),1);

% Visualize the upper limit of the measurable force
force_limit_graph = repmat(force_limit, length(force_animation_buffer),1);
% Visualize if the limit is overcomed
force_exceed_indicator_loc = repmat([1, force_limit], number_output, 1);

stop_time = 20;
start_time = cputime();
time_arduino = [];
time_hand = [];
time_graph = [];

% The loop starts from 0 till the stop_time
while (cputime() - start_time < stop_time)
    % Read the data from Arduino
    adc_force = readTemp(Arduino, mode, number_output);
    newton_force = adc_to_newtons(adc_force);
    force_animation_buffer = [force_animation_buffer(2:end,:); newton_force'];
    force_hist = [force_hist; adc_force];
    plot(force_animation_buffer);
    drawnow;
    sprintf('Time: %f', cputime() - start_time)  
    pause(0.1);
end

fclose(Arduino);
disp('Connection stopped');
