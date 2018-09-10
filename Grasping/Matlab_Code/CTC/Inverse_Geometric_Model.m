% TASK: Compute the Inverse Geometric Model knowing the first joint
%       coordinate.
% INPUT
%   fingertip_position: line vection containint the x and y coordinates of
%                       the fingertip
%   q1: value of the posirion if the first joint

function [q2, q3] = Inverse_Geometric_Model(fingertip_position, q1)

L1 = 0.05;   L2 = 0.03;   L3 = 0.024;
X = fingertip_position(1);
Y = fingertip_position(2);
x = fingertip_position(1) - L1*cos(q1);
y = fingertip_position(2) - L1*sin(q1);
y = abs(y);
x = abs(x);

q3 = real(acos((x^2 + y^2 - L2^2 - L3^2)/(2*L2*L3)));
q3 = 2*pi - abs(q3);

q2 = pi + abs(acos((X^2+Y^2-L1^2-x^2 -y^2)/(-2*L1*sqrt(x^2+y^2)))) + abs(atan((-L3*sin(q3))/(L2 + L3*cos(q3))));

%plot_3phalanx_finger([q1,q2,q3]);
%close all
end