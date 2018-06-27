% TASK: compute the generic observability of a non linear system, in particular of
%       a 2 joints robotic finger.
% x1d = x2
% X2d = D^-1[-C*qd-G]
% y = h(x) = x1 = q1

clc
clear all
close all

% Variables and coefficients definition
% load work_symb_model_2_phalanges   % .mat
load DM
syms x1 x2 x3 x4 real
syms q1 q2 dq1 dq2 real
syms L1 L2 L3 real              % link's lengths
syms s1 s2 s3 real              % distance between centre of mass position and next joint
syms m1 m2 m3 real              % link's masses
syms I1 I2 I3 real              % link's inertial momentum
syms K1 K2 K3 real              % link's spring constant
syms b1 b2 b3 real              % thickness of the spring
syms R1 R2 R3 real              % pulley radii
syms Fz real                    % measured contact force
syms g real                     % gravitational constant

syms Gamma1 real

% Control variables
x1 = q1;
x2 = q2;
x3 = dq1;
x4 = dq2;
% Control vector
x = [x1 ; x2 ; x3 ; x4];
% Motor torque, only the first joint is actuated
Gamma = [Gamma1 ;0];
n = max(size(x));   % Dimension of the state space

% Substitute the parameter values
D = subs(D,{s1,s2,m1,m2,L1,L2,I1,I2},{0.025,0.015,0.03,...
            0.02,0.05,0.03,2.5000e-05,6.0000e-06});
C = subs(C,{s1,s2,m1,m2,L1,L2,I1,I2},{0.025,0.015,0.03,...
            0.02,0.05,0.03,2.5000e-05,6.0000e-06});
G = subs(G,{s1,s2,m1,m2,L1,L2,I1,I2},{0.025,0.015,0.03,...
            0.02,0.05,0.03,2.5000e-05,6.0000e-06}); 
% J = subs(J,{L1,L2,L3},{0.05,0.03,0.024});   
G = subs(G,{K1,K2,b1,b2,R1,R2,g},{930,1013,0.0038,...
            0.0038,0.004,0.004,9.81});

%% Observability matrix computation

qdd = simplify(D\(- C*[dq1;dq2] - G)); % simplify(D\(Gamma + J'*F - C*dq - G))
xd = [x3, x4, qdd(1), qdd(2)]';

h = [1, 1, 0, 0]*x;     % y = h = q1 + q2 = x1+x2;
dh = simplify(jacobian(h,x)*xd);
ddh  = simplify(jacobian(dh,x)*xd);
dddh = simplify(jacobian(ddh,x)*xd);

% Observability Matrix
Obs = (jacobian([h ; dh ; ddh ; dddh],x));

data = computingDeterminant2Links(Obs);
save('data');

%% Evaluate critical configurations (test_2phalanges.mat)

%load('critical_data.mat')
index = find(abs(data(:,5)) < 1);

results = table(data(index, 1), data(index, 2), data(index, 3), data(index, 4), data(index, 5));
results.Properties.VariableNames = {'q1', 'q2', 'dq1', 'dq2', 'Determinant'}

% critical_data = data(index, :);
% temp = [];
% for j = 1 : size(critical_data, 1)
%     if critical_data(j, 1) == 0 && critical_data(j, 2) == 2*pi && (critical_data(j,3) ~= 0 || critical_data(j, 4) ~= 0)
%         temp = [temp; j];
%     elseif critical_data(j, 1) == pi/2 && critical_data(j, 2) == (3/2)*pi && (critical_data(j, 3) ~= 0 || critical_data(j, 4) ~= 0)
%         temp = [temp; j];
%     end
% end
% critical_data(temp, :) = [];


critical_data = [];
for j = 1:size(critical_data, 1)
    plot_2phalanx_finger(critical_data(j, :));
end

%% Save the matrix in a Matlab function

% fcn_name = 'Observability_Matrix';
% generate_obser_fixlength
