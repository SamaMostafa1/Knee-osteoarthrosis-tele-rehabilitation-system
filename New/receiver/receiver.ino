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
    float Roll;
    float Pitch;
} struct_message;

float roll_1 = 0;
float roll_2 = 0;

float pitch_1 = 0;
float pitch_2 = 0;

// Create a struct_message called myData
struct_message myData;

void setup()
{
  // Initialize Serial Monitor
  Serial.begin(115200);
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
  //Serial.print("Bytes received: \n ");
  if(myData.esp_no[0] == 'T')
  {
    roll_1 = myData.Roll;
    pitch_1 = myData.Pitch;
    elapsedTime_1 =( (millis() - startTime) / 1000.0);
  }
  else
  {
    roll_2 = myData.Roll;
    pitch_2 = myData.Pitch;
    double elapsedTime_2 =( (millis() - startTime) / 1000.0);
  }

  /*
   * Prints for the Headers for the CSV file
   */
  if(header_flag == true)
  {
    Serial.print("Time");
    Serial.print(",");
    Serial.print("Knee Angle");
    Serial.print(",");
    Serial.print("Thigh Roll");
    Serial.print(",");
    Serial.print("Thigh Pitch");
    Serial.print(",");
    Serial.print("Calf Roll");
    Serial.print(",");
    Serial.println("Calf Pitch");
    header_flag = false;
  }

  Serial.print(elapsedTime_1);
  Serial.print(",");
  Serial.print(pitch_1 - pitch_2);
  Serial.print(",");
  Serial.print(roll_1);
  Serial.print(",");
  Serial.print(pitch_1);
  Serial.print(",");
  Serial.print(roll_2);
  Serial.print(",");
  Serial.println(pitch_2);

  delay(10);
}
void loop()
{
  
}
