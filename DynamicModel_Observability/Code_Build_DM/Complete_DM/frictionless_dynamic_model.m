function [D, C, G, B, Fv, Fs, J]= frictionless_dynamic_model(q, dq, ddq, Fz)
%FRICTIONLESS_DYNAMIC_MODEL

%15-May-2018 16:26:03


%%
%% Authors: Alexander Yannick  and Franck
%%
%%
%% Model NOTATION: Spong and Vidyasagar, page 142, Eq. (6.3.12)
%% D(qt) ddqt + Ia ddqt + C(qt,dqt)dqt + Fv dqt + Fs + G(qt) = tau + J^T F
%%
%%
[g,L1,L2,L3,m1,m2,m3,I1,I2,I3,s1,s2,s3,R1,R2,R3,fv1,fv2,fv3,fs1,fs2,fs3,Ia1,Ia2,Ia3]=modelParameters;
%%
%%
%%
%%
q1=q(1);q2=q(2);q3=q(3);
dq1=dq(1);dq2=dq(2);dq3=dq(3);
ddq1=ddq(1);ddq2=ddq(2);ddq3=ddq(3);
%%
D=zeros(3,3);
D(1,1)=I1 + I2 + I3 + L1^2*m1 + L1^2*m2 + L1^2*m3 + L2^2*m2 + ...
          L2^2*m3 + m1*s1^2 + m2*s2^2 + m3*s3^2 - 2*L1*m1*s1 - 2*L2*m2* ...
         s2 + 2*L1*m3*s3*cos(q2 + q3) + 2*L1*L2*m2*cos(q2) + 2*L1*L2*m3* ...
         cos(q2) - 2*L1*m2*s2*cos(q2) + 2*L2*m3*s3*cos(q3);
D(1,2)=I2 + I3 + L2^2*m2 + L2^2*m3 + m2*s2^2 + m3*s3^2 - 2*L2*m2* ...
         s2 + L1*m3*s3*cos(q2 + q3) + L1*L2*m2*cos(q2) + L1*L2*m3* ...
         cos(q2) - L1*m2*s2*cos(q2) + 2*L2*m3*s3*cos(q3);
D(1,3)=I3 + m3*s3^2 + L1*m3*s3*cos(q2 + q3) + L2*m3*s3*cos(q3);
D(2,1)=I2 + I3 + L2^2*m2 + L2^2*m3 + m2*s2^2 + m3*s3^2 - 2*L2*m2* ...
         s2 + L1*m3*s3*cos(q2 + q3) + L1*L2*m2*cos(q2) + L1*L2*m3* ...
         cos(q2) - L1*m2*s2*cos(q2) + 2*L2*m3*s3*cos(q3);
D(2,2)=I2 + I3 + L2^2*m2 + L2^2*m3 + m2*s2^2 + m3*s3^2 - 2*L2*m2* ...
         s2 + 2*L2*m3*s3*cos(q3);
D(2,3)=I3 + m3*s3^2 + L2*m3*s3*cos(q3);
D(3,1)=I3 + m3*s3^2 + L1*m3*s3*cos(q2 + q3) + L2*m3*s3*cos(q3);
D(3,2)=I3 + m3*s3^2 + L2*m3*s3*cos(q3);
D(3,3)=I3 + m3*s3^2;
%%
C=zeros(3,3);
C(1,1)=- L1*dq2*(m3*s3*sin(q2 + q3) - m2*s2*sin(q2) + L2*m2* ...
         sin(q2) + L2*m3*sin(q2)) - dq3*m3*s3*(L1*sin(q2 + q3) + L2* ...
         sin(q3));
C(1,2)=- L1*dq1*(m3*s3*sin(q2 + q3) - m2*s2*sin(q2) + L2*m2* ...
         sin(q2) + L2*m3*sin(q2)) - L1*dq2*(m3*s3*sin(q2 + q3) - m2*s2* ...
         sin(q2) + L2*m2*sin(q2) + L2*m3*sin(q2)) - dq3*m3*s3*(L1*sin(q2 + ...
          q3) + L2*sin(q3));
C(1,3)=-m3*s3*(L1*sin(q2 + q3) + L2*sin(q3))*(dq1 + dq2 + dq3);
C(2,1)=dq1*(L1*m3*s3*sin(q2 + q3) + L1*L2*m2*sin(q2) + L1*L2*m3* ...
         sin(q2) - L1*m2*s2*sin(q2)) - L2*dq3*m3*s3*sin(q3);
C(2,2)=-L2*dq3*m3*s3*sin(q3);
C(2,3)=-L2*m3*s3*sin(q3)*(dq1 + dq2 + dq3);
C(3,1)=dq1*(L1*m3*s3*sin(q2 + q3) + L2*m3*s3*sin(q3)) + L2*dq2* ...
         m3*s3*sin(q3);
C(3,2)=L2*m3*s3*sin(q3)*(dq1 + dq2);
%%
G=zeros(3,1);
G(1)=g*m3*(L2*cos(q1 + q2) + L1*cos(q1) + s3*cos(q1 + q2 + q3)) + ...
          g*m2*(L1*cos(q1) + cos(q1 + q2)*(L2 - s2)) + K1*q1*(R1 + ...
          b1/2)^2 + g*m1*cos(q1)*(L1 - s1);
G(2)=g*m3*(L2*cos(q1 + q2) + s3*cos(q1 + q2 + q3)) + K2*q2*(R2 + ...
          b2/2)^2 + g*m2*cos(q1 + q2)*(L2 - s2);
G(3)=K3*q3*(R3 + b3/2)^2 + g*m3*s3*cos(q1 + q2 + q3);
%%
Fv=zeros(3,3);