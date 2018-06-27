% Compute the mean value of the error and the standard deviation for 
% increasing values of the constant desired force.
clc
clear all
close all

F = []; M = []; S = [];
reference_force = linspace(0.1, 5, 8);
error = zeros(length(reference_force),2000);
force = zeros(length(reference_force),2000);
doigt = 2;
current = 750;
contact_position = 24000;
Kp = 10.5741;
Ki = 0.9851;

for i = 1:length(reference_force)
    fprintf('Reference force: %d', reference_force(i));
    [error_value, force_value] = PI_controller (doigt, reference_force(i), current, contact_position, Kp, Ki);
    [mu, sigma] = normfit(error_value(round(end/2):end));
    F = [F; reference_force(i)];
    M = [M; mu];
    S = [S; sigma];
    error(i,1:length(error_value)) = error_value;
    force(i,1:length(error_value)) = force_value;

    pause(2);
end

figure(1)
plot(F,M);
xlabel('Desired force [N]');
ylabel('Mean value of the error [N]');

figure(2)
plot(F,S);
xlabel('Desired force [N]');
ylabel('Standard deviation of the error [N]');

results = table(F,M,S);
results.Properties.VariableNames = {'F', 'M', 'S'}

%save('ZieglerNichols_TEST_2-3');
