function data = computingDeterminant2Links(Obs)

f = waitbar(0,'1','Name','Computing determinant...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

setappdata(f,'canceling',0);

syms q1 q2 dq1 dq2 real
size = 10;
mask_q1 = linspace(0,pi/2, size);
mask_q2 = linspace((3/2)*pi,2*pi, size);
mask_dq1 = linspace(0,pi/2, size);
mask_dq2 = linspace(0,pi/2, size);

data = zeros(10000,5);

steps = size^4;
step = 1;

profile on;
for i = 1:length(mask_q1)
    for j = 1:length(mask_q2)
        for k = 1:length(mask_dq1)
            for l = 1:length(mask_dq2)
                
                % Check for clicked Cancel button
                if getappdata(f,'canceling')
                    break
                end

                % Determinant computation
                M = Obs;
                M = subs(M,{q1,q2,dq1,dq2},{mask_q1(i),mask_q2(j),mask_dq1(k),mask_dq2(l)});
                
                d = (M(3,4)*M(4,2)-M(3,2)*M(4,4))+(M(3,2)*M(4,3)-M(3,3)*M(4,2))+(M(3,1)*M(4,4)-M(3,4)*M(4,1))+(M(3,3)*M(4,1)-M(3,1)*M(4,3));
                data(step,:) = [mask_q1(i), mask_q2(j), mask_dq1(k), mask_dq2(l), double(d)];
                
                % Update waitbar and message
                percentage = floor((step/steps)*100);
                waitbar(step/steps,f,sprintf('%d',percentage))
                step = step + 1;
                
            end
        end
    end
end

profile report;
delete(f)
end