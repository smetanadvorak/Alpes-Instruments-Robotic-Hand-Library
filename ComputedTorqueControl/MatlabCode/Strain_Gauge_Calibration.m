%% Strain gauge calibration

%% Data
% Applied weights
W = 0:0.05:0.45;
Newtons = W.*9.81;
% Measured voltage
idle_voltage = 1.98;
measured_voltage = [1.98, 2.21, 2.45, 2.67, 2.91, 3.14, 3.37,3.60, 3.83, 4.07];
V = measured_voltage - idle_voltage;
% Resistance
measured_resistance = 11.1;
offset_resistance = 1.2;
R = measured_resistance - offset_resistance;
% Amplifier gain
G = 4 + (60000/R);

%% Plotting
[p, ~, mu] = polyfit(V,Newtons, 1);
xfit = linspace(min(V),max(V),100);
yfit = polyval(p,  xfit, [], mu);
figure(1)
plot(xfit, yfit, 'b')
hold on
plot(V, Newtons, 'r','Marker','o');
ylabel('Newtons [N]')
xlabel('Voltage [V]')
title('Strain gauge calibration');
legend('Linear approximation','Acqired data');

%% Calibration parameters
m = (Newtons(end)-Newtons(1))/(V(end)-V(1));
q = Newtons(1)-m* V(1);

Calibrated_output = m.*V + q;

figure(2)
plot(V, Calibrated_output)
xlabel('Measured voltage [V]')
ylabel('Corresponding force [N]')

%%
idle_value = 306;
adc_values = [335, 366,396,427,458,488,518,550,580,610,640];
adc_values = adc_values - idle_value;
W = 0:0.05:0.55;
Newtons = W.*9.81;

m = (Newtons(end) - Newtons(1))/(adc_values(end) - adc_values(1));
q = Newtons(1)-m * adc_values(1);

%% new calibration
idle_value = 307;
adc_values = [338, 368,398,429,459,489,520,550,581,611,640];
adc_values = adc_values - idle_value;
W = 0:0.05:0.55;
Newtons = W.*9.81;

m = (Newtons(end) - Newtons(1))/(adc_values(end) - adc_values(1));
q = Newtons(1)-m * adc_values(1);
