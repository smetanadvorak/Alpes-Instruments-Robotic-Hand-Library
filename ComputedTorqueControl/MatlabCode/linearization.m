% TASK: Linearize the robotic hand's nonlinear system in the form 
%       xdot = f(x,u), such that it becomes in the form xdot = Ax + Bu.
% INPUT
%   f: non linear function
%   x: state vector
%   u: input vector

function [A, B] = linearization(f, x, u)

    A = jacobian(f,x);
    B = jacobian(f,u);
end