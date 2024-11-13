#include <esp_now.h>
#include <WiFi.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
Adafruit_MPU6050 mpu;

/******************************** Variables ***************************************/
float ax = 0;
float ay = 0;
float az = 0;

float gx = 0;
float gy = 0;
float gz = 0;

float dt = 0;
float gyro_angle_x = 0;
float gyro_angle_y = 0;
float gyro_angle_z = 0;

float roll_1 = 0;
float pitch_1 = 0;

float pitch = 0;
float roll = 0;

float         last_x_angle = 0;  // These are the filtered angles
float         last_y_angle = 0;
float         last_z_angle = 0;  
unsigned long last_read_time = millis();

float angle_z = 0;
float alpha = 0.96;
float angle_x = 0;
float angle_y = 0;

// REPLACE WITH YOUR RECEIVER MAC Address
uint8_t broadcastAddress[] = {0xF4, 0x12, 0xFA, 0xCE, 0xF4, 0xA4};

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
Calibration calib_mpu = {-0.37, +0.02, -0.2, +0.02, -0.02, +0.0};

void set_last_read_angle_data(unsigned long time,float x, float y, float z)
{
  last_read_time = time;
  last_x_angle = x;
  last_y_angle = y;
  last_z_angle = z;
}

typedef struct struct_message
{
  char esp_no[1];
  float gyr_x;
  float gyr_y;
  float acc_x;
  float acc_y;
  float Pitch;
} struct_message;

// Create a struct_message called myData
struct_message myData;

esp_now_peer_info_t peerInfo;

// callback when data is sent
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status)
{
  //Serial.print("\r\nLast Packet Send Status:\t");
  //Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}
 
void setup()
{
  // Init Serial Monitor
  //Serial.begin(115200);
  // Serial.begin(500000);
  Serial.begin(921600);
 
  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  // Init ESP-NOW
  if (esp_now_init() != ESP_OK)
  {
    //Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Once ESPNow is successfully Init, we will register for Send CB to
  // get the status of Trasnmitted packet
  esp_now_register_send_cb(OnDataSent);
  
  // Register peer
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  peerInfo.channel = 0;  
  peerInfo.encrypt = false;
  
  // Add peer        
  if (esp_now_add_peer(&peerInfo) != ESP_OK)
  {
    //Serial.println("Failed to add peer");
    return;
  }

  // Try to initialize!
  if (!mpu.begin())
  {
    //Serial.println("Failed to find MPU6050 chip");
    while (1)
    {
      delay(10);
    }
  }
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  //delay(10);
}
 
void loop()
{
  // Get sensor readings from MPU6050
  unsigned long t_now = millis();
  sensors_event_t a, g,temp;
  mpu.getEvent(&a, &g, &temp);

  // Send accelerometer and gyro data to ESP32 #2
  // On the sender side (ESP32 #1), send data as a comma-separated string

  // Calibrating the sensor
  ax = a.acceleration.x + calib_mpu.cal_acc_x;
  ay = a.acceleration.y + calib_mpu.cal_acc_y;
  az = a.acceleration.z + calib_mpu.cal_acc_z;

  gx = g.gyro.x + calib_mpu.cal_gyr_x;
  gy = g.gyro.y + calib_mpu.cal_gyr_y;
  gz = g.gyro.z + calib_mpu.cal_gyr_z;

  // Compute the (filtered) gyro angles
  dt = (t_now - last_read_time)/1000.0;
  gyro_angle_x = gx*dt + last_x_angle;
  gyro_angle_y = gy*dt + last_y_angle;
  gyro_angle_z = gz*dt + last_z_angle;

  roll_1 = atan(ay/sqrt(ax *ax + az * az));
  pitch_1 = atan(-ax/ sqrt(ay * ay + az * az));

  roll = (roll_1*180)/3.14;
  pitch = (pitch_1*180)/3.14;

  // Apply the complementary filter to figure out the change in angle - choice of alpha is
  // estimated now.
  // Alpha depends on the sampling rate ...
  angle_x = alpha*gyro_angle_x + (1.0 - alpha)*roll;
  angle_y = alpha*gyro_angle_y + (1.0 - alpha)*pitch;

  set_last_read_angle_data(t_now, angle_x, angle_y, angle_z);

  //Serial.println("Sent sensor data");

  //Serial.println(angle_x);
  //Serial.println(angle_y);

  // Set values to send
  strcpy(myData.esp_no, "T");
  //myData.Roll = angle_x;
  myData.Pitch = angle_y;
  myData.acc_x = ax;
  myData.acc_y = ay;
  myData.gyr_x = gx;
  myData.gyr_y = gy;
  
  // Send message via ESP-NOW
  esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *) &myData, sizeof(myData));
   
  // if (result == ESP_OK)
  // {
  //   //Serial.println("Sent with success");
  // }
  // else
  // {
  //   //Serial.println("Error sending the data");
  // }
  delay(1);
}