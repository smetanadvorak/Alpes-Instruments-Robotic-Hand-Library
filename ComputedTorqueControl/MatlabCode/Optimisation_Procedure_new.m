function [Gamma,Fx_friction,Fy_friction,q,dq,dm,b, f_value] = Optimisation_Procedure_new(Kp,Ki, F_desired, F_measured, xhat)
    
    % load DM
    load complete_DM
    global Initial_cond             % Initial condition of the optimization problem
    global error_integral_y error_integral_x
    syms q1 q2 q3 dq1 dq2 dq3 real  % joint coordinates and their velocities

    q = [xhat(1),xhat(2),xhat(3)]';
    dq = [xhat(4),xhat(5),xhat(6)]';
    %ddq = [xhat(7),xhat(8),xhat(9)]';
    
    alpha = 2*pi - mod(xhat(1)+xhat(2)+xhat(3), 2*pi);
    F_desired = [-F_desired*sin(alpha), F_desired*cos(alpha), 0]';
    F =         [-F_measured*sin(alpha), F_measured*cos(alpha), 0]';
    
    % Substitute the joint coordinates values
    D = double(subs(D,{q1,q2,q3},{q(1),q(2),q(3)}));
    C = double(subs(C,{q1,q2,q3,dq1,dq2,dq3},{q(1),q(2),q(3),dq(1),dq(2),dq(3)}));
    G = double(subs(G,{q1,q2,q3},{q(1),q(2),q(3)})); 
    J = double(subs(J,{q1,q2,q3},{q(1),q(2),q(3)}));        
    
    % Optimization problem definition aX = b
    Jt = J';
    dm = D*ddq + C*dq + G;
    b = double(D*ddq + C*dq + G - Jt*Kp*F_desired + Jt*Kp*F);
    % a = [eye(3), -Jt(:,1)*K(1,1)];
    
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
        %fprintf('Exit flag: %d\n Error value: %e\n X vector: [%e, %e, %e, %e].\n',...
                    %    exit_flag, f_value, X(1), X(2), X(3), X(4),X(5));
        Gamma = [X(1), X(2), X(3)]';
        Fx_friction = X(4);
        Fy_friction = X(5);

    elseif exit_flag == 0
%         fprintf('Max number of iteration reached.\n Exit flag: %d\n.', exit_flag);
%         fprintf('Exit flag: %d\n Error value: %e\n X vector: [%e, %e, %e, %e].\n',...
%                     exit_flag, f_value, X(1), X(2), X(3), X(4),X(5));
        Gamma = [X(1), X(2), X(3)]';
        Fx_friction = X(4);
        Fy_friction = X(5);
    else
%         fprintf('Optimization is not valid (%d).\n', exit_flag);
%         fprintf('Exit flag: %d\n Error value: %e\n X vector: [%e, %e, %e, %e].\n',...
%                     exit_flag, f_value, X(1), X(2), X(3), X(4),X(5));
        Gamma = [X(1), X(2), X(3)]';
        Fx_friction = X(4);
        Fy_friction = X(5);
    end
end