% TASK: Dynamic model definition of the underactuated robotic finger with 3
%       joints developed by Alpes Instruments industry. 
% D(qt) ddqt + Ia ddqt + C(qt,dqt)dqt + Fv dqt + Fs + G(qt) = Gamma + J^T F

clc
clear all
close all

% Parameters definition
syms q1 q2 q3 dq1 dq2 dq3   % relative angular positions and velocities of the joints
syms ddq1 ddq2 ddq3         % angular accelerations of the joints
syms L1 L2 L3               % link's lengths
syms s1 s2 s3               % distance between centre of mass position and next joint
syms m1 m2 m3               % link's masses
syms I1 I2 I3               % link's inertial momentum
%syms r1 r2 r3              % pulley radii
syms K1 K2 K3               % link's spring constant
syms b1 b2 b3               % thickness of the spring
syms R1 R2 R3               % radii of the shaft of the pulleys
syms Ia1 Ia2 Ia3            % inertia of actuators
syms fv1 fv2 fv3            % friction coefficients
syms fs1 fs2 fs3            % friction coefficients
syms Fx Fy                  % contact forces
syms g                      % gravitational constant

% position, velocity and acceleration vectors
q = [q1 q2 q3].';
dq = [dq1 dq2 dq3].';
ddq = [ddq1 ddq2 ddq3].';

% cartesian position of the COM of each link in function of the joint
% coordinates
pc1 = [(L1-s1)*cos(q1),(L1-s1)*sin(q1)];
pc2 = [L1*cos(q1)+(L2-s2)*cos(q1+q2), L1*sin(q1)+(L2-s2)*sin(q1+q2)];
pc3 = [L1*cos(q1)+L2*cos(q1+q2)+(L3-s3)*cos(q1+q2+q3), L1*sin(q1)+L2*sin(q1+q2)+(L3-s3)*sin(q1+q2+q3)];

% Potential energy contribution given by the gravity and springs 
PE = g*m1*pc1(2) + g*m2*pc2(2) + g*m3*pc3(2) + 0.5*K1*(((pi/2)-q1)*(b1/2+R1))^2+...
        0.5*K2*((2*pi-q2)*(b2/2+R2))^2 + 0.5*K3*((2*pi-q3)*(b3/2+R3))^2;
PE = simplify(PE);

% Angular velocities of each link
va1 = dq1;
va2 = dq1+dq2;
va3 = dq1+dq2+dq3;
% Linear velocities of each link
vc1 = jacobian(pc1,q)*dq;
vc2 = jacobian(pc2,q)*dq;
vc3 = jacobian(pc3,q)*dq;

mv = max(size(vc1));
% Acceleration of each link
pc1dd = jacobian(vc1,q)*dq+jacobian(pc1,q)*ddq;
pc2dd = jacobian(vc2,q)*dq+jacobian(pc2,q)*ddq;
pc3dd = jacobian(vc3,q)*dq+jacobian(pc3,q)*ddq;

% Kinetic energy for each link
KE1 = simplify((1/2)*m1*vc1.'*vc1 + (1/2)*I1*va1.'*va1);
KE2 = simplify((1/2)*m2*vc2.'*vc2 + (1/2)*I2*va2.'*va2);
KE3 = simplify((1/2)*m3*vc3.'*vc3 + (1/2)*I3*va3.'*va3);

% Complete kinetic energy
KE = simplify(KE1+KE2+KE3);

% Lagrangian definition
L = KE - PE;

% Considering the inertia of actuators
Iact = [Ia1, 0, 0];
Ia = diag(Iact);

% Considering friction (Coulomb+viscous friction model)
fv = [fv1, fv2, fv3];
Fv = diag(fv);
Fs = [fs1*sign(dq1); fs2*sign(dq2); fs3*sign(dq3)];

% Jaconian matrix
J = [-L1*sin(q1)-L2*sin(q1+q2)-L3*sin(q1+q2+q3), -L2*sin(q1+q2)-L3*sin(q1+q2+q3), -L3*sin(q1+q2+q3);...
      L1*cos(q1)+L2*cos(q1+q2)+L3*cos(q1+q2+q3), L2*cos(q1+q2)+L3*cos(q1+q2+q3), L3*cos(q1+q2+q3);...
         0,                                         0,                              0               ];
F = [Fx, Fy, 0]';  % Contact force vector

% Time derivative of the Jacobian matrix
Jdot = [-L1*cos(q1)*dq1-L2*cos(q1+q2)*(dq1+dq2)-L3*cos(q1+q2+q3)*(dq1+dq2+dq3),...
                -L2*cos(q1+q2)*(dq1+dq2)-L3*cos(q1+q2+q3)*(dq1+dq2+dq3),...
                        -L3*cos(q1+q2+q3)*(dq1+dq2+dq3);...
      -L1*sin(q1)*dq1-L2*sin(q1+q2)*(dq1+dq2)-L3*sin(q1+q2+q3)*(dq1+dq2+dq3),...
                -L2*sin(q1+q2)*(dq1+dq2)-L3*sin(q1+q2+q3)*(dq1+dq2+dq3), ...
                        -L3*sin(q1+q2+q3)*(dq1+dq2+dq3);...
         0,             0,       0          ];

%save work_symb_model_robotic_hand

G = jacobian(PE, q).';
G = simplify(G);
D = simplify(jacobian(KE,dq).');
D = simplify(jacobian(D,dq));

% Matric C is computed using Christoffel symbols
syms C 
n = max(size(q));
for k = 1:n
   for j = 1:n
      C(k,j) = 0*g;
      for i = 1:n
         C(k,j)=C(k,j)+(1/2)*(diff(D(k,j),q(i))+diff(D(k,i),q(j))-diff(D(i,j),q(k)))*dq(i);
      end
   end
end
C = simplify(C);

save ('complete_dynamic_model_robotic_hand','D','C','G','J','Jdot','Ia','Fv','Fs')

%% Create a matlab function automatically
fcn_name = 'dynamic_model';
generate_model_fixlength