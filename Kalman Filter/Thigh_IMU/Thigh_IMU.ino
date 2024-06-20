#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#define PI 3.14
Adafruit_MPU6050 mpu;

constexpr char WIFI_SSID[] = "Etisalat-HjHC";

// Receiver MAC Address
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

// Structure example to send data
// Must match the receiver structure
typedef struct struct_message
{
  char esp_no[1];
  float gyr_x;
  float gyr_y;
  float gyr_z;

  float acc_x;
  float acc_y;
  float acc_z;

  float Pitch;
} struct_message;

// Create a struct_message called myData
struct_message myData;

esp_now_peer_info_t peerInfo;

// Kalman filter variables
float Q_ANGLE = 0.001f;
float Q_BIAS = 0.003f;
float R_MEASURE = 0.03f;
float angle = 0.0f;
float bias = 0.0f;
float rate = 0.0f;
float P[2][2] = {{0.0f, 0.0f}, {0.0f, 0.0f}};
unsigned long last_read_time = millis();  // Move the variable here

// callback when data is sent
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status)
{
  // Serial.print("\r\nLast Packet Send Status:\t");
  // Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}



void setup()
{
  // Init Serial Monitor
  Serial.begin(500000);

  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  int32_t channel = getWiFiChannel(WIFI_SSID);

  // Set Wi-Fi channel
  esp_wifi_set_promiscuous(true);
  esp_wifi_set_channel(channel, WIFI_SECOND_CHAN_NONE);
  esp_wifi_set_promiscuous(false);

  // Init ESP-NOW
  if (esp_now_init() != ESP_OK)
  {
    // Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Once ESPNow is successfully Init, we will register for Send CB to
  // get the status of Transmitted packet
  esp_now_register_send_cb(OnDataSent);

  // Register peer
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  //peerInfo.channel = 0;
  peerInfo.encrypt = false;

  // Add peer
  if (esp_now_add_peer(&peerInfo) != ESP_OK)
  {
    // Serial.println("Failed to add peer");
    return;
  }

  // Try to initialize!
  if (!mpu.begin())
  {
    // Serial.println("Failed to find MPU6050 chip");
    while (1)
    {
      delay(10);
    }
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
}

void loop()
{
  // Get sensor readings from MPU6050
  unsigned long t_now = millis();
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  // Calibrating the sensor
  float ax = a.acceleration.x + calib_mpu.cal_acc_x;
  float ay = a.acceleration.y + calib_mpu.cal_acc_y;
  float az = a.acceleration.z + calib_mpu.cal_acc_z;

  float gx = g.gyro.x + calib_mpu.cal_gyr_x;
  float gy = g.gyro.y + calib_mpu.cal_gyr_y;
  float gz = g.gyro.z + calib_mpu.cal_gyr_z;

  // Apply the Kalman filter to figure out the change in angle
  kalmanFilter(atan2(-ax, az), gy, (t_now - last_read_time) / 1000.0);

  // Set values to send
  strcpy(myData.esp_no, "T");
  myData.Pitch = angle*180.0 / PI;
  myData.acc_x = ax;
  myData.acc_y = ay;

  myData.acc_z = az;

  myData.gyr_x = gx;
  myData.gyr_y = gy;
  myData.gyr_z = gz;

  //Serial.println(myData.Pitch);

  // Send message via ESP-NOW
  esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *)&myData, sizeof(myData));

  // Update the last_read_time variable
  last_read_time = t_now;

  delay(1);
}

void kalmanFilter(float newAngle, float newRate, float dt)
{
  float S;
  float K[2];
  float y;

  // Time Update ("Predict")
  rate = newRate - bias;
  angle += dt * rate;

  P[0][0] += dt * (dt * P[1][1] - P[0][1] - P[1][0] + Q_ANGLE);
  P[0][1] -= dt * P[1][1];
  P[1][0] -= dt * P[1][1];
  P[1][1] += Q_BIAS * dt;

  // Measurement Update ("Correct")
  S = P[0][0] + R_MEASURE;
  K[0] = P[0][0] / S;
  K[1] = P[1][0] / S;

  y = newAngle - angle;
  angle += K[0] * y;
  bias += K[1] * y;

  P[0][0] -= K[0] * P[0][0];
  P[0][1] -= K[0] * P[0][1];
  P[1][0] -= K[1] * P[0][0];
  P[1][1] -= K[1] * P[0][1];
}

int32_t getWiFiChannel(const char *ssid) {
  if (int32_t n = WiFi.scanNetworks()) {
      for (uint8_t i=0; i<n; i++) {
          if (!strcmp(ssid, WiFi.SSID(i).c_str())) {
              return WiFi.channel(i);
          }
      }
  }
  return 0;
}