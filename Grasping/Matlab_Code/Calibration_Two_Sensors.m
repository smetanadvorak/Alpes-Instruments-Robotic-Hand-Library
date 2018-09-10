function newton_data = Calibration_Two_Sensors(adc_data)

    linmodel_sensor_1 = [0.0043, -0.4169];
    linmodel_sensor_2 = [0.0054, -0.5288];
    offset = [-0.0251, -0.0368];
    newton_data(1) = linmodel_sensor_1(1)*adc_data(1) + linmodel_sensor_1(2);
    newton_data(2) = linmodel_sensor_2(1)*adc_data(2) + linmodel_sensor_2(2);

    newton_data = newton_data - offset;
    newton_data = max(0, newton_data);
end

