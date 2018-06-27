
%% Matrices derivatives

Dd = [-2*L1*L2*m2*sin(q2)*dq2 + 2*L1*m2*s2*sin(q2)*dq2 , -L1*m2*sin(q2)*dq2*L2 + L1*m2*sin(q2)*dq2*s2;...
      -L1*m2*sin(q2)*dq2*L2 + L1*m2*sin(q2)*dq2*s2, 0];
Cd = [-L1*ddq2*m2*sin(q2)*(L2 - s2)-L1*dq2^2*m2*cos(q2)*(L2 - s2), ...
          -L1*m2*sin(q2)*(ddq1 + ddq2)*(L2 - s2)-L1*m2*cos(q2)*dq2*(dq1 + dq2)*(L2 - s2);...
      L1*ddq1*m2*sin(q2)*(L2 - s2)+L1*dq1*m2*cos(q2)*dq2*(L2 - s2), 0];
Gd = [-g*m2*L1*sin(q1)*dq1-g*m2*sin(q1+q2)*(dq1+dq2)*(L2-s2)+K1*dq1*(R1 + b1/2)^2 ...
            - g*m1*sin(q1)*dq1*(L1 - s1);...
      K2*dq2*(R2 + b2/2)^2 - g*m2*sin(q1 + q2)*(dq1 + dq2)*(L2 - s2)];

%% Substitute parameters

Dd = subs(Dd,s1,0.025) ; Cd = subs(Cd,s1,0.025) ; Gd = subs(Gd,s1,0.025) ; %B = subs(B,s1,0.025) ; 
Dd = subs(Dd,s2,0.015) ; Cd = subs(Cd,s2,0.015) ; Gd = subs(Gd,s2,0.015) ; %B = subs(B,s2,0.015) ;

Dd = subs(Dd,m1,0.03) ; Cd = subs(Cd,m1,0.03) ; Gd = subs(Gd,m1,0.03) ; %B = subs(B,m1,0.03) ; 
Dd = subs(Dd,m2,0.02) ; Cd = subs(Cd,m2,0.02) ; Gd = subs(Gd,m2,0.02) ; %B = subs(B,m2,0.02) ; 

Dd = subs(Dd,L1,0.05) ; Cd = subs(Cd,L1,0.05) ; Gd = subs(Gd,L1,0.05) ; %B = subs(B,L1,0.05) ; 
Dd = subs(Dd,L2,0.03) ; Cd = subs(Cd,L2,0.03) ; Gd = subs(Gd,L2,0.03) ; %B = subs(B,L2,0.03) ; 

Dd = subs(Dd,I1,2.5000e-05) ; Cd = subs(Cd,I1,2.5000e-05) ; Gd = subs(Gd,I1,2.5000e-05) ; %B = subs(B,I1,2.5000e-05) ; 
Dd = subs(Dd,I2,6.0000e-06) ; Cd = subs(Cd,I2,6.0000e-06) ; Gd = subs(Gd,I2,6.0000e-06) ; %B = subs(B,I2,6.0000e-06) ;

Gd = subs(Gd,K1,0.04);
Gd = subs(Gd,K2,0.05);

Gd = subs(Gd,b1,0.003);
Gd = subs(Gd,b2,0.003);

%% Observability matrix computation

qdd = D\(- C*dq - G); %D\(Gamma + J'*F - C*dq - G); % inverse dynamic model
qddd = D\(-Dd*qdd-Cd*dq-C*qdd-Gd);

xd = [x3, x4, qdd(1), qdd(2)]';
xdd =[qdd(1), qdd(2), qddd(1), qddd(2)]';

h = [1, 1, 0, 0]*x;     % y = h = q1 + q2 = x1+x2;
dh = simplify(jacobian(h,x))*xd;
ddh  = simplify(jacobian(dh,x))*xd;
dddh = jacobian(ddh,x)*xd + jacobian(ddh,xd)*xdd;

% Observability Matrix
Obs = (jacobian([h ; dh ; ddh ; dddh],x));

r = rank(Obs);
if r == n
    disp('The system is Observable');
else
    disp('The system is not Observable');
end