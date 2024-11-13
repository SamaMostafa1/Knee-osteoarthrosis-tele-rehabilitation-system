#include <esp_now.h>
#include <WiFi.h>

unsigned long startTime;
double elapsedTime_1 = 0;

bool header_flag = true;

// Structure example to receive data
// Must match the sender structure
typedef struct struct_message
{
  char esp_no[1];
  float gyr_x;
  float gyr_y;
  float acc_x;
  float acc_y;
  float Pitch;
} struct_message;

float pitch_1 = 0;
float pitch_2 = 0;

float acc_x_T = 0;
float acc_y_T = 0;
float gyr_x_T = 0;
float gyr_y_T = 0;

float acc_x_C = 0;
float acc_y_C = 0;
float gyr_x_C = 0;
float gyr_y_C = 0;

// Create a struct_message called myData
struct_message myData;

void setup()
{
  // Initialize Serial Monitor
  //Serial.begin(115200);
  //Serial.begin(500000);
  //Serial.begin(921600);
  Serial.begin(2000000);
  startTime = millis();
  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);
  // Init ESP-NOW
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }
  
  // Once ESPNow is successfully Init, we will register for recv CB to
  // get recv packer info
  esp_now_register_recv_cb(OnDataRecv);
}

// callback function that will be executed when data is received
void OnDataRecv(const uint8_t * mac, const uint8_t *incomingData, int len)
{
  memcpy(&myData, incomingData, sizeof(myData));
  
  if(myData.esp_no[0] == 'T')
  {
    pitch_1 = myData.Pitch;
    acc_x_T = myData.acc_x;
    acc_y_T = myData.acc_y;
    gyr_x_T = myData.gyr_x;
    gyr_y_T = myData.gyr_y;
    elapsedTime_1 =( (millis() - startTime) / 1000.0);
  }
  else
  {
    pitch_2 = myData.Pitch;
    acc_x_C = myData.acc_x;
    acc_y_C = myData.acc_y;
    gyr_x_C = myData.gyr_x;
    gyr_y_C = myData.gyr_y;
    double elapsedTime_2 =( (millis() - startTime) / 1000.0);
  }

  /*
   * Prints for the Headers for the CSV file
   */
  if(header_flag == true)
  {
    Serial.print("Time");
    Serial.print(",");
    Serial.println("Knee Angle");
    // Serial.print(",");
    // Serial.print("Acc_x_T");
    // Serial.print(",");
    // Serial.print("Acc_y_T");
    // Serial.print(",");
    // Serial.print("Gyr_x_T");
    // Serial.print(",");
    // Serial.print("Gyr_y_T");
    // Serial.print(",");
    // Serial.print("Acc_x_C");
    // Serial.print(",");
    // Serial.print("Acc_y_C");
    // Serial.print(",");
    // Serial.print("Gyr_x_C");
    // Serial.print(",");
    // Serial.print("Gyr_y_C");
    // Serial.print(",");
    // Serial.print("Thigh Pitch");
    // Serial.print(",");
    // Serial.println("Calf Pitch");
    header_flag = false;
  }

  Serial.print(elapsedTime_1);
  Serial.print(",");
  Serial.println(pitch_1 - pitch_2);
  // Serial.print(",");
  // Serial.print(acc_x_T);
  // Serial.print(",");
  // Serial.print(acc_y_T);
  // Serial.print(",");
  // Serial.print(gyr_x_T);
  // Serial.print(",");
  // Serial.print(gyr_y_T);
  // Serial.print(",");
  // Serial.print(acc_x_C);
  // Serial.print(",");
  // Serial.print(acc_y_C);
  // Serial.print(",");
  // Serial.print(gyr_x_C);
  // Serial.print(",");
  // Serial.print(gyr_y_C);
  // Serial.print(",");
  // Serial.print(pitch_1);
  // Serial.print(",");
  // Serial.println(pitch_2);

  //delay(10);
}
void loop()
{
  
}
