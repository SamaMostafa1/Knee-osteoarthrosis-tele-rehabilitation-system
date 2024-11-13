#include <WiFi.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#define PI  3.14
Adafruit_MPU6050 mpu;

// const char* ssid = "STUDBME2";
// const char* password = "BME2Stud";
const char* ssid = "Mi Note 10 Lite";
const char* password = "misara246";
const char* serverAddress = "192.168.158.102"; // Change to ESP32 #2's IP address
const int serverPort = 4080;

typedef struct Calibration
{
  float cal_acc_x;
  float cal_acc_y;
  float cal_acc_z;
  float cal_gyr_x;
  float cal_gyr_y;
  float cal_gyr_z;
} Calibration;

// Create an object from Calibration
Calibration calib_mpu = {-0.47, +0.14, +0.9, +0.04, +0, -0.01};

float         last_x_angle=0;  // These are the filtered angles
float         last_y_angle=0;
float         last_z_angle=0;  
unsigned long last_read_time=millis(); 

void set_last_read_angle_data(unsigned long time,float x, float y, float z)
{
  last_read_time = time;
  last_x_angle = x;
  last_y_angle = y;
  last_z_angle = z;
}



float elapsedTime, currentTime, previousTime;

WiFiClient TCPclient;

void setup()
{
  Serial.begin(115200);
  while (!Serial);
  Serial.println("ESP32 #1: TCP CLIENT SENDING SENSOR DATA");

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(10);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Connect to TCP server (ESP32 #2)
  if (TCPclient.connect(serverAddress, serverPort)) {
    Serial.println("Connected to TCP server");
  } else {
    Serial.println("Failed to connect to TCP server");
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  delay(10);
}

void loop()
{
  if (!TCPclient.connected())
  {
    Serial.println("Connection is disconnected");
    TCPclient.stop();

    // Reconnect to TCP server (ESP32 #2)
    if (TCPclient.connect(serverAddress, serverPort))
    {
      Serial.println("Reconnected to TCP server");
    }
    else
    {
      Serial.println("Failed to reconnect to TCP server");
    }
  }


  // Get sensor readings from MPU6050
  unsigned long t_now = millis();
  sensors_event_t a, g,temp;
  mpu.getEvent(&a, &g, &temp);

  // Send accelerometer and gyro data to ESP32 #2
  // On the sender side (ESP32 #1), send data as a comma-separated string

  // Calibrating the sensor
  float ax = a.acceleration.x + calib_mpu.cal_acc_x;
  float ay = a.acceleration.y + calib_mpu.cal_acc_y;
  float az = a.acceleration.z + calib_mpu.cal_acc_z;

  float gx = g.gyro.x + calib_mpu.cal_gyr_x;
  float gy = g.gyro.y + calib_mpu.cal_gyr_y;
  float gz = g.gyro.z + calib_mpu.cal_gyr_z;  

  // Compute the (filtered) gyro angles
  float dt =(t_now - last_read_time)/1000.0;
  float gyro_angle_x = gx*dt + last_x_angle;
  float gyro_angle_y = gy*dt + last_y_angle;
  float gyro_angle_z = gz*dt + last_z_angle;

  float roll_1 = atan(ay/sqrt(ax *ax + az * az));
  float pitch_1 = atan(-ax/ sqrt(ay * ay + az * az));
  
  float pitch = 0;
  float roll = 0;

  roll = (roll_1*180) / PI;
  pitch = (pitch_1*180) / PI;

  // Send accelerometer and gyro data to ESP32 #2
  // On the sender side (ESP32 #1), send data as a comma-separated string

  String dataToSend = "AccX: " + String(a.acceleration.x) +
                     ", AccY: " + String(a.acceleration.y) +
                     ", AccZ: " + String(a.acceleration.z);


  TCPclient.print(dataToSend);
  TCPclient.println(); // Add a newline character to indicate the end of the data

  //TCPclient.print("AccX: ");
  //TCPclient.print(a.acceleration.x);
  //TCPclient.print(", AccY: ");
  //TCPclient.print(a.acceleration.y);
  //TCPclient.print(", AccZ: ");
  //TCPclient.print(a.acceleration.z);
  //TCPclient.print(", GyroX: ");
  //TCPclient.print(g.gyro.x);
  //TCPclient.print(", GyroY: ");
  //TCPclient.print(g.gyro.y);
  //TCPclient.print(", GyroZ: ");
  //TCPclient.print(g.gyro.z);
  //TCPclient.println();

  // Flush the data to send it
  TCPclient.flush();

  //Serial.println("Sent sensor data");

  delay(10); // Send sensor data every 5 seconds
}