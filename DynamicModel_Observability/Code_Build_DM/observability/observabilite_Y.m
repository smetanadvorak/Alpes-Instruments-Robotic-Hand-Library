%
% Ce fichier permet d'évaluer l'observabilité d'un robot bipède sans genoux et avec tronc
% en supposant qu'on ne mesure que les angles (et les vitesses) des angles absolus des jambes
%
%Author Yannick Aoustin, 22 March 2018
clear all
%load work_symb_model_simple;
%load work_symb_model_biped_abs_red
load work_symb_model_2_phalanges
%
% Le système est sous la forme D(q)ddq + C(q,dq)*dq + G(q) = torques = B*tau
%
syms x1 x2 x3 x4 u1 du1 
syms y1 dy1 ddy1 dddy1
syms f1
%
% Mise du système sous forme d'état
%
%Dear Veronica, here you have to calculate D, C, G as function of the generalized variables 
D = subs(D,[q1 q2 dq1 dq2],[x1 x2 x3 x4]);
C = subs(C,[q1 q2 dq1 dq2],[x1 x2 x3 x4]);
G = subs(G,[q1 q2 dq1 dq2],[x1 x2 x3 x4]);

%D = subs(D,s1,-0.0402) ; C = subs(C,s1,-0.0402) ; G = subs(G,s1,-0.0402) ; 
%D = subs(D,s2, 0.2795) ; C = subs(C,s2, 0.2795) ; G = subs(G,s2, 0.2795) ;  
 
%%
%D = subs(D,m1,30) ; C = subs(C,m1,30) ; G = subs(G,m1,30) ;  
%D = subs(D,m2,10) ; C = subs(C,m2,10) ; G = subs(G,m2,10) ;  

%%
%D = subs(D,L1,0.8000) ; C = subs(C,L1,0.8000) ; G = subs(G,L1,0.8000) ; B = subs(B,L1,0.8000) ; 
%D = subs(D,L2,0.8000) ; C = subs(C,L2,0.8000) ; G = subs(G,L2,0.8000) ; B = subs(B,L2,0.8000) ; 
 

%%


%D = subs(D,[th1 th2 th3 dth1 dth2 dth3],[x1 x2 x3 x4 x5 x6]);
%C = subs(C,[th1 th2 th3 dth1 dth2 dth3],[x1 x2 x3 x4 x5 x6]);
%G = subs(G,[th1 th2 th3 dth1 dth2 dth3],[x1 x2 x3 x4 x5 x6]);
%B = subs(B,[th1 th2 th3 dth1 dth2 dth3],[x1 x2 x3 x4 x5 x6]);
%
x  = [x1 ; x2 ; x3 ; x4];

%
D_1 = (simplify(inv(D)));
f = ([x3 ; x4 ; (simplify(D_1*(-C*[x3 ; x4]-G)))]);
h = [1 1 0 0]*x;                   % Sorties : q1+q2
jac_dh = (jacobian(h,x));
dh     = (simplify(jac_dh*f));                  % Dérivées des sorties
jac_ddh = (simplify(jacobian(dh(1),x)));
%jac_ddh = simplify(jacobian(dh(1),x));
%jac_ddh = jac_ddh);
ddh    = (jac_ddh*f);                 % Dérivée 2nde de la sortie 1
dddh = jacobian(ddh,x)*f;
%dddh   = simple(simplify((jacobian(ddh,x)*f)));
dddh   = dddh ;            % Dérivée 3ème de la sortie 1
%
Obs = (jacobian([h ; dh ; ddh ; dddh],x));

[n,m] = size(Obs);
%Rang1 = rank(Obs);

display('TEST 1');

%pause;
%
%
%------------------------------------------
%
% File to automatically build up the .m-files needed for our simualtor
%
%------------------------------------------
%
% File to automatically build up the .m-files needed for our simualtor
%
%------------------------------------------
%
fid = fopen('matrice_obsnum.m','w+');
header=['function [out]=matrice_obsnum(in)'];
fprintf(fid,'%s',header);
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
Temp=['%% File Generated on ',date];
fprintf(fid,'\n%s',Temp);
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%% Authors: Franck Yannick');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
%fprintf(fid,'\n%s','[r,l,m,g,M_T,M_H]=mdlParameters;');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','global I1 I2 m1 m2 R1 R2 b1 b2 K1 K2');
fprintf(fid,'\n%s','global L1 L2 s1 s2');
fprintf(fid,'\n%s','global g');
fprintf(fid,'\n%s','x1 = in(1) ; x2 = in(2) ; x3 = in(3) ; x4 = in(4);');
fprintf(fid,'\n%s','u1 = in(5) ;');
fprintf(fid,'\n%s','du1= in(6);');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');

[n,m]=size(Obs);
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['Obs=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=Obs(i,j);
        if Temp0 ~= 0
            Temp1=char(Temp0);
            Temp2=['Obs(',num2str(i),',',num2str(j),') = ',Temp1,';'];
            %fprintf(fid,'\n%s',Temp2);
            Temp3=fixlength(Temp2,'*+-',100,'         ');
            %Temp3=fixlength(Temp2,'*+-()',100,'         ');
           fprintf(fid,'\n%s',Temp3);
        end
    end
end

fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
Temp1 = ['Obs = [Obs(1,1) Obs(1,2) Obs(1,3) Obs(1,4) ; ... '];
fprintf(fid,'\n%s',Temp1);
Temp1 = ['Obs(2,1) Obs(2,2) Obs(2,3) Obs(2,4) ; ... '];
fprintf(fid,'\n%s',Temp1);
Temp1 = ['Obs(3,1) Obs(3,2) Obs(3,3) Obs(3,4) ; ... '];
fprintf(fid,'\n%s',Temp1);
Temp1 = ['Obs(4,1) Obs(4,2) Obs(4,3) Obs(4,4) ]; ... '];
fprintf(fid,'\n%s',Temp1);
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
Temp1 = ['out = inv(Obs);'];
fprintf(fid,'\n%s',Temp1);
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
status = fclose(fid);
%
%equation=subs(f1-(-4/r^2/(-4*M_H-5*m-4*M_T+4*m*cos(x1-x2)^2+4*M_T*cos(x1-x3)^2)*((-1/4*m*r^2*sin(x1-x2)*x5+1/2*M_T*r*l*sin(x1-x3)*x6)*x4+(1/2*m*r^2*sin(x1-x2)*x5+1/4*m*r^2*sin(x1-x2)*x4)*x5+(-M_T*r*l*sin(x1-x3)*x6-1/2*M_T*r*l*sin(x1-x3)*x4)*x6-u1)-8/r^2*cos(x1-x2)/(-4*M_H-5*m-4*M_T+4*m*cos(x1-x2)^2+4*M_T*cos(x1-x3)^2)*((-1/2*m*r^2*sin(x1-x2)*x4-1/4*m*r^2*sin(x1-x2)*x5)*x4+1/4*m*r^2*sin(x1-x2)*x4*x5-u2)+4/r/l*cos(x1-x3)/(-4*M_H-5*m-4*M_T+4*m*cos(x1-x2)^2+4*M_T*cos(x1-x3)^2)*((M_T*r*l*sin(x1-x3)*x4+1/2*M_T*r*l*sin(x1-x3)*x6)*x4-1/2*M_T*r*l*sin(x1-x3)*x4*x6+u1+u2)),x6,0)
%[x3] = solve('f1+4/r^2/(-4*M_H-30-4*M_T+24*cos(x1-x2)^2+4*M_T*cos(x1-x3)^2)*(-3/2*r^2*sin(x1-x2)*x4*x5+(3*r^2*sin(x1-x2)*x5+3/2*r^2*sin(x1-x2)*x4)*x5-u1)+8/r^2*cos(x1-x2)/(-4*M_H-30-4*M_T+24*cos(x1-x2)^2+4*M_T*cos(x1-x3)^2)*((-3*r^2*sin(x1-x2)*x4-3/2*r^2*sin(x1-x2)*x5)*x4+3/2*r^2*sin(x1-x2)*x4*x5-u2)-4/r/l*cos(x1-x3)/(-4*M_H-30-4*M_T+24*cos(x1-x2)^2+4*M_T*cos(x1-x3)^2)*(M_T*r*l*sin(x1-x3)*x4^2+u1+u2)=0')
%
%
%------------------------------------------
%
% File to automatically build up the .m-files needed for our simualtor
%
%------------------------------------------
%







return

