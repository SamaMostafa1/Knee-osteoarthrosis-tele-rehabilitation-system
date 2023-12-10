#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
Adafruit_MPU6050 mpu;

typedef struct Calibration
{
  char cal_acc_x;
  char cal_acc_y;
  char cal_acc_z;
  char cal_gyr_x;
  char cal_gyr_y;
  char cal_gyr_z;
} Calibration;

// Create an object from Calibration
Calibration calib_mpu = {-0.28, -0.09, -0.13, +0.05, +0, +0};

void setup()
{
  // Init Serial Monitor
  Serial.begin(115200);

  // Try to initialize!
  if (!mpu.begin())
  {
    Serial.println("Failed to find MPU6050 chip");
    while (1)
    {
      delay(10);
    }
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  delay(100);
}

void loop()
{
  sensors_event_t a, g,temp;
  mpu.getEvent(&a, &g, &temp);

  // float ax=a.acceleration.x;
  // float ay=a.acceleration.y;
  // float az=a.acceleration.z;

  // float gx = g.gyro.x;
  // float gy = g.gyro.y;
  // float gz = g.gyro.z;

  // Calibrating the sensor
  float ax = a.acceleration.x + calib_mpu.cal_acc_x;
  float ay = a.acceleration.y + calib_mpu.cal_acc_y;
  float az = a.acceleration.z + calib_mpu.cal_acc_z;

  float gx = g.gyro.x + calib_mpu.cal_gyr_x;
  float gy = g.gyro.y + calib_mpu.cal_gyr_y;
  float gz = g.gyro.z + calib_mpu.cal_gyr_z;

  Serial.print("Acc_x: ");
  Serial.println(ax);
  Serial.print("Acc_y: ");
  Serial.println(ay);
  Serial.print("Acc_z: ");
  Serial.println(az);
  Serial.print("Gyr_x: ");
  Serial.println(gx);
  Serial.print("Gyr_y: ");
  Serial.println(gy);
  Serial.print("Gyr_z: ");
  Serial.println(gz);
  
  delay(200);
}
