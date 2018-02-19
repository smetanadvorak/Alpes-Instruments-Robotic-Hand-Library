% TASK: Apply a limit value to the current writing on registre 8 (COEF_P).
% INPUTS
%   s: is the serial port associated to the hand
%   val: limit value of the current for all fingers.

function ecriture_limite_courant_tous_doigts(val,s)
    % Call the function which write the current limit only on the register
    % corresponding to one finger in a loop such that the limit is applyed
    % on all fingers
    for i = 0:5
        ecriture_limite_courant(i,val,s);
    end
end