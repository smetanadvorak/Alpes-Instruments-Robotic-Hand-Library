% TASK: Implement the ExponentialSmoothingFilter on the sensor measurements
% INPUTS
%   measurement: new measurement from sensor
%   s_prec: previous measurement from sensor
%   alpha: smoothing factor [0,1]

function s = ExponentialSmoothingFilter (measurement, s_prec, alpha)

    s = alpha*measurement + (1-alpha)*s_prec;
    
end