%
%
% File to automatically build up the .m-files needed for our simualtor
%

%load Mat/work_symb_model_abs;
%fcn_name = 'dyn_mod_abs';

disp(['[creating ',upper(fcn_name),'.m]']);f
fid = fopen([fcn_name,'.m'],'w');
n=max(size(x));
fprintf(fid,['function [Obs] = ' ...
        ' %s(q,dq,ddq)\n'],fcn_name);
fprintf(fid,'%%%s\n\n',upper(fcn_name));
fprintf(fid,'%%%s\n\n',datestr(now));
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%% Authors: Alexander Yannick  and Franck');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%% Model NOTATION: Spong and Vidyasagar, page 142, Eq. (6.3.12)');
fprintf(fid,'\n%s','%%                 D(q)ddq + C(q,dq)*dq + G(q) = B*tau');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','[g,L1,L2,m1,m2,I1,I2,s1,s2,R1,R2,b1,b2] = modelParameters;');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s','%%');

fprintf(fid,'\n%s','q1=q(1);q2=q(2);');
fprintf(fid,'\n%s','dq1=dq(1);dq2=dq(2);');
fprintf(fid,'\n%s','ddq1=ddq(1);ddq2=ddq(2);');

fprintf(fid,'\n%s','%%');
fprintf(fid,'\n%s',['Obs=zeros(',num2str(10),',',num2str(10),');']);
for i=1:n
    for j=1:n
        Temp0=Obs(i,j);
        if Temp0 ~= 0
            Temp1=char(Temp0);
            Temp2=['Obs(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','return');
status = fclose(fid)

return

