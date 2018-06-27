%
% File to automatically build up the .m-files needed for our simualtor
%

%load Mat/work_symb_model_abs;
%fcn_name = 'dyn_mod_abs';

disp(['[creating ',upper(fcn_name),'.m]']);
fid = fopen([fcn_name,'.m'],'w');
n=max(size(q));
fprintf(fid,['function [D, C, G, B, Fv, Fs, J]=' ...
        ' %s(q, dq, ddq, Fz)\n'],fcn_name);
fprintf(fid,'%%%s\n\n',upper(fcn_name));
fprintf(fid,'%%%s\n\n',datestr(now));
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%% Authors: Alexander Yannick  and Franck');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%% Model NOTATION: Spong and Vidyasagar, page 142, Eq. (6.3.12)');
fprintf(fid,'\n%s','%% D(qt) ddqt + Ia ddqt + C(qt,dqt)dqt + Fv dqt + Fs + G(qt) = tau + J^T F');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','[g,L1,L2,L3,m1,m2,m3,I1,I2,I3,s1,s2,s3,R1,R2,R3,fv1,fv2,fv3,fs1,fs2,fs3,Ia1,Ia2,Ia3]=modelParameters;');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
if n==3
    fprintf(fid,'\n%s','q1=q(1);q2=q(2);q3=q(3);');
    fprintf(fid,'\n%s','dq1=dq(1);dq2=dq(2);dq3=dq(3);');
    fprintf(fid,'\n%s','ddq1=ddq(1);ddq2=ddq(2);ddq3=ddq(3);');

else
%     fprintf(fid,'\n%s','q31=q(1);q32=q(2);q41=q(3);q42=q(4);y=q(5);z=q(6);q1=q(7);');
    %fprintf(fid,'\n%s','dq31=dq(1);dq32=dq(2);dq41=dq(3);dq42=dq(4);dy=dq(5);dz=dq(6);dq1=dq(7);');
end

fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['D=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=D(i,j);
        if Temp0 ~= 0
            Temp1=char(Temp0);
            Temp2=['D(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['C=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=C(i,j);
        if Temp0 ~= 0
            %ttt = char(vectorize(jac_P(2)));
            Temp1=char(Temp0);
            Temp2=['C(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['G=zeros(',num2str(n),',1);']);
for i=1:n
    Temp1=char(G(i));
    Temp2=['G(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['Fv=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    Temp1=char(Fv(i,i));
    Temp2=['Fv(',num2str(i),',',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['Fs=zeros(',num2str(n),',1);']);
for i=1:n
    Temp1=char(Fs(i));
    Temp2=['Fs(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['Ia=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    Temp1=char(Ia(i,i));
    Temp2=['Ia(',num2str(i),',',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['J=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=J(i,j);
        if Temp0 ~= 0
            %ttt = char(vectorize(jac_P(2)));
            Temp1=char(Temp0);
            Temp2=['J(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['F=zeros(',num2str(n),',1);']);
for i=1:n
    Temp1=char(F(i));
    Temp2=['F(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['pc1dd=zeros(',num2str(mv),',1);']);
for i=1:mv
    Temp1=char(pc1dd(i));
    Temp2=['pc1dd(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end

fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['pc2dd=zeros(',num2str(mv),',1);']);
for i=1:mv
    Temp1=char(pc2dd(i));
    Temp2=['pc2dd(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['pc3dd=zeros(',num2str(mv),',1);']);
for i=1:mv
    Temp1=char(pc3dd(i));
    Temp2=['pc3dd(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end

return

ttt = char(vectorize(jac_P(2)));
fprintf(fid,'jac_P2 = %s;\n\n',fixlength(ttt,'*+-',65,'         '));
