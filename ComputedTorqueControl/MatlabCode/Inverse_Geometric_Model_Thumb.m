% TASK: Compute the Inverse Geometric Model of the thumb knowing the 
%       position of the fingertip
% INPUT
%   fingertip_position: line vection containint the x and y coordinates of
%                       the fingertip
%   q1: value of the posirion if the first joint

function [q1, q2] = Inverse_Geometric_Model_Thumb(fingertip_position)

L1 = 0.05;   L2 = 0.03;
X = fingertip_position(1);
Y = fingertip_position(2);

q2 = pi + abs(acos((L1^2 + L2^2 - X^2 - Y^2)/(2*L1*L2)));
q1 = abs(atan(Y/X)) - abs(atan((-L2*sin(q2))/(L1 + L2*cos(q2))));

%plot_3phalanx_finger([q1,q2]);
end