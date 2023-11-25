#include <esp_now.h>
#include <WiFi.h>


// Structure example to receive data
// Must match the sender structure
typedef struct struct_message {
    char esp_no[1];
    float Roll;
    float Pitch;
} struct_message;

float roll_1 = 0;
float roll_2 = 0;

float pitch_1 = 0;
float pitch_2 = 0;

float angle_r;
float angle_p;

// Create a struct_message called myData
struct_message myData;

// callback function that will be executed when data is received
void OnDataRecv(const uint8_t * mac, const uint8_t *incomingData, int len)
{
  memcpy(&myData, incomingData, sizeof(myData));
  Serial.print("Bytes received: \n ");
  if(myData.esp_no[0] == 'T')
  {
    roll_1 = myData.Roll;
    pitch_1 = myData.Pitch;

    Serial.print("Thigh roll: ");
    Serial.println(roll_1);
    Serial.print("thigh pitch");
    Serial.println(pitch_1);
  }
  else
  {
    roll_2 = myData.Roll;
    pitch_2 = myData.Pitch;

    Serial.print("Calf roll: ");
    Serial.println(roll_2);
    Serial.print("Calf pitch");
    Serial.println(pitch_2);
  }
  // delay(1000);
  // Serial.print("ESP No: ");
  // Serial.println(myData.esp_no);
  // Serial.print("Roll: ");
  // Serial.println(myData.Roll);
  // Serial.print("Pitch: ");
  // Serial.println(myData.Pitch);
  Serial.print("Angle_R: ");
  Serial.println(roll_1 - roll_2);
  Serial.print("Angle_P: ");
  Serial.println(pitch_1 - pitch_2);
  delay(1000);
}
 
void setup() {
  // Initialize Serial Monitor
  Serial.begin(115200);
  
  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);
  // Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }
  
  // Once ESPNow is successfully Init, we will register for recv CB to
  // get recv packer info
  esp_now_register_recv_cb(OnDataRecv);
}
 
void loop() {

}