function Gamma = Optimisation_Procedure_Index(Kp,Ki, F_desired, F_measured, xhat)

load complete_DM
global Initial_cond             % Initial condition of the optimization problem
global error_integral_y error_integral_x
global error_integral_previous
syms q1 q2 q3 real  % joint coordinates and their velocities

q = [xhat(1),xhat(2),xhat(3)]';

alpha = 2*pi - mod(xhat(1)+xhat(2)+xhat(3), 2*pi);
F_desired = [-F_desired*sin(alpha), F_desired*cos(alpha), 0]';
F =         [-F_measured*sin(alpha), F_measured*cos(alpha), 0]';

% Substitute the joint coordinates values
[G, J] = Compute_G_J(q);

% error definition
error = (F_desired - F);
error_integral = Euler(error_integral_previous, error, 0.07);
error_integral_previous = error_integral;

% Optimization problem definition aX = b
Jt = J';
b = double(G - Jt*Kp*F_desired + Jt*Kp*F);

% Optimization solver (0.61 sec)
mu = 1e-4;
gamma = 1e-6;
beta = 1e-6;
Aineq = [0,1,0,0,0; 0,-1,0,0,0; 0,0,1,0,0; 0,0,-1,0,0; 0,0,0,-1,0; 0,0,0,1,0; 0,0,0,0,1; 0,0,0,0,-1];
Bineq = [beta, beta, gamma,gamma, mu, mu, mu, mu];

options = optimset('Display','off');

[X, f_value, exit_flag] = fmincon(@(X)objective_fun_integral_term(X,F_desired,F,b,Jt,Kp,Ki,alpha),...
    Initial_cond,Aineq,Bineq,[],[],[],[],[],options);
Initial_cond = X;
error_integral_x = Euler(error_integral_x, (F_desired(1)-F(1)-X(4)), 0.5);
error_integral_y = Euler(error_integral_y, (F_desired(2)-F(2)-X(5)), 0.5);

if exit_flag > 0
    Gamma = [X(1), X(2), X(3)]';
elseif exit_flag == 0
    Gamma = [X(1), X(2), X(3)]';
else
    Gamma = [X(1), X(2), X(3)]';
end
end