% TASK: read the 3rd register containing the LIMITE_COURANT_DEFAUT value.
% INPUT
%   s: serial port associated to the hand
%   doigt: integer number associated to the finger

function data = read_LIMITE_COURANT_DEFAUT(doigt, s)

    register_number = 3;
    data = lecture_register(doigt, register_number, s);
    
end