int index = A3;
int adc_val = 0;
int n_avrg = 1;
float alpha = 0.1;
int s_prec = 9;

void setup() {
  Serial.begin(115200);
  
  //Test connection with PC
  Serial.println('a');
  char a = 'b';
  while (a != 'a')  
    a = Serial.read(); 
}

void loop() {
  if (Serial.available() && Serial.read() == 'R')
    { 
      adc_val = analogRead(index);
      // Exponential smoothing filter
      int s = alpha*adc_val + (1-alpha)*s_prec;
      s_prec = s;
      Serial.println(s);
    }
}
