% TASK: Compute the integral of a quantity using the Euler's method.
%       y'(t)=f(t,y(t)),    y(t0)=y0
%       y_n+1 = y_n + h*f(t_n,y_n)

function E = Euler(E_previous, y_actual, h)

    E = E_previous + h*y_actual;
    
end