clear all
close all
clc

in = linspace(1, 12, 7);
P = 0; I = 0; D = 0; M = []; R = []; X = []; Y = []; Cond = [];
for i = 2 : length(in)
    % [Kp, Ki, Kd, m, Tr, x, y, x0] = ZieglerNichols_method(in(i));
    [Kp, Ki, m, Tr, x, y, x0] = ZieglerNichols_method(in(i));
    P = [P, Kp];
    I = [I, Ki];
    % D = [D, Kd];
    M = [M, m];
    R = [R, Tr];
    X = [X, x];
    Y = [Y, y];
    Cond = [Cond, x0];
end

%save('ZieglerNichols_TEST_PID');

%% Analyze data

P = [0, P];
I = [0, I];
%D = [0, D];
in = [0, in];
figure
plot(in,P)
hold on
plot(in,I)
% hold on
% plot(in,D);
xlabel('Voltage [V]')
legend('K_p','K_i','K_d')
kp = sum(P(2:end))/length(P(2:end));
ki = sum(I(2:end))/length(I(2:end));
kd = sum(D(2:end))/length(D(2:end));