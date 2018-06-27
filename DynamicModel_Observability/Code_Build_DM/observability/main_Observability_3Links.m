% TASK: compute the generic observability of a non linear system, in particular of
%       a three-phalanx robotic finger.
% x1d = x2
% X2d = D^-1[-C*qd -G]
% y = h(x) = x1 + x2 + x3 = q1 + q2 + q3

clc
clear all
close all

% Variables and coefficients definition
load work_symb_model_3_phalanges
%load work_symb_model_3_phalanges_absolute   % .mat
syms x1 x2 x3 x4 x5 x6 real
syms q1 q2 q3 dq1 dq2 dq3 real
syms L1 L2 L3 real              % link's lengths
syms s1 s2 s3 real              % distance between centre of mass position and next joint
syms m1 m2 m3 real              % link's masses
syms I1 I2 I3 real              % link's inertial momentum
syms K1 K2 K3 real              % link's spring constant
syms b1 b2 b3 real              % thickness of the spring
syms R1 R2 R3 real              % pulley radii
syms Fz Gamma1 real             % measured contact force and iniput torque
syms g real                     % gravitational constant


% Control variables
x1 = q1;
x2 = q2;
x3 = q3;
x4 = dq1;
x5 = dq2;
x6 = dq3;

% Control vector
x = [x1 ; x2 ; x3 ; x4 ; x5 ; x6];
% Motor torque, only the first joint is actuated
Gamma = [Gamma1 ;0 ;0];
n = max(size(x));   % Dimension of the state space

% Substitute the parameter values
D = subs(D,{s1,s2,s3,m1,m2,m3,L1,L2,L3,I1,I2,I3},{0.025,0.015,0.012,0.03,...
            0.02,0.023,0.05,0.03,0.024,2.5000e-05,6.0000e-06,4.4160e-06});
C = subs(C,{s1,s2,s3,m1,m2,m3,L1,L2,L3,I1,I2,I3},{0.025,0.015,0.012,0.03,...
            0.02,0.023,0.05,0.03,0.024,2.5000e-05,6.0000e-06,4.4160e-06});
G = subs(G,{s1,s2,s3,m1,m2,m3,L1,L2,L3,I1,I2,I3},{0.025,0.015,0.012,0.03,...
            0.02,0.023,0.05,0.03,0.024,2.5000e-05,6.0000e-06,4.4160e-06}); 
% J = subs(J,{L1,L2,L3},{0.05,0.03,0.024});        
G = subs(G,{K1,K2,K3,b1,b2,b3,R1,R2,R3,g},{0.04,0.05,0.06,0.003,...
            0.003,0.003,0.004,0.004,0.004,9.81});

%% Observability matrix computation

qdd = simplify(D\(- C*dq - G));
xd = [x4, x5, x6, qdd(1), qdd(2), qdd(3)]';

h = [1, 1, 1, 0, 0, 0]*x;     % y = h = q1+q2+q3 = x1+x2+x3;
dh = simplify(jacobian(h,x)*xd);
ddh  = simplify(jacobian(dh,x)*xd);
dddh = jacobian(ddh,x)*xd;
ddddh = jacobian(dddh,x)*xd;
dddddh = jacobian(ddddh,x)*xd;

% Observability Matrix
Obs = jacobian([h ; dh ; ddh ; dddh; ddddh; dddddh],x);

data = computingDeterminant(Obs);
save test_3phalanges

%% Evaluate data (test_3phalanges.mat)

index = find(abs(data(:,7)) < 0.01);
results = table(data(index, 1), data(index, 2), data(index, 3), data(index, 4), data(index, 5));
results.Properties.VariableNames = {'q1', 'q2', 'dq1', 'dq2', 'Determinant'}

%% Save the matrix in a Matlab function

% fcn_name = 'Observability_Matrix';
% generate_obser_fixlength
