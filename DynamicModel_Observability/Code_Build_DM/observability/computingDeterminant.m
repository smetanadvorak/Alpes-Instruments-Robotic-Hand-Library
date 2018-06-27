function data = computingDeterminant(Obs)

f = waitbar(0,'1','Name','Computing determinant...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

setappdata(f,'canceling',0);

syms q1 q2 q3 dq1 dq2 dq3 real
size = 10;
mask_q1 = linspace(0, pi/2, size);
mask_q2 = linspace(0, pi/2, size);
mask_q3 = linspace(0, pi/2, size);
mask_dq1 = linspace(0, pi/2, size);
mask_dq2 = linspace(0, pi/2, size);
mask_dq3 = linspace(0, pi/2, size);

% data = zeros(10^6,7);
data = zeros(10,10,10,10,10,10);

steps = size^4;
step = 1;

profile on;
for i = 1:length(mask_q1)
    M = Obs;
    M = subs(M,q1,mask_q1(i));
    for j = 1:length(mask_q2)
        M1 = M;
        M1 = subs(M1,q2,mask_q2(j));
        for k = 1:length(mask_q3)
            M2 = M1;
            M2 = subs(M2,q3,mask_q3(k));
            for l = 1:length(mask_dq1)
                M3 = M2;
                M3 = subs(M3,dq1,mask_dq1(l));
                for m = 1:length(mask_dq2)
                    M4 = M3;
                    M4 = subs(M4,dq2,mask_dq2(m));
                    for n = 1:length(mask_dq3)
                        
                        % Check for clicked Cancel button
                        if getappdata(f,'canceling')
                            break
                        end

                        M5 = M4;
                        M5 = subs(M5,dq3,mask_dq3(n));
                        %M = subs(M,{q1,q2,q3,dq1,dq2,dq3},{mask_q1(i),mask_q2(j),mask_q3(k),mask_dq1(l),mask_dq2(m),mask_dq2(n)});
                        
                        % Determinant computation
                        O = double(M5);
                        % data(step,:) = [mask_q1(i),mask_q2(j),mask_q3(k),mask_dq1(l),mask_dq2(m),mask_dq3(n), d];
                        data(i,j,k,l,m,n) = Det_algo(O);
                        
                        % Update waitbar and message
                        percentage = floor((step/steps)*100);
                        waitbar(step/steps,f,sprintf('%d',percentage))
                        step = step + 1;
                        
                    end
                end
            end
        end
    end
end

profile report;
delete(f)
end