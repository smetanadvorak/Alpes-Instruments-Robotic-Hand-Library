% TASK: Connect Matlab environment with Arduino.
% INPUT
%   comPort: index of the serial port Arduino is connected to
% OUTPUT
%   obj: serial element
%   flag: value used to check if when the script is compiled the serial 
%           element exists yet

function [obj, flag] = setupSerial(comPort)

flag = 1;

% Initialize Serial object
obj = serial(comPort);
set(obj,'DataBits',8);
set(obj,'StopBits',1);
set(obj,'BaudRate', 115200); % 115200, 57600, 14400, 1200
set(obj,'Parity','none');
fopen(obj);
a = 'b';

while (a~='a') 
    a = fread(obj,1,'uchar');
end
if (a=='a')
    disp('Serial read');
end
fprintf(obj,'%c','a');
pause(1);
fscanf(obj,'%u');

end
