function [ newtones ] = adc_to_newtons( adc_value, adc_offset )
% This function receives the adc-measured value and outputs the force in
% Newtons. Force sensor is Flexiforce A201 of type 1 (1 lbs),
% connected to Arduino's ADC via Flexiforce QuickStart board. Calibration
% is made using five points and scales from 0 to 5.3 Newtons. Fit is
% linear with zero constant value.
% Pass ADC value (between 0 and 1023) and its offset measured with
% no load on the sensor (default is 10, but may vary depending on sensor
% orientation with respect to gravity vector and current phase of Jupiter). 

if nargin < 2
    adc_offset = 10;
end

lin_model = [0.0064, 0];
newtones = (adc_value - adc_offset) * lin_model(1) + lin_model(2); 
newtones = max(0, newtones);

end

