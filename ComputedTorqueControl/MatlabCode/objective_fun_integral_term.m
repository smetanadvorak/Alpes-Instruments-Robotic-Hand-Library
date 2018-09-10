% TASK: Objective function definition.
%       B = Dqdd + Cqd+G - J^T(:,2)K22F_d + J^T(:,2)K22Fy
%       A = [eye(3), J^T(:,1)K11]
%       X = [Gamma1, Gamma2, Gamma3, Fx_fric, Fy_frict]'
%       error is the sum of the squared components of B - AX

function error = objective_fun_integral_term(X, Fd, Fm, B, Jt, Kp, Ki, alpha)

      global error_integral_x error_integral_y
      integral_x = Euler(error_integral_x, (Fd(1)-Fm(1)-X(4)), 0.5);
      integral_y = Euler(error_integral_y, (Fd(2)-Fm(2)-X(5)), 0.5);

      error = (B(1) - X(1)+Jt(1,1)*Kp(1,1)*X(4)+Jt(1,2)*Kp(2,2)*X(5)-Jt(1,1)*Ki(1,1)*integral_x-Jt(1,2)*Ki(2,2)*integral_y)^2 +...
              (B(2) - X(2)+Jt(2,1)*Kp(1,1)*X(4)+Jt(2,2)*Kp(2,2)*X(5)-Jt(2,1)*Ki(1,1)*integral_x-Jt(2,2)*Ki(2,2)*integral_y)^2 +...
              (B(3) - X(3)+Jt(3,1)*Kp(1,1)*X(4)+Jt(3,2)*Kp(2,2)*X(5)-Jt(3,1)*Ki(1,1)*integral_x-Jt(3,2)*Ki(2,2)*integral_y)^2;
end
