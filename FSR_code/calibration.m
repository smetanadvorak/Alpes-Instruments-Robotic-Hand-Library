weights = [0, 0.5, 1.5, 2.7, 4.0, 5.3]'; %Newtons
adc_mean_values = [10, 52, 193, 406, 698, 877]';
adc_stds = [5, 9, 6.6, 3.6, nan]';

offset = adc_mean_values(1);

lin_model = fitlm(adc_mean_values - offset, weights);

figure(4); 
plot(adc_mean_values - offset, weights);
hold on
plot(adc_mean_values - offset, lin_model.Fitted);
legend('Acquired data','linear regression model');
title('Comparison data - built model');
ylabel('Force [N]');
xlabel('Sensor output');

adjusted_model = [0.0064, 0];
adjusted_predicted = (adc_mean_values - offset) * adjusted_model(1) + adjusted_model(2);
plot(adc_mean_values - offset, adjusted_predicted);

legend('Data', 'Linear fit', 'Adjusted fit (no offset)');

fprintf('\nLinear model: k = %d, b = %d\n', adjusted_model(1), adjusted_model(2));
