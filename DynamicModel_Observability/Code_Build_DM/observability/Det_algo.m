% TASK: Compute the determinant of a squared matrix only

function D = Det_algo(A)

if max(size(A))==2
    D = (A(1,1)*A(2,2))-(A(1,2)*A(2,1));
else
    for i=1:size(A,1)
        D_temp=A;
        D_temp(1,:)=[];
        D_temp(:,i)=[];
        if i==1
            D=(A(1,i)*((-1)^(i+1))*Det_algo(D_temp));
        else
            D=D+(A(1,i)*((-1)^(i+1))*Det_algo(D_temp));
        end
    end
end
end

%% Other way
% function det = determinant(M,max)
% det = 0;
% temp = zeros(max,max);
% if max == 2
%     det = (M(1,1)*M(2,2))-(M(1,2)*M(2,1));
% end
% 
% for p = 1:max
%     h = 1;
%     k = 1;
%     for i = 2:max
%         for j = 1:max
%             if j == p
%                 continue
%             end
%             temp(h,k) = M(i,j);
%             k = k+1;
%             if k == max
%                 h = h + 1;
%                 k = 1;
%             end
%         end
%     end
%     det = det + M(1,p)*(-1)^(p+1)*determinant(temp,max-1);
% end
% end