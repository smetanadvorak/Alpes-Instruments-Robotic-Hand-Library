function [output] = readTemp(s,command,number_output)
% Serial send read request to Arduino
fprintf(s,command);  

% Read value returned via Serial communication 
output = nan*zeros(number_output,1);
for i = 1:length(output)
    output(i) = fscanf(s,'%d');
end
