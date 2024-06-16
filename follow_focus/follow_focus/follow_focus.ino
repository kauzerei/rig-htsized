const char motor_step=2;
const char motor_dir=3;
const char encoder_a=4;
const char encoder_b=5;

void setup() {
  pinMode(motor_step,OUTPUT);
  pinMode(motor_dir,OUTPUT);
  pinMode(encoder_a,INPUT_PULLUP);
  pinMode(encoder_b,INPUT_PULLUP);
}

void loop() {
}
