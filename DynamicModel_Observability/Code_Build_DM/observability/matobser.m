clear all
%load work_symb_model_simple;
load work_symb_model_biped_abs_red % .mat
syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
syms d12 d22 numfuncphi denfuncphi funcphi deltastar real
syms coeff01 coeff11 coeff21 coeff31 coeff41 coeff51 real
syms coeff02 coeff12 coeff22 coeff32 coeff42 coeff52 real
syms coeff03 coeff13 coeff23 coeff33 coeff43 coeff53 real
syms coeff04 coeff14 coeff24 coeff34 coeff44 coeff54 real
syms Kv Kp real
Kp = 10;
Kv = 2*sqrt(Kp);
x1 = delta1;
x2 = delta2;
x3 = delta3;
x4 = delta4;
x5 = alpha;
x6 = deltap1;
x7 = deltap2;
x8 = deltap3;
x9 = deltap4;
x10 = alphap;

D = subs(D,s1,0.127) ; C = subs(C,s1,0.127) ; G = subs(G,s1,0.127) ; B = subs(B,s1,0.127) ;
D = subs(D,s2,0.163) ; C = subs(C,s2,0.163) ; G = subs(G,s2,0.163) ; B = subs(B,s2,0.163) ;
D = subs(D,s5,0.127) ; C = subs(C,s5,0.127) ; G = subs(G,s5,0.127) ; B = subs(B,s5,0.127) ;
D = subs(D,s4,0.163) ; C = subs(C,s4,0.163) ; G = subs(G,s4,0.163) ; B = subs(B,s4,0.163) ;
D = subs(D,s3,0.2) ; C = subs(C,s3,0.2) ; G = subs(G,s3,0.2) ; B = subs(B,s3,0.2) ;
%%
D = subs(D,m1,3.2) ; C = subs(C,m1,3.2) ; G = subs(G,m1,3.2) ; B = subs(B,m1,3.2) ;
D = subs(D,m2,6.8) ; C = subs(C,m2,6.8) ; G = subs(G,m2,6.8) ; B = subs(B,m2,6.8) ;
D = subs(D,m5,3.2) ; C = subs(C,m5,3.2) ; G = subs(G,m5,3.2) ; B = subs(B,m5,3.2) ;
D = subs(D,m4,6.8) ; C = subs(C,m4,6.8) ; G = subs(G,m4,6.8) ; B = subs(B,m4,6.8) ;
D = subs(D,m3,20) ; C = subs(C,m3,20) ; G = subs(G,m3,20) ; B = subs(B,m3,20) ;
%%
D = subs(D,l1,0.4) ; C = subs(C,l1,0.4) ; G = subs(G,l1,0.4) ; B = subs(B,l1,0.4) ;
D = subs(D,l2,0.4) ; C = subs(C,l2,0.4) ; G = subs(G,l2,0.4) ; B = subs(B,l2,0.4) ;
D = subs(D,l4,0.4) ; C = subs(C,l4,0.4) ; G = subs(G,l4,0.4) ; B = subs(B,l4,0.4) ;
D = subs(D,l5,0.4) ; C = subs(C,l5,0.4) ; G = subs(G,l5,0.4) ; B = subs(B,l5,0.4) ;

D = subs(D,Iy1,0.8784) ; C = subs(C,Iy1,0.8784) ; G = subs(G,Iy1,0.8784) ; B = subs(B,Iy1,0.8784) ;
D = subs(D,Iy2,0.8993) ; C = subs(C,Iy2,0.8993) ; G = subs(G,Iy2,0.8993) ; B = subs(B,Iy2,0.8993) ;
D = subs(D,Iy5,0.8784) ; C = subs(C,Iy5,0.8784) ; G = subs(G,Iy5,0.8784) ; B = subs(B,Iy5,0.8784) ;
D = subs(D,Iy4,0.8993) ; C = subs(C,Iy4,0.8993) ; G = subs(G,Iy4,0.8993) ; B = subs(B,Iy4,0.8993) ;
D = subs(D,Iy3,1.4180) ; C = subs(C,Iy3,1.4180) ; G = subs(G,Iy3,1.4180) ; B = subs(B,Iy3,1.4180) ;

d21 = D(5,1:4);
d22 = D(5,5);
H2 = C(5,:)*[x6;x7;x8;x9;x10];
G2 = G(5);
x  = [x1 ; x2 ; x3 ; x4 ; x5 ; x6; x7; x8; x9; x10];
%position trajectoire
delta1traj = coeff01 + coeff11*x5 + coeff21*x5^2 + coeff31*x5^3 ...
    + coeff41*x5^4 + coeff51*x5^5;
delta2traj = coeff02 + coeff12*x5 + coeff22*x5^2 + coeff32*x5^3 ...
    + coeff42*x5^4 + coeff52*x5^5;
delta3traj = coeff03 + coeff13*x5 + coeff23*x5^2 + coeff33*x5^3 ...
    + coeff43*x5^4 + coeff53*x5^5;
delta4traj = coeff04 + coeff14*x5 + coeff24*x5^2 + coeff34*x5^3 ...
    + coeff44*x5^4 + coeff54*x5^5;
deltatraj = [delta1traj delta2traj delta3traj delta4traj]';

%delta tilt trajectoire
delta1star = coeff11 + coeff21*x5 + 3*coeff31*x5^2 + 4*coeff41*x5^3 + 5*coeff51*x5^4;
delta2star = coeff12 + coeff22*x5 + 3*coeff32*x5^2 + 4*coeff42*x5^3 + 5*coeff52*x5^4;
delta3star = coeff13 + coeff23*x5 + 3*coeff33*x5^2 + 4*coeff43*x5^3 + 5*coeff53*x5^4;
delta4star = coeff14 + coeff24*x5 + 3*coeff34*x5^2 + 4*coeff44*x5^3 + 5*coeff54*x5^4;
deltastar = [delta1star delta2star delta3star delta4star]';
%delta tilt2 trajectoire
delta1starp = coeff21 + 6*coeff31*x5 + 12*coeff41*x5^2 + 20*coeff51*x5^3;
delta2starp = coeff22 + 6*coeff32*x5 + 12*coeff42*x5^2 + 20*coeff52*x5^3;
delta3starp = coeff23 + 6*coeff33*x5 + 12*coeff43*x5^2 + 20*coeff53*x5^3;
delta4starp = coeff24 + 6*coeff34*x5 + 12*coeff44*x5^2 + 20*coeff54*x5^3;
deltastarp = [delta1starp delta2starp delta3starp delta4starp]';

deltatraj = subs(deltatraj,{coeff01,coeff02,coeff03,coeff04},{-2.9143;-2.7469;-0.0672;-2.3839}) ;
deltatraj = subs(deltatraj,{coeff11,coeff12,coeff13,coeff14},{0.2507;1.7020;-4.2289;-2.0011}) ;
deltatraj = subs(deltatraj,{coeff21,coeff22,coeff23,coeff24},{0.6099;-5.6898;-2.3543;-24.3066}) ;
deltatraj = subs(deltatraj,{coeff31,coeff32,coeff33,coeff34},{-7.6023;-19.9282;43.8059;25.7670}) ;
deltatraj = subs(deltatraj,{coeff41,coeff42,coeff43,coeff44},{-35.1753;29.8406;115.9886;380.1120}) ;
deltatraj = subs(deltatraj,{coeff51,coeff52,coeff53,coeff54},{-40.8522;90.2710;84.8774;543.2280}) ;

deltastar = subs(deltastar,{coeff01,coeff02,coeff03,coeff04},{-2.9143;-2.7469;-0.0672;-2.3839}) ;
deltastar = subs(deltastar,{coeff11,coeff12,coeff13,coeff14},{0.2507;1.7020;-4.2289;-2.0011}) ;
deltastar = subs(deltastar,{coeff21,coeff22,coeff23,coeff24},{0.6099;-5.6898;-2.3543;-24.3066}) ;
deltastar = subs(deltastar,{coeff31,coeff32,coeff33,coeff34},{-7.6023;-19.9282;43.8059;25.7670}) ;
deltastar = subs(deltastar,{coeff41,coeff42,coeff43,coeff44},{-35.1753;29.8406;115.9886;380.1120}) ;
deltastar = subs(deltastar,{coeff51,coeff52,coeff53,coeff54},{-40.8522;90.2710;84.8774;543.2280}) ;

deltastarp = subs(deltastarp,{coeff01,coeff02,coeff03,coeff04},{-2.9143;-2.7469;-0.0672;-2.3839}) ;
deltastarp = subs(deltastarp,{coeff11,coeff12,coeff13,coeff14},{0.2507;1.7020;-4.2289;-2.0011}) ;
deltastarp = subs(deltastarp,{coeff21,coeff22,coeff23,coeff24},{0.6099;-5.6898;-2.3543;-24.3066}) ;
deltastarp = subs(deltastarp,{coeff31,coeff32,coeff33,coeff34},{-7.6023;-19.9282;43.8059;25.7670}) ;
deltastarp = subs(deltastarp,{coeff41,coeff42,coeff43,coeff44},{-35.1753;29.8406;115.9886;380.1120}) ;
deltastarp = subs(deltastarp,{coeff51,coeff52,coeff53,coeff54},{-40.8522;90.2710;84.8774;543.2280}) ;

% Sorties : sortie 1 = Ind. Obs. = 4 / sortie 2,3 et 4 = Ind. Obs. = 2

numfuncphi = -d21*(deltastarp*x10^2-Kv*eye(4,4)*([x6;x7;x8;x9]-deltastar*x10) ...
    -Kp*eye(4,4)*([x1;x2;x3;x4]-deltatraj))-H2-G2;
denfuncphi = d21*deltastar+d22;
funcphi = numfuncphi/denfuncphi;
h=eye(4,10)*x;
f = [x6 ; x6 ; x7 ; x9 ; deltastar*funcphi+deltastarp*x10^2-Kv*eye(4,4)*([x6;x7;x8;x9]-deltastar*x10)-Kp*eye(4,4)*([x1;x2;x3;x4]-deltatraj) ; x10 ; funcphi];
jac_dh = simplify(jacobian(h,x));
dh = jac_dh*f;
jac_ddh = simplify(jacobian(dh(1),x));
ddh  = jac_ddh*f;
dddh = jacobian(ddh,x)*f;
Obs = jacobian([h ; dh ; ddh ; dddh],x);


fcn_name = 'Obser_biped_abs_red_ar';
generate_obser_fixlength
%rank(Obs)
